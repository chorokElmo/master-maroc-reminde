import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../documents/domain/entities/document_type.dart';
import '../../../documents/presentation/providers/document_providers.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../tracker/domain/entities/application_status.dart';
import '../../../tracker/presentation/providers/tracker_providers.dart';
import '../../domain/entities/master.dart';
import '../providers/master_providers.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/deadline_badge.dart';
import '../widgets/reminder_interval_sheet.dart';

class MasterDetailScreen extends ConsumerStatefulWidget {
  const MasterDetailScreen({super.key, required this.masterId});

  final String masterId;

  @override
  ConsumerState<MasterDetailScreen> createState() => _MasterDetailScreenState();
}

class _MasterDetailScreenState extends ConsumerState<MasterDetailScreen> {
  bool _enriching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyViewedIdsProvider.notifier).markViewed(widget.masterId);
      _maybeEnrich();
    });
  }

  Future<void> _maybeEnrich() async {
    final master = ref.read(masterByIdProvider(widget.masterId));
    if (master == null) return;
    if (master.applicationDeadline != null && master.requiredDocuments.isNotEmpty) return;

    setState(() => _enriching = true);
    try {
      await ref.read(masterRepositoryProvider).enrich(widget.masterId);
    } catch (_) {
      // Enrichment is best-effort — the listing-page fields already shown
      // to the user remain valid even if the detail-page fetch fails.
    } finally {
      if (mounted) setState(() => _enriching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final master = ref.watch(masterByIdProvider(widget.masterId));

    if (master == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Program not found')));
    }

    final isFavorite = ref.watch(isFavoriteProvider(master.id));
    final favoritesController = ref.read(favoritesControllerProvider);
    final missingDocs = ref.watch(missingDocumentsProvider(master.requiredDocuments));
    final trackerStatus = ref.watch(trackerForMasterProvider(master.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () => _share(master),
              ),
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(isFavorite),
                    color: isFavorite ? Colors.redAccent : null,
                  ),
                ),
                onPressed: () => favoritesController.toggle(master.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'master-image-${master.id}',
                child: master.image != null && master.image!.isNotEmpty
                    ? CachedNetworkImage(imageUrl: master.image!, fit: BoxFit.cover)
                    : Container(
                        color: context.colors.primary.softer,
                        child: Icon(Icons.school_rounded, size: 64, color: context.colors.primary),
                      ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 16, context.horizontalPadding(), 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(master.title, style: context.textStyles.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  [master.university, master.faculty, master.city].whereType<String>().join(' · '),
                  style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    DeadlineBadge(status: master.status),
                    if (master.needsReview) const ReviewFlagBadge(),
                    if (_enriching)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                  ],
                ),
                if (master.applicationDeadline != null) ...[
                  const SizedBox(height: 20),
                  CountdownTimer(deadline: master.applicationDeadline!),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => showReminderIntervalSheet(context, master.id),
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: const Text('Set Reminder'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (master.registrationLink != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _open(master.registrationLink!),
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Register'),
                        ),
                      ),
                  ],
                ),
                if (master.pdfLink != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _open(master.pdfLink!),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('Download PDF'),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                _SectionTitle('Overview'),
                Text(
                  master.description.isNotEmpty ? master.description : 'No description available yet.',
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                _SectionTitle('Admission Conditions'),
                Text(
                  master.requiredDegree ?? 'Not specified — check the official page for admission requirements.',
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                _SectionTitle('Required Documents'),
                if (master.requiredDocuments.isEmpty)
                  Text('Not specified yet.', style: context.textStyles.bodyMedium)
                else
                  ...master.requiredDocuments.map((doc) {
                    final missing = missingDocs.any((d) => d.label == doc);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            missing ? Icons.radio_button_unchecked_rounded : Icons.check_circle_rounded,
                            size: 20,
                            color: missing ? context.colors.onSurfaceVariant : Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(doc, style: context.textStyles.bodyMedium),
                          if (missing) ...[
                            const Spacer(),
                            Text('Missing', style: TextStyle(color: context.colors.error, fontSize: 12)),
                          ],
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 24),
                _SectionTitle('Important Dates'),
                _DateRow(label: 'Application opens', date: master.applicationStart),
                _DateRow(label: 'Application deadline', date: master.applicationDeadline),
                const SizedBox(height: 24),
                _SectionTitle('Application Progress'),
                _TrackerSelector(masterId: master.id, current: trackerStatus?.status),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _share(Master master) {
    final text = StringBuffer(master.title);
    if (master.university != null) text.write(' — ${master.university}');
    if (master.applicationDeadline != null) {
      text.write('\nDeadline: ${AppDateUtils.formatDate(master.applicationDeadline!)}');
    }
    if (master.registrationLink != null) text.write('\n${master.registrationLink}');
    Share.share(text.toString());
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: context.textStyles.titleMedium),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label, required this.date});
  final String label;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 18, color: context.colors.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(label, style: context.textStyles.bodyMedium),
          const Spacer(),
          Text(
            date != null ? AppDateUtils.formatDate(date!) : 'Not specified',
            style: context.textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TrackerSelector extends ConsumerWidget {
  const _TrackerSelector({required this.masterId, required this.current});
  final String masterId;
  final ApplicationStatus? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (current != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: current!.progress, minHeight: 8),
          ),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ApplicationStatus.values.map((status) {
            return ChoiceChip(
              label: Text(status.label),
              selected: current == status,
              onSelected: (_) => ref.read(trackerControllerProvider.notifier).setStatus(masterId, status),
            );
          }).toList(),
        ),
      ],
    );
  }
}
