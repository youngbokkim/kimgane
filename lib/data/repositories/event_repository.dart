import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/family_event.dart';

class EventRepository {
  EventRepository(this._store);

  final LocalStore _store;

  List<FamilyEvent> load() {
    return _store
        .readList(LocalStore.eventsKey)
        .map(FamilyEvent.fromJson)
        .toList();
  }

  Future<void> saveAll(List<FamilyEvent> events) {
    return _store.writeList(
      LocalStore.eventsKey,
      events.map((e) => e.toJson()).toList(),
    );
  }
}
