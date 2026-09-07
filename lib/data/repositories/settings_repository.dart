import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/app_settings.dart';
import 'package:kimgane/data/seed/seed_data.dart';

class SettingsRepository {
  SettingsRepository(this._store);

  final LocalStore _store;

  AppSettings load() {
    final map = _store.readMap(LocalStore.settingsKey);
    if (map == null) return SeedData.settings;
    return AppSettings.fromJson(map);
  }

  Future<void> save(AppSettings settings) {
    return _store.writeMap(LocalStore.settingsKey, settings.toJson());
  }
}
