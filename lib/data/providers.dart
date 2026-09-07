import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/data/datasources/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final localStoreProvider = Provider<LocalStore>((ref) {
  return LocalStore(ref.watch(sharedPreferencesProvider));
});

final lunarServiceProvider = Provider<LunarService>((ref) => LunarService());
