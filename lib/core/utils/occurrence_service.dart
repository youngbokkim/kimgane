import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_event.dart';

class EventOccurrence {
  const EventOccurrence({
    required this.event,
    required this.solarDate,
    this.lunar,
    this.riteEvening,
  });

  final FamilyEvent event;
  final DateTime solarDate;
  final CalendarDate? lunar;
  final DateTime? riteEvening;

  int get dDay {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    return solarDate.difference(start).inDays;
  }
}

class OccurrenceService {
  OccurrenceService(this._lunar);

  final LunarService _lunar;

  DateTime? solarOnYear(FamilyEvent event, int year) {
    final y = event.isRecurring ? year : (event.year ?? year);
    try {
      if (event.calendarKind == CalendarKind.solar) {
        return DateTime(y, event.month, event.day);
      }
      return _lunar.lunarToSolar(
        year: y,
        month: event.month,
        day: event.day,
        isLeapMonth: event.isLeapMonth,
      );
    } catch (_) {
      return null;
    }
  }

  EventOccurrence? occurrenceForYear(FamilyEvent event, int year) {
    final solar = solarOnYear(event, year);
    if (solar == null) return null;
    if (!event.isRecurring && event.year != null && event.year != year) {
      return null;
    }
    final lunar = event.calendarKind == CalendarKind.lunar
        ? CalendarDate(
            year: year,
            month: event.month,
            day: event.day,
            isLeapMonth: event.isLeapMonth,
          )
        : _lunar.solarToLunar(solar);
    final riteEvening = event.type == EventType.jesa
        ? solar.subtract(const Duration(days: 1))
        : null;
    return EventOccurrence(
      event: event,
      solarDate: solar,
      lunar: lunar,
      riteEvening: riteEvening,
    );
  }

  List<EventOccurrence> upcoming(
    List<FamilyEvent> events, {
    DateTime? from,
    int days = 400,
  }) {
    final start = from ?? DateTime.now();
    final today = DateTime(start.year, start.month, start.day);
    final end = today.add(Duration(days: days));
    final result = <EventOccurrence>[];
    for (final event in events) {
      for (var year = today.year - 1; year <= end.year + 1; year++) {
        final occ = occurrenceForYear(event, year);
        if (occ == null) continue;
        if (!occ.solarDate.isBefore(today) && occ.solarDate.isBefore(end)) {
          result.add(occ);
        }
      }
    }
    result.sort((a, b) => a.solarDate.compareTo(b.solarDate));
    return result;
  }

  Map<DateTime, List<EventOccurrence>> byDay(
    List<FamilyEvent> events,
    DateTime month,
  ) {
    final map = <DateTime, List<EventOccurrence>>{};
    for (final year in {month.year - 1, month.year, month.year + 1}) {
      for (final event in events) {
        final occ = occurrenceForYear(event, year);
        if (occ == null) continue;
        if (occ.solarDate.year == month.year &&
            occ.solarDate.month == month.month) {
          final key = DateTime(
            occ.solarDate.year,
            occ.solarDate.month,
            occ.solarDate.day,
          );
          map.putIfAbsent(key, () => []).add(occ);
        }
      }
    }
    return map;
  }
}
