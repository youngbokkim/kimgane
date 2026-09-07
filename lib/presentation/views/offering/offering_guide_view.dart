import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/content/offering_guide_content.dart';
import 'package:kimgane/presentation/widgets/jesa_table_diagram.dart';
import 'package:kimgane/presentation/widgets/section_card.dart';

class OfferingGuideView extends StatelessWidget {
  const OfferingGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('제사상 상차림')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cinnabar.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cinnabar.withValues(alpha: 0.2)),
            ),
            child: const Text(OfferingGuideContent.clanNote),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: OfferingGuideContent.actualTableTitle,
            subtitle: OfferingGuideContent.actualTableSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.push('/offering/photo'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: const Color(0xFF1C1410),
                      child: Image.asset(
                        OfferingGuideContent.photoAsset,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '사진을 누르면 크게 볼 수 있습니다. 다음에 상을 차릴 때 이 사진을 기준으로 하면 됩니다.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
                ),
                const SizedBox(height: 12),
                const Text(OfferingGuideContent.actualTableSummary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final section in OfferingGuideContent.actualTableRows) ...[
            SectionCard(
              title: section.title,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.body),
                  const SizedBox(height: 12),
                  for (final bullet in section.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('·  ', style: TextStyle(color: AppColors.cinnabar)),
                          Expanded(child: Text(bullet)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          SectionCard(
            title: '기제사 진설도 (참고)',
            subtitle: '신위를 북쪽(위)으로 둔 영남 일반 가정 배치',
            child: const JesaTableDiagram(),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '차례상 진설도',
            subtitle: '설·추석은 이보다 간소하게',
            child: const JesaTableDiagram(charye: true),
          ),
          const SizedBox(height: 12),
          for (final section in OfferingGuideContent.sections) ...[
            SectionCard(
              title: section.title,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.body),
                  if (section.bullets.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    for (final bullet in section.bullets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('·  ', style: TextStyle(color: AppColors.cinnabar)),
                            Expanded(child: Text(bullet)),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class OfferingPhotoView extends StatelessWidget {
  const OfferingPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('김가네 실제 상차림'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: Image.asset(OfferingGuideContent.photoAsset),
        ),
      ),
    );
  }
}
