import 'package:kimgane/data/models/enums.dart';

class FamilyEvent {
  const FamilyEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.calendarKind,
    required this.month,
    required this.day,
    this.year,
    this.isLeapMonth = false,
    this.isRecurring = true,
    this.memberId,
    this.jesaKind,
    this.gyeongjosaKind,
    this.ancestorIds = const [],
    this.notes,
    required this.createdAt,
  });

  final String id;
  final EventType type;
  final String title;
  final CalendarKind calendarKind;
  final int? year;
  final int month;
  final int day;
  final bool isLeapMonth;
  final bool isRecurring;
  final String? memberId;
  final JesaKind? jesaKind;
  final GyeongjosaKind? gyeongjosaKind;
  final List<String> ancestorIds;
  final String? notes;
  final DateTime createdAt;

  FamilyEvent copyWith({
    EventType? type,
    String? title,
    CalendarKind? calendarKind,
    int? year,
    bool clearYear = false,
    int? month,
    int? day,
    bool? isLeapMonth,
    bool? isRecurring,
    String? memberId,
    JesaKind? jesaKind,
    GyeongjosaKind? gyeongjosaKind,
    List<String>? ancestorIds,
    String? notes,
  }) {
    return FamilyEvent(
      id: id,
      type: type ?? this.type,
      title: title ?? this.title,
      calendarKind: calendarKind ?? this.calendarKind,
      year: clearYear ? null : (year ?? this.year),
      month: month ?? this.month,
      day: day ?? this.day,
      isLeapMonth: isLeapMonth ?? this.isLeapMonth,
      isRecurring: isRecurring ?? this.isRecurring,
      memberId: memberId ?? this.memberId,
      jesaKind: jesaKind ?? this.jesaKind,
      gyeongjosaKind: gyeongjosaKind ?? this.gyeongjosaKind,
      ancestorIds: ancestorIds ?? this.ancestorIds,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'calendarKind': calendarKind.name,
    'year': year,
    'month': month,
    'day': day,
    'isLeapMonth': isLeapMonth,
    'isRecurring': isRecurring,
    'memberId': memberId,
    'jesaKind': jesaKind?.name,
    'gyeongjosaKind': gyeongjosaKind?.name,
    'ancestorIds': ancestorIds,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FamilyEvent.fromJson(Map<String, dynamic> json) {
    return FamilyEvent(
      id: json['id'] as String,
      type: EventType.values.byName(json['type'] as String),
      title: json['title'] as String,
      calendarKind: CalendarKind.values.byName(json['calendarKind'] as String),
      year: json['year'] as int?,
      month: json['month'] as int,
      day: json['day'] as int,
      isLeapMonth: json['isLeapMonth'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? true,
      memberId: json['memberId'] as String?,
      jesaKind: json['jesaKind'] == null
          ? null
          : JesaKind.values.byName(json['jesaKind'] as String),
      gyeongjosaKind: json['gyeongjosaKind'] == null
          ? null
          : GyeongjosaKind.values.byName(json['gyeongjosaKind'] as String),
      ancestorIds: (json['ancestorIds'] as List<dynamic>? ?? const [])
          .cast<String>(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
