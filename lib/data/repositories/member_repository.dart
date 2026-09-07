import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/family_member.dart';

class MemberRepository {
  MemberRepository(this._store);

  final LocalStore _store;

  List<FamilyMember> load() {
    _ensureSeed();
    return _store
        .readList(LocalStore.membersKey)
        .map(FamilyMember.fromJson)
        .toList();
  }

  Future<void> saveAll(List<FamilyMember> members) {
    return _store.writeList(
      LocalStore.membersKey,
      members.map((m) => m.toJson()).toList(),
    );
  }

  void _ensureSeed() {
    if (_store.isSeeded) return;
    // Seeding is coordinated by EventRepository to avoid races.
  }
}
