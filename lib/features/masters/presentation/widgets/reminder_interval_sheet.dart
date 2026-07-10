import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../services/notification_service.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';

Future<void> showReminderIntervalSheet(BuildContext context, String masterId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => ReminderIntervalSheet(masterId: masterId),
  );
}

const _allIntervals = [30, 15, 7, 3, 1, 0];

class ReminderIntervalSheet extends ConsumerStatefulWidget {
  const ReminderIntervalSheet({super.key, required this.masterId});

  final String masterId;

  @override
  ConsumerState<ReminderIntervalSheet> createState() => _ReminderIntervalSheetState();
}

class _ReminderIntervalSheetState extends ConsumerState<ReminderIntervalSheet> {
  late final Set<int> _selected = {
    ...ref.read(favoritesRepositoryProvider).getEntry(widget.masterId)?.customReminderDaysBefore ??
        defaultReminderDaysBefore,
  };

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.masterId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remind me before the deadline', style: context.textStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              isFavorite
                  ? 'Choose when you want to be notified.'
                  : "Saving this program to Favorites turns on reminders — pick your schedule now.",
              style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allIntervals.map((days) {
                final label = days == 0 ? 'On the deadline day' : '$days days before';
                return FilterChip(
                  label: Text(label),
                  selected: _selected.contains(days),
                  onSelected: (v) => setState(() {
                    if (v) {
                      _selected.add(days);
                    } else {
                      _selected.remove(days);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () async {
                        final favoritesController = ref.read(favoritesControllerProvider);
                        if (!isFavorite) {
                          await favoritesController.toggle(widget.masterId);
                        }
                        final sorted = _selected.toList()..sort((a, b) => b.compareTo(a));
                        await favoritesController.updateReminderInterval(widget.masterId, sorted);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                child: const Text('Save reminders'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
