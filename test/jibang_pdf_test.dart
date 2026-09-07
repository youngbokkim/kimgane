import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:kimgane/core/utils/jibang_pdf_service.dart';
import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/seed/seed_data.dart';
import 'package:pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('지방 PDF가 한자를 그릴 수 있는 폰트를 갖는다', () async {
    final data = await rootBundle.load('assets/fonts/NotoSerifKR-Hanja.ttf');
    final font = TtfParser(data);
    const sample = '顯祖考學生府君神位顯祖妣孺人尙山朴氏紙榜顯伯父海州吳氏';
    for (final rune in sample.runes) {
      expect(
        font.charToGlyphIndexMap.containsKey(rune),
        isTrue,
        reason: 'U+${rune.toRadixString(16)} ${String.fromCharCode(rune)}',
      );
    }
  });

  test('할아버지·할머니 지방 PDF를 생성한다', () async {
    final jibang = JibangComposer();
    final grandfather = SeedData.members().firstWhere(
      (m) => m.kinship == Kinship.grandfather,
    );
    final grandmother = SeedData.members().firstWhere(
      (m) => m.kinship == Kinship.grandmother,
    );
    final bytes = await JibangPdfService().buildPdf(
      people: jibang.pairFor([grandfather, grandmother]),
      useHanja: true,
    );
    expect(bytes.length, greaterThan(1000));
  });

  test('할아버지·할머니 축문 PDF를 A4 가로로 만든다', () async {
    final jibang = JibangComposer();
    final members = SeedData.members();
    final grandfather = members.firstWhere(
      (m) => m.kinship == Kinship.grandfather,
    );
    final grandmother = members.firstWhere(
      (m) => m.kinship == Kinship.grandmother,
    );
    final chukmun = ChukmunComposer(LunarService()).compose(
      ancestors: [grandfather, grandmother],
      events: SeedData.events(),
      now: DateTime(2026, 1, 1),
    );
    final bytes = await JibangPdfService().buildPdf(
      people: jibang.pairFor([grandfather, grandmother]),
      useHanja: true,
      chukmun: chukmun,
    );
    expect(bytes.length, greaterThan(1000));
  });
}
