import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const membersKey = 'kimgane.members';
  static const eventsKey = 'kimgane.events';
  static const settingsKey = 'kimgane.settings';
  static const seededKey = 'kimgane.seeded';
  static const seedVersionKey = 'kimgane.seedVersion';
  static const currentSeedVersion = 2;

  bool get isSeeded {
    final version = _prefs.getInt(seedVersionKey) ?? 0;
    return version >= currentSeedVersion;
  }

  Future<void> markSeeded() async {
    await _prefs.setBool(seededKey, true);
    await _prefs.setInt(seedVersionKey, currentSeedVersion);
  }

  List<Map<String, dynamic>> readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? readMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }
}
