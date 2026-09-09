import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:kimgane/core/utils/event_notification_planner.dart';
import 'package:kimgane/core/utils/occurrence_service.dart';
import 'package:kimgane/data/models/app_settings.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class EventNotificationService {
  EventNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  bool _unsupported = false;

  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> ensureReady() async {
    if (_ready || _unsupported || !isMobilePlatform) return;
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
      }

      const init = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      final ok = await _plugin.initialize(settings: init);
      if (ok == false) {
        _unsupported = true;
        return;
      }

      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();

      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      await ios?.requestPermissions(alert: true, badge: true, sound: true);

      _ready = true;
    } catch (_) {
      _unsupported = true;
    }
  }

  Future<void> sync({
    required List<FamilyEvent> events,
    required AppSettings settings,
    required OccurrenceService occurrences,
    DateTime? now,
  }) async {
    await ensureReady();
    if (!_ready) return;

    await _plugin.cancelAll();
    if (!settings.notifyEnabled) return;

    final planned = EventNotificationPlanner.plan(
      events: events,
      occurrences: occurrences,
      hour: settings.notifyHour,
      minute: settings.notifyMinute,
      now: now,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact = await android?.canScheduleExactNotifications() ?? false;
    final mode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kimgane_events',
        '일정 알림',
        channelDescription: '제사·생일·경조사를 하루 전과 당일 자정에 알려 줍니다.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    for (final item in planned) {
      await _plugin.zonedSchedule(
        id: item.id,
        title: item.title,
        body: item.body,
        scheduledDate: tz.TZDateTime.from(item.when, tz.local),
        notificationDetails: details,
        androidScheduleMode: mode,
        payload: item.eventId,
      );
    }
  }
}
