import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:kimgane/core/utils/jibang_pdf_service.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/chukmun_paper.dart';
import 'package:kimgane/presentation/widgets/jibang_paper.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class JibangPreviewView extends ConsumerWidget {
  const JibangPreviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jibangViewModelProvider);
    final members = ref.watch(membersViewModelProvider);
    final selected = members
        .where((m) => state.selectedIds.contains(m.id))
        .toList();
    final texts = ref.watch(jibangComposerProvider).pairFor(selected);
    final chukmun = _composeChukmun(ref, selected);
    final pdf = JibangPdfService()..warmUp();

    if (texts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('지방 · 축문 미리보기')),
        body: const Center(child: Text('선택된 조상이 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('지방 · 축문 미리보기'),
        actions: [
          IconButton(
            tooltip: 'PDF 저장',
            onPressed: () => _export(
              context,
              pdf: pdf,
              people: texts,
              chukmun: chukmun,
              useHanja: state.useHanja,
              print: false,
            ),
            icon: const Icon(Icons.download_outlined),
          ),
          IconButton(
            tooltip: '인쇄',
            onPressed: () => _export(
              context,
              pdf: pdf,
              people: texts,
              chukmun: chukmun,
              useHanja: state.useHanja,
              print: true,
            ),
            icon: const Icon(Icons.print_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              '화면에서 확인하고, 인쇄하면 지방은 A4 세로 6×22cm 규격으로, 축문은 A4 가로로 나갑니다. '
              '지방은 위를 둥글게 오리고 제사가 끝나면 소각합니다.',
              style: TextStyle(color: AppColors.inkMuted),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 720) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      JibangPaper(
                        people: texts,
                        useHanja: state.useHanja,
                        height: 460,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '축문',
                        style: TextStyle(
                          fontFamily: 'NanumMyeongjo',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ChukmunPaper(chukmun: chukmun),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _export(
                          context,
                          pdf: pdf,
                          people: texts,
                          chukmun: chukmun,
                          useHanja: state.useHanja,
                          print: false,
                        ),
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('PDF 저장'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _export(
                          context,
                          pdf: pdf,
                          people: texts,
                          chukmun: chukmun,
                          useHanja: state.useHanja,
                          print: true,
                        ),
                        icon: const Icon(Icons.print_outlined),
                        label: const Text('인쇄'),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          JibangPaper(
                            people: texts,
                            useHanja: state.useHanja,
                            height: 520,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '축문',
                            style: TextStyle(
                              fontFamily: 'NanumMyeongjo',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ChukmunPaper(chukmun: chukmun, height: 320),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => _export(
                              context,
                              pdf: pdf,
                              people: texts,
                              chukmun: chukmun,
                              useHanja: state.useHanja,
                              print: false,
                            ),
                            icon: const Icon(Icons.download_outlined),
                            label: const Text('PDF 저장'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () => _export(
                              context,
                              pdf: pdf,
                              people: texts,
                              chukmun: chukmun,
                              useHanja: state.useHanja,
                              print: true,
                            ),
                            icon: const Icon(Icons.print_outlined),
                            label: const Text('인쇄'),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: PdfPreview(
                        build: (format) => pdf.buildPdf(
                          people: texts,
                          useHanja: state.useHanja,
                          chukmun: chukmun,
                        ),
                        pdfFileName: '김가네_지방_축문.pdf',
                        initialPageFormat: PdfPageFormat.a4.landscape,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        dynamicLayout: false,
                        allowPrinting: !kIsWeb,
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
                        previewPageMargin: const EdgeInsets.fromLTRB(
                          12,
                          8,
                          20,
                          16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

ChukmunText _composeChukmun(WidgetRef ref, List<FamilyMember> selected) {
  final events = ref.watch(eventsViewModelProvider);
  return ref
      .watch(chukmunComposerProvider)
      .compose(ancestors: selected, events: events);
}

Future<void> _export(
  BuildContext context, {
  required JibangPdfService pdf,
  required List<JibangPersonText> people,
  required ChukmunText chukmun,
  required bool useHanja,
  required bool print,
}) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );

  var dialogOpen = true;
  void closeDialog() {
    if (!dialogOpen || !context.mounted) return;
    dialogOpen = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  try {
    final bytes = await pdf.buildPdf(
      people: people,
      useHanja: useHanja,
      chukmun: chukmun,
    );
    closeDialog();
    if (!context.mounted) return;

    if (kIsWeb) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(print ? '인쇄할 PDF' : 'PDF 저장'),
          content: const Text(
            '아래 버튼을 누르면 김가네_지방_축문.pdf 파일이 저장됩니다. '
            '1장은 지방(A4 세로), 2장은 축문(A4 가로)입니다. 저장한 파일을 열어 인쇄할 수 있습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
            FilledButton(
              onPressed: () async {
                await Printing.sharePdf(
                  bytes: bytes,
                  filename: '김가네_지방_축문.pdf',
                );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('PDF 저장하기'),
            ),
          ],
        ),
      );
      return;
    }

    final ok = print
        ? await pdf.printPdf(
            people: people,
            useHanja: useHanja,
            chukmun: chukmun,
          )
        : await pdf.savePdf(
            people: people,
            useHanja: useHanja,
            chukmun: chukmun,
          );
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인쇄 창을 열지 못했습니다.')));
    }
  } catch (error) {
    closeDialog();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('지방·축문 PDF를 만들지 못했습니다. $error')));
  }
}
