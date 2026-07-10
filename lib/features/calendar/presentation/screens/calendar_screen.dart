import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../masters/domain/entities/master.dart';
import '../../../masters/presentation/providers/master_providers.dart';
import '../../../masters/presentation/widgets/master_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = AppDateUtils.dateOnly(DateTime.now());

  Map<DateTime, List<Master>> _groupByDeadline(List<Master> masters) {
    final map = <DateTime, List<Master>>{};
    for (final m in masters) {
      final deadline = m.applicationDeadline;
      if (deadline == null) continue;
      final day = AppDateUtils.dateOnly(deadline);
      map.putIfAbsent(day, () => []).add(m);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final masters = ref.watch(mastersProvider);
    final grouped = _groupByDeadline(masters);
    final selected = grouped[_selectedDay] ?? const <Master>[];
    final favoriteIds = ref.watch(favoriteMasterIdsProvider);
    final controller = ref.read(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: context.horizontalPadding()),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar<Master>(
                firstDay: DateTime(2020, 1, 1),
                lastDay: DateTime(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => grouped[AppDateUtils.dateOnly(day)] ?? const [],
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: context.colors.primary.softer, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: context.colors.primary, shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(color: context.colors.error, shape: BoxShape.circle),
                ),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = AppDateUtils.dateOnly(selected);
                    _focusedDay = focused;
                  });
                },
                onPageChanged: (focused) => _focusedDay = focused,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selected.isEmpty
                ? const EmptyState(
                    icon: Icons.event_busy_rounded,
                    title: 'No deadlines this day',
                    message: 'Pick another date on the calendar above.',
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 8, context.horizontalPadding(), 24),
                    itemCount: selected.length,
                    itemBuilder: (context, i) {
                      final master = selected[i];
                      return FadeSlideIn(
                        index: i,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: MasterCard(
                            master: master,
                            isGrid: false,
                            isFavorite: favoriteIds.contains(master.id),
                            onToggleFavorite: () => controller.toggle(master.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
