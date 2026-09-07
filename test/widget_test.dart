import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kimgane/app.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/data/datasources/local_store.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/providers.dart';
import 'package:kimgane/data/repositories/seed_coordinator.dart';
import 'package:kimgane/data/seed/seed_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('ko_KR');
  });

  test('음력 제사 날짜를 양력으로 환산한다', () {
    final lunar = LunarService();
    final solar = lunar.lunarToSolar(year: 2026, month: 1, day: 1);
    expect(solar.year, 2026);
    expect(solar.month, 2);
    expect(solar.day, 17);
    final back = lunar.solarToLunar(solar);
    expect(back.month, 1);
    expect(back.day, 1);
    expect(back.isLeapMonth, isFalse);
  });

  test('할아버지·할머니 지방 문구를 가례대로 만든다', () {
    final jibang = JibangComposer();
    final grandfather = SeedData.members().firstWhere(
      (m) => m.kinship == Kinship.grandfather,
    );
    final grandmother = SeedData.members().firstWhere(
      (m) => m.kinship == Kinship.grandmother,
    );
    expect(jibang.compose(grandfather).hanja, '顯祖考學生府君神位');
    expect(jibang.compose(grandmother).hanja, '顯祖妣孺人尙山朴氏神位');
  });

  test('할아버지·할머니 축문을 한글 세로 문구로 만든다', () {
    final composer = ChukmunComposer(LunarService());
    final members = SeedData.members();
    final grandfather = members.firstWhere(
      (m) => m.kinship == Kinship.grandfather,
    );
    final grandmother = members.firstWhere(
      (m) => m.kinship == Kinship.grandmother,
    );
    final officiant = members.firstWhere((m) => m.kinship == Kinship.officiant);
    expect(officiant.name, '김영필');
    final text = composer.compose(
      ancestors: [grandfather, grandmother],
      events: SeedData.events(),
      now: DateTime(2026, 1, 1),
    );
    final joined = text.plainText;
    expect(joined, contains('병오년'));
    expect(joined, contains('칠월'));
    expect(joined, contains('스무닷새'));
    expect(joined, contains('효손'));
    expect(joined, contains('영필이'));
    expect(joined, isNot(contains('덕수')));
    expect(joined, contains('할아버지'));
    expect(joined, contains('할머니'));
    expect(joined, contains('기일'));
    expect(joined, contains('흠향'));
  });

  test('생존 가족은 기타 대신 생일을 보여 준다', () {
    final yeongpil = SeedData.members().firstWhere((m) => m.name == '김영필');
    final yeongok = SeedData.members().firstWhere((m) => m.name == '김영옥');
    expect(yeongpil.kinship, Kinship.officiant);
    expect(yeongpil.birthDateLabel, '음력 1월 20일');
    expect(yeongok.birthDateLabel, isNull);
  });

  testWidgets('홈에 김가네와 광산김씨가 보인다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await SeedCoordinator(LocalStore(prefs)).seedIfNeeded();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: KimganeApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('김가네'), findsWidgets);
    expect(find.textContaining('광산김씨'), findsWidgets);
    await tester.tap(find.text('광산김씨').first);
    await tester.pumpAndSettle();
    expect(find.text('직계선조 묘비'), findsOneWidget);
    expect(find.textContaining('가선대부'), findsWidgets);
    expect(find.text('제사 축문'), findsNothing);
  });

  testWidgets('가족 탭에서 생존은 생일이 보이고 제사 대상은 유지된다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await SeedCoordinator(LocalStore(prefs)).seedIfNeeded();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: KimganeApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('가족'));
    await tester.pumpAndSettle();
    expect(find.text('김영필'), findsOneWidget);
    expect(find.textContaining('제주(본인)'), findsWidgets);
    expect(find.textContaining('음력 1월 20일'), findsWidgets);
    expect(find.textContaining('기타'), findsNothing);
    await tester.scrollUntilVisible(find.text('김명룡'), 400);
    expect(find.text('김명룡'), findsOneWidget);
    expect(find.textContaining('할아버지'), findsWidgets);
    expect(find.textContaining('故'), findsWidgets);
  });

  testWidgets('지방 쓰기에서 축문이 자동으로 만들어진다', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await SeedCoordinator(LocalStore(prefs)).seedIfNeeded();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: KimganeApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('제례'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('지방 · 축문 쓰기'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '김명룡 (할아버지)'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '박천분 (할머니)'));
    await tester.pumpAndSettle();
    expect(find.text('축문'), findsWidgets);
    expect(find.textContaining('병오년'), findsWidgets);
    expect(find.textContaining('효손'), findsWidgets);
    expect(find.textContaining('영필이'), findsWidgets);
    expect(find.textContaining('덕수가'), findsNothing);
    expect(find.textContaining('할아버지'), findsWidgets);
    expect(find.textContaining('흠향'), findsWidgets);
  });
}
