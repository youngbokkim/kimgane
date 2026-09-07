import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/event_type_badge.dart';

class EventListView extends ConsumerWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = [...ref.watch(eventsViewModelProvider)]
      ..sort((a, b) {
        final byType = a.type.index.compareTo(b.type.index);
        if (byType != 0) return byType;
        return a.month == b.month ? a.day.compareTo(b.day) : a.month.compareTo(b.month);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('일정')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/events/new'),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: events.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(_subtitle(event)),
              trailing: EventTypeBadge(
                type: event.type,
                kindLabel: event.jesaKind?.label ?? event.gyeongjosaKind?.label,
              ),
              onTap: () => context.push('/events/${event.id}'),
            ),
          );
        },
      ),
    );
  }

  String _subtitle(FamilyEvent event) {
    final leap = event.isLeapMonth ? '윤' : '';
    final y = event.year == null ? '' : '${event.year}. ';
    return '${event.calendarKind.label} $y$leap${event.month}. ${event.day}'
        '${event.isRecurring ? ' · 매년' : ''}';
  }
}
