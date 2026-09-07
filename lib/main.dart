import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kimgane/app.dart';
import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/providers.dart';
import 'package:kimgane/data/repositories/seed_coordinator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');
  final prefs = await SharedPreferences.getInstance();
  await SeedCoordinator(LocalStore(prefs)).seedIfNeeded();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: KimganeApp(),
    ),
  );
}
