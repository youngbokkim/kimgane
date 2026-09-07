import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/data/seed/seed_data.dart';

class SeedCoordinator {
  SeedCoordinator(this._store);

  final LocalStore _store;

  Future<void> seedIfNeeded() async {
    if (_store.isSeeded) return;
    await _store.writeList(
      LocalStore.membersKey,
      SeedData.members().map((m) => m.toJson()).toList(),
    );
    await _store.writeList(
      LocalStore.eventsKey,
      SeedData.events().map((e) => e.toJson()).toList(),
    );
    await _store.writeMap(LocalStore.settingsKey, SeedData.settings.toJson());
    await _store.markSeeded();
  }

  List<FamilyMember> members() => SeedData.members();
  List<FamilyEvent> events() => SeedData.events();
}
