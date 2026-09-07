import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class JibangPdfService {
  static ({pw.Font base, pw.Font bold, pw.Font hanja, pw.Font gungsuh})?
  _cachedFonts;

  Future<pw.Font> _load(String asset) async {
    final data = await rootBundle.load(asset);
    return pw.Font.ttf(data);
  }

  Future<({pw.Font base, pw.Font bold, pw.Font hanja, pw.Font gungsuh})>
  _fonts() async {
    final cached = _cachedFonts;
    if (cached != null) return cached;
    final base = await _load('assets/fonts/NanumMyeongjo-Regular.ttf');
    final bold = await _load('assets/fonts/NanumMyeongjo-Bold.ttf');
    final hanja = await _load('assets/fonts/NotoSerifKR-Hanja.ttf');
    final gungsuh = await _load('assets/fonts/NotoSerifKR-Black.ttf');
    return _cachedFonts = (
      base: base,
      bold: bold,
      hanja: hanja,
      gungsuh: gungsuh,
    );
  }

  Future<void> warmUp() async {
    try {
      await _fonts();
    } catch (_) {}
  }

  pw.TextStyle _style(pw.Font font, List<pw.Font> fallback, double size) {
    return pw.TextStyle(font: font, fontFallback: fallback, fontSize: size);
  }

  Future<Uint8List> buildPdf({
    required List<JibangPersonText> people,
    required bool useHanja,
    ChukmunText? chukmun,
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
              pw.Text('김가네 지방(紙榜)', style: _style(fonts.bold, fallback, 18)),
              pw.SizedBox(height: 6),
              pw.Text(
                '가로 6cm · 세로 22cm 규격. 위는 둥글게(天圓), 아래는 바르게(地方) 오려 쓰십시오.\n'
                '제사를 마치면 지방은 소각합니다. 인쇄 후 점선을 따라 자르면 됩니다.',
                style: _style(
                  fonts.base,
                  fallback,
                  10,
                ).copyWith(lineSpacing: 4),
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
                style: _style(
                  fonts.base,
                  fallback,
                  9,
                ).copyWith(color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    if (chukmun != null && chukmun.columns.isNotEmpty) {
      doc.addPage(
        pw.Page(
          pageFormat: _chukmunPage,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return _chukmunPaper(context, chukmun, fonts.gungsuh, [
              fonts.base,
              fonts.hanja,
              fonts.bold,
            ]);
          },
        ),
      );
    }

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

  static final _chukmunPage = PdfPageFormat.a4.landscape.copyWith(
    marginTop: 0,
    marginBottom: 0,
    marginLeft: 0,
    marginRight: 0,
  );

  pw.Widget _chukmunPaper(
    pw.Context context,
    ChukmunText chukmun,
    pw.Font font,
    List<pw.Font> fallback,
  ) {
    const padding = pw.EdgeInsets.fromLTRB(18, 20, 18, 16);
    final page = context.page.pageFormat;
    final innerWidth = page.width - padding.left - padding.right;
    final innerHeight = page.height - padding.top - padding.bottom;
    final fit = ChukmunFit.forPage(
      text: chukmun,
      innerWidth: innerWidth,
      innerHeight: innerHeight,
    );
    final lines = chukmun.verticalLines(
      maxCharsPerColumn: fit.maxCharsPerColumn,
    );

    return pw.FullPage(
      ignoreMargins: true,
      child: pw.Container(
        width: page.width,
        height: page.height,
        color: PdfColor.fromInt(0xFFFFF8EA),
        padding: padding,
        child: pw.SizedBox(
          width: innerWidth,
          height: innerHeight,
          child: pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (final line in lines.reversed)
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: fit.columnGap / 2,
                    ),
                    child: pw.SizedBox(
                      width: fit.columnWidth,
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          for (final ch in line)
                            pw.SizedBox(
                              height: fit.heightOf(ch),
                              child: ch.trim().isEmpty
                                  ? pw.SizedBox()
                                  : pw.Center(
                                      child: pw.Text(
                                        ch,
                                        style: _style(
                                          font,
                                          fallback,
                                          fit.fontSize,
                                        ).copyWith(lineSpacing: 0, height: 1),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> savePdf({
    required List<JibangPersonText> people,
    required bool useHanja,
    ChukmunText? chukmun,
  }) async {
    final bytes = await buildPdf(
      people: people,
      useHanja: useHanja,
      chukmun: chukmun,
    );
    return Printing.sharePdf(bytes: bytes, filename: '김가네_지방_축문.pdf');
  }

  Future<bool> printPdf({
    required List<JibangPersonText> people,
    required bool useHanja,
    ChukmunText? chukmun,
  }) async {
    final bytes = await buildPdf(
      people: people,
      useHanja: useHanja,
      chukmun: chukmun,
    );
    if (kIsWeb) {
      // Chrome blocks print() on a hidden iframe after async PDF generation,
      // so download the file and let the user open/print it.
      return Printing.sharePdf(bytes: bytes, filename: '김가네_지방_축문.pdf');
    }
    return Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: '김가네_지방_축문',
      format: PdfPageFormat.a4,
      dynamicLayout: false,
    );
  }
}
