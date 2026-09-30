import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/app_settings.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/data/seed/seed_data.dart';

class SeedCoordinator {
  SeedCoordinator(this._store);

  final LocalStore _store;

  Future<void> seedIfNeeded() async {
    if (_store.isSeeded) {
      await _patchHamyonghuiBonGwan();
      return;
    }
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

  Future<void> _patchHamyonghuiBonGwan() async {
    final raw = _store.readList(LocalStore.membersKey);
    var changed = false;
    final next = <Map<String, dynamic>>[];
    for (final map in raw) {
      if (map['id'] == SeedIds.hamyeonghui && map['bonGwan'] == '함양') {
        changed = true;
        next.add({...map, 'bonGwan': '강릉'});
      } else {
        next.add(map);
      }
    }
    if (changed) {
      await _store.writeList(LocalStore.membersKey, next);
    }
  }

  List<FamilyMember> members() => SeedData.members();
  List<FamilyEvent> events() => SeedData.events();
}
