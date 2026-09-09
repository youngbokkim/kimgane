import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';
import 'package:kimgane/core/utils/event_notification_service.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:kimgane/core/utils/occurrence_service.dart';
import 'package:kimgane/data/models/app_settings.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/data/providers.dart';
import 'package:kimgane/data/repositories/event_repository.dart';
import 'package:kimgane/data/repositories/member_repository.dart';
import 'package:kimgane/data/repositories/settings_repository.dart';
import 'package:uuid/uuid.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.watch(localStoreProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(localStoreProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(localStoreProvider));
});

final occurrenceServiceProvider = Provider<OccurrenceService>((ref) {
  return OccurrenceService(ref.watch(lunarServiceProvider));
});

final jibangComposerProvider = Provider<JibangComposer>((ref) {
  return JibangComposer();
});

final chukmunComposerProvider = Provider<ChukmunComposer>((ref) {
  return ChukmunComposer(ref.watch(lunarServiceProvider));
});

final eventNotificationServiceProvider = Provider<EventNotificationService>((
  ref,
) {
  return EventNotificationService();
});

final membersViewModelProvider =
    NotifierProvider<MembersViewModel, List<FamilyMember>>(
      MembersViewModel.new,
    );

class MembersViewModel extends Notifier<List<FamilyMember>> {
  @override
  List<FamilyMember> build() => ref.read(memberRepositoryProvider).load();

  Future<void> upsert(FamilyMember member) async {
    final next = [...state];
    final index = next.indexWhere((m) => m.id == member.id);
    if (index >= 0) {
      next[index] = member;
    } else {
      next.add(member);
    }
    state = next;
    await ref.read(memberRepositoryProvider).saveAll(next);
  }

  Future<void> remove(String id) async {
    final next = state.where((m) => m.id != id).toList();
    state = next;
    await ref.read(memberRepositoryProvider).saveAll(next);
  }

  FamilyMember? byId(String id) {
    for (final member in state) {
      if (member.id == id) return member;
    }
    return null;
  }
}

final eventsViewModelProvider =
    NotifierProvider<EventsViewModel, List<FamilyEvent>>(EventsViewModel.new);

class EventsViewModel extends Notifier<List<FamilyEvent>> {
  @override
  List<FamilyEvent> build() => ref.read(eventRepositoryProvider).load();

  Future<void> upsert(FamilyEvent event) async {
    final next = [...state];
    final index = next.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      next[index] = event;
    } else {
      next.add(event);
    }
    state = next;
    await ref.read(eventRepositoryProvider).saveAll(next);
  }

  Future<void> remove(String id) async {
    final next = state.where((e) => e.id != id).toList();
    state = next;
    await ref.read(eventRepositoryProvider).saveAll(next);
  }

  FamilyEvent? byId(String id) {
    for (final event in state) {
      if (event.id == id) return event;
    }
    return null;
  }

  String newId() => const Uuid().v4();
}

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, AppSettings>(SettingsViewModel.new);

class SettingsViewModel extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsRepositoryProvider).load();

  Future<void> update(AppSettings settings) async {
    final next = settings.copyWith(officiantId: SeedIds.officiant);
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}

class JibangState {
  const JibangState({this.selectedIds = const [], this.useHanja = true});

  final List<String> selectedIds;
  final bool useHanja;

  JibangState copyWith({List<String>? selectedIds, bool? useHanja}) {
    return JibangState(
      selectedIds: selectedIds ?? this.selectedIds,
      useHanja: useHanja ?? this.useHanja,
    );
  }
}

final jibangViewModelProvider = NotifierProvider<JibangViewModel, JibangState>(
  JibangViewModel.new,
);

class JibangViewModel extends Notifier<JibangState> {
  @override
  JibangState build() => const JibangState();

  void toggle(String id) {
    final next = [...state.selectedIds];
    if (next.contains(id)) {
      next.remove(id);
    } else {
      if (next.length >= 2) {
        next.removeAt(0);
      }
      next.add(id);
    }
    state = state.copyWith(selectedIds: next);
  }

  void setSelected(List<String> ids) {
    state = state.copyWith(selectedIds: ids.take(2).toList());
  }

  void setUseHanja(bool value) {
    state = state.copyWith(useHanja: value);
  }

  void clear() {
    state = const JibangState();
  }
}

final calendarMonthProvider =
    NotifierProvider<CalendarMonthViewModel, DateTime>(
      CalendarMonthViewModel.new,
    );

class CalendarMonthViewModel extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void setMonth(DateTime month) {
    state = DateTime(month.year, month.month);
  }
}

final upcomingProvider = Provider<List<EventOccurrence>>((ref) {
  final events = ref.watch(eventsViewModelProvider);
  return ref.watch(occurrenceServiceProvider).upcoming(events);
});
