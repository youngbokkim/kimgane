import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/jibang_pdf_service.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/jibang_paper.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class JibangPreviewView extends ConsumerWidget {
  const JibangPreviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jibangViewModelProvider);
    final members = ref.watch(membersViewModelProvider);
    final selected = members.where((m) => state.selectedIds.contains(m.id)).toList();
    final texts = ref.watch(jibangComposerProvider).pairFor(selected);
    final pdf = JibangPdfService();

    if (texts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('지방 미리보기')),
        body: const Center(child: Text('선택된 조상이 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('지방 미리보기'),
        actions: [
          IconButton(
            tooltip: '인쇄',
            onPressed: () => pdf.previewAndPrint(
              people: texts,
              useHanja: state.useHanja,
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
              '화면에서 확인하고, 인쇄하면 A4에 6×22cm 규격으로 나갑니다. '
              '위를 둥글게 오리고 제사가 끝나면 소각합니다.',
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
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => pdf.previewAndPrint(
                          people: texts,
                          useHanja: state.useHanja,
                        ),
                        icon: const Icon(Icons.print_outlined),
                        label: const Text('인쇄 / PDF 저장'),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: JibangPaper(
                          people: texts,
                          useHanja: state.useHanja,
                          height: 520,
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: PdfPreview(
                        build: (format) => pdf.buildPdf(
                          people: texts,
                          useHanja: state.useHanja,
                        ),
                        pdfFileName: '김가네_지방.pdf',
                        initialPageFormat: PdfPageFormat.a4,
                        canChangeOrientation: false,
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
