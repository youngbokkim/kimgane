import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';

class EventTypeBadge extends StatelessWidget {
  const EventTypeBadge({super.key, required this.type, this.kindLabel});

  final EventType type;
  final String? kindLabel;

  Color get _color => switch (type) {
    EventType.birthday => AppColors.gold,
    EventType.jesa => AppColors.cinnabar,
    EventType.gyeongjosa => AppColors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      child: Text(
        kindLabel == null ? type.label : '${type.label} · $kindLabel',
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class CalendarKindBadge extends StatelessWidget {
  const CalendarKindBadge({super.key, required this.kind, this.leap = false});

  final CalendarKind kind;
  final bool leap;

  @override
  Widget build(BuildContext context) {
    return Text(
      leap && kind == CalendarKind.lunar ? '음력(윤달)' : kind.label,
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
