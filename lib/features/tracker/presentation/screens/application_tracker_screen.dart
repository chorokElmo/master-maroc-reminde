import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../masters/presentation/providers/master_providers.dart';
import '../../domain/entities/application_status.dart';
import '../providers/tracker_providers.dart';

class ApplicationTrackerScreen extends ConsumerWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = ref.watch(trackerGroupedByStatusProvider);
    final hasAny = grouped.values.any((list) => list.isNotEmpty);

    return Scaffold(
      appBar: AppBar(title: const Text('Application Tracker')),
      body: !hasAny
          ? const EmptyState(
              icon: Icons.checklist_rounded,
              title: 'Nothing tracked yet',
              message: 'Save a Master and set its status from the detail page to see it here.',
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 16, context.horizontalPadding(), 40),
              children: [
                for (final status in ApplicationStatus.values)
                  if (grouped[status]!.isNotEmpty) ...[
                    SectionHeader(title: status.label, subtitle: '${grouped[status]!.length} program(s)'),
                    ...grouped[status]!.map((progress) {
                      final master = ref.watch(masterByIdProvider(progress.masterId));
                      if (master == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: context.colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => context.push(AppRoutes.masterDetailPath(master.id)),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(master.title, style: context.textStyles.titleSmall),
                                  const SizedBox(height: 6),
                                  Text(
                                    master.university ?? master.faculty ?? master.city ?? '',
                                    style: context.textStyles.bodySmall
                                        ?.copyWith(color: context.colors.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(value: status.progress, minHeight: 6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
              ],
            ),
    );
  }
}
