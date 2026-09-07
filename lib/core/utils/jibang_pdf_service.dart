import 'package:flutter/services.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class JibangPdfService {
  Future<pw.Font> _load(String asset) async {
    final data = await rootBundle.load(asset);
    return pw.Font.ttf(data);
  }

  Future<({pw.Font base, pw.Font bold, pw.Font hanja})> _fonts() async {
    final base = await _load('assets/fonts/NanumMyeongjo-Regular.ttf');
    final bold = await _load('assets/fonts/NanumMyeongjo-Bold.ttf');
    final hanja = await _load('assets/fonts/NotoSerifKR-Hanja.ttf');
    return (base: base, bold: bold, hanja: hanja);
  }

  pw.TextStyle _style(pw.Font font, List<pw.Font> fallback, double size) {
    return pw.TextStyle(
      font: font,
      fontFallback: fallback,
      fontSize: size,
    );
  }

  Future<Uint8List> buildPdf({
    required List<JibangPersonText> people,
    required bool useHanja,
  }) async {
    final fonts = await _fonts();
    final fallback = [fonts.hanja, fonts.base, fonts.bold];
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fonts.base,
        bold: fonts.bold,
        fontFallback: fallback,
      ),
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '김가네 지방(紙榜)',
                style: _style(fonts.bold, fallback, 18),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                '가로 6cm · 세로 22cm 규격. 위는 둥글게(天圓), 아래는 바르게(地方) 오려 쓰십시오.\n'
                '제사를 마치면 지방은 소각합니다. 인쇄 후 점선을 따라 자르면 됩니다.',
                style: _style(fonts.base, fallback, 10).copyWith(lineSpacing: 4),
              ),
              pw.SizedBox(height: 24),
              pw.Center(
                child: _tablet(
                  people,
                  useHanja,
                  useHanja ? fonts.hanja : fonts.bold,
                  fallback,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                '광산김씨 · 경상북도 의성 가례 기준 안내. 집안 홀기가 있으면 홀기를 따릅니다.',
                style: _style(fonts.base, fallback, 9).copyWith(color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _tablet(
    List<JibangPersonText> people,
    bool useHanja,
    pw.Font bold,
    List<pw.Font> fallback,
  ) {
    const width = 60.0 * PdfPageFormat.mm;
    const height = 220.0 * PdfPageFormat.mm;
    return pw.Container(
      width: people.length == 1 ? width : width * 1.45,
      height: height,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.8),
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(90),
          topRight: pw.Radius.circular(90),
        ),
      ),
      padding: const pw.EdgeInsets.fromLTRB(16, 36, 16, 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: people
            .map(
              (person) => pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: (useHanja ? person.hanjaChars : person.hangulChars)
                      .map(
                        (ch) => pw.Text(
                          ch,
                          style: _style(
                            bold,
                            fallback,
                            people.length == 1 ? 22 : 18,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> previewAndPrint({
    required List<JibangPersonText> people,
    required bool useHanja,
  }) async {
    await Printing.layoutPdf(
      onLayout: (_) => buildPdf(people: people, useHanja: useHanja),
      name: '김가네_지방',
    );
  }
}
