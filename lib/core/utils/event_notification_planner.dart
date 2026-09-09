import 'package:kimgane/core/utils/occurrence_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_event.dart';

enum EventNotificationKind { dayBefore, sameDay }

class PlannedEventNotification {
  const PlannedEventNotification({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.eventId,
    required this.kind,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String eventId;
  final EventNotificationKind kind;
}

class EventNotificationPlanner {
  static const daysBefore = 1;
  static const defaultHour = 9;
  static const defaultMinute = 0;
  static const sameDayHour = 0;
  static const sameDayMinute = 0;
  static const maxPending = 60;

  static int notificationId(
    String eventId,
    int year,
    EventNotificationKind kind,
  ) {
    return Object.hash(eventId, year, kind.name) & 0x7fffffff;
  }

  static DateTime fireAt({
    required DateTime eventDay,
    required int hour,
    required int minute,
    int daysBefore = EventNotificationPlanner.daysBefore,
  }) {
    final day = DateTime(eventDay.year, eventDay.month, eventDay.day);
    return DateTime(
      day.year,
      day.month,
      day.day,
      hour,
      minute,
    ).subtract(Duration(days: daysBefore));
  }

  static DateTime sameDayFireAt(DateTime eventDay) {
    return DateTime(
      eventDay.year,
      eventDay.month,
      eventDay.day,
      sameDayHour,
      sameDayMinute,
    );
  }

  static List<PlannedEventNotification> plan({
    required List<FamilyEvent> events,
    required OccurrenceService occurrences,
    required int hour,
    required int minute,
    DateTime? now,
    int limit = maxPending,
  }) {
    final moment = now ?? DateTime.now();
    final planned = <PlannedEventNotification>[];
    for (final event in events) {
      for (var year = moment.year - 1; year <= moment.year + 2; year++) {
        final occ = occurrences.occurrenceForYear(event, year);
        if (occ == null) continue;
        final dateLabel =
            '${event.title} · ${occ.solarDate.month}월 ${occ.solarDate.day}일';

        final dayBefore = fireAt(
          eventDay: occ.solarDate,
          hour: hour,
          minute: minute,
        );
        if (dayBefore.isAfter(moment)) {
          planned.add(
            PlannedEventNotification(
              id: notificationId(
                event.id,
                occ.solarDate.year,
                EventNotificationKind.dayBefore,
              ),
              when: dayBefore,
              title: '내일 ${event.type.label}',
              body: dateLabel,
              eventId: event.id,
              kind: EventNotificationKind.dayBefore,
            ),
          );
        }

        final sameDay = sameDayFireAt(occ.solarDate);
        if (sameDay.isAfter(moment)) {
          planned.add(
            PlannedEventNotification(
              id: notificationId(
                event.id,
                occ.solarDate.year,
                EventNotificationKind.sameDay,
              ),
              when: sameDay,
              title: '오늘 ${event.type.label}',
              body: dateLabel,
              eventId: event.id,
              kind: EventNotificationKind.sameDay,
            ),
          );
        }
      }
    }
    planned.sort((a, b) => a.when.compareTo(b.when));
    if (planned.length <= limit) return planned;
    return planned.sublist(0, limit);
  }
}
