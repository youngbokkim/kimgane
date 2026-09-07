import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/core/utils/occurrence_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/providers.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/event_type_badge.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsViewModelProvider);
    final lunar = ref.watch(lunarServiceProvider);
    final occ = ref.watch(occurrenceServiceProvider);
    final month = DateTime(_focused.year, _focused.month);
    final byDay = occ.byDay(events, month);
    final monthEvents = byDay.entries
        .expand((entry) => entry.value)
        .toList()
      ..sort((a, b) => a.solarDate.compareTo(b.solarDate));
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    List<EventOccurrence> eventsOn(DateTime day) {
      return byDay[DateTime(day.year, day.month, day.day)] ?? const [];
    }

    Widget dayCell(DateTime day, {required bool selected, required bool isToday}) {
      return _DayCell(
        day: day,
        lunarText: _lunarDay(lunar.solarToLunar(day)),
        events: eventsOn(day),
        selected: selected,
        today: isToday,
        outside: day.month != _focused.month,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('달력')),
      body: ListView(
        children: [
          TableCalendar<EventOccurrence>(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2049, 12, 31),
            focusedDay: _focused,
            selectedDayPredicate: (day) => isSameDay(day, _selected),
            eventLoader: eventsOn,
            calendarFormat: CalendarFormat.month,
            rowHeight: 108,
            daysOfWeekHeight: 28,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontFamily: 'NanumMyeongjo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: true,
              markersMaxCount: 0,
              todayDecoration: BoxDecoration(),
              selectedDecoration: BoxDecoration(),
              cellMargin: EdgeInsets.all(2),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focused) =>
                  dayCell(day, selected: false, isToday: false),
              todayBuilder: (context, day, focused) =>
                  dayCell(day, selected: false, isToday: true),
              selectedBuilder: (context, day, focused) => dayCell(
                day,
                selected: true,
                isToday: isSameDay(day, today),
              ),
              outsideBuilder: (context, day, focused) =>
                  dayCell(day, selected: false, isToday: false),
              markerBuilder: (context, day, events) => const SizedBox.shrink(),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selected = selected;
                _focused = focused;
              });
            },
            onPageChanged: (focused) => setState(() => _focused = focused),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yyyy년 M월 일정', 'ko_KR').format(_focused),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  '오늘 일정은 다른 색으로 표시합니다.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 13),
                ),
                const SizedBox(height: 12),
                if (monthEvents.isEmpty)
                  const Text('이번 달 등록된 일정이 없습니다.')
                else
                  for (final item in monthEvents)
                    _MonthEventTile(
                      occurrence: item,
                      isToday: DateTime(
                            item.solarDate.year,
                            item.solarDate.month,
                            item.solarDate.day,
                          ) ==
                          todayKey,
                      dateLabel: DateFormat('M월 d일 (E)', 'ko_KR')
                          .format(item.solarDate),
                      lunarLabel: item.lunar == null
                          ? null
                          : _lunarDay(item.lunar!),
                      onTap: () => context.push('/events/${item.event.id}'),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _lunarDay(CalendarDate date) => '(음) ${date.month}.${date.day}';
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.lunarText,
    required this.events,
    this.selected = false,
    this.today = false,
    this.outside = false,
  });

  final DateTime day;
  final String lunarText;
  final List<EventOccurrence> events;
  final bool selected;
  final bool today;
  final bool outside;

  @override
  Widget build(BuildContext context) {
    final base = outside
        ? AppColors.inkMuted.withValues(alpha: 0.45)
        : (day.weekday == DateTime.sunday ? AppColors.cinnabarSoft : AppColors.ink);
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.fromLTRB(3, 4, 3, 3),
      decoration: BoxDecoration(
        color: today
            ? AppColors.pine.withValues(alpha: 0.14)
            : (selected ? AppColors.cinnabar.withValues(alpha: 0.08) : AppColors.hanjiCard),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: today
              ? AppColors.pine
              : (selected ? AppColors.cinnabar : AppColors.line),
          width: today || selected ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: today ? AppColors.pine : base,
                ),
              ),
              const Spacer(),
              Text(
                lunarText,
                style: TextStyle(
                  fontSize: 8,
                  color: today ? AppColors.pine : AppColors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          for (final item in events.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                item.event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: _eventColor(item.event.type),
                ),
              ),
            ),
          if (events.length > 3)
            Text(
              '+${events.length - 3}',
              style: const TextStyle(fontSize: 8, color: AppColors.inkMuted),
            ),
        ],
      ),
    );
  }

  Color _eventColor(EventType type) => switch (type) {
    EventType.birthday => const Color(0xFF8A6A18),
    EventType.jesa => AppColors.cinnabar,
    EventType.gyeongjosa => AppColors.indigo,
  };
}

class _MonthEventTile extends StatelessWidget {
  const _MonthEventTile({
    required this.occurrence,
    required this.isToday,
    required this.dateLabel,
    required this.onTap,
    this.lunarLabel,
  });

  final EventOccurrence occurrence;
  final bool isToday;
  final String dateLabel;
  final String? lunarLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isToday ? AppColors.pine.withValues(alpha: 0.12) : AppColors.hanjiCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isToday ? AppColors.pine : AppColors.line,
            width: isToday ? 1.4 : 1,
          ),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(
            occurrence.event.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isToday ? AppColors.pine : AppColors.ink,
            ),
          ),
          subtitle: Text(
            [
              if (isToday) '오늘',
              dateLabel,
              ?lunarLabel,
              occurrence.event.calendarKind.label,
            ].join(' · '),
          ),
          trailing: EventTypeBadge(
            type: occurrence.event.type,
            kindLabel: occurrence.event.jesaKind?.label ??
                occurrence.event.gyeongjosaKind?.label,
          ),
        ),
      ),
    );
  }
}
