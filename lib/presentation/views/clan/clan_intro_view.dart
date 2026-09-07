import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/content/clan_intro_content.dart';
import 'package:kimgane/presentation/widgets/section_card.dart';

class ClanIntroView extends StatelessWidget {
  const ClanIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('광산김씨')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            '光山金氏 · 경상북도 의성',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(ClanIntroContent.intro),
          const SizedBox(height: 16),
          for (final section in ClanIntroContent.sections) ...[
            _ClanPhotoCard(section: section),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ClanPhotoCard extends StatelessWidget {
  const _ClanPhotoCard({required this.section});

  final ClanPhotoSection section;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: section.title,
      subtitle: section.subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push('/clan/photo/${section.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                color: const Color(0xFF1C1410),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 460),
                  child: Image.asset(
                    section.assetPath,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '사진을 누르면 크게 볼 수 있습니다.',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(section.summary),
          const SizedBox(height: 16),
          const Text(
            '한문 풀이',
            style: TextStyle(
              fontFamily: 'NanumMyeongjo',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          for (final line in section.lines) _HanjaBlock(line: line),
          if (section.glossary.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              '낱말',
              style: TextStyle(
                fontFamily: 'NanumMyeongjo',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final word in section.glossary)
                  Tooltip(
                    message: word.meaning,
                    child: Chip(
                      label: Text('${word.hanja}  ${word.hangul}'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HanjaBlock extends StatelessWidget {
  const _HanjaBlock({required this.line});

  final HanjaLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.hanja,
            style: const TextStyle(
              fontFamily: 'NanumMyeongjo',
              fontFamilyFallback: ['NotoSerifKR'],
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            line.hangul,
            style: const TextStyle(
              color: AppColors.cinnabar,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(line.meaning),
        ],
      ),
    );
  }
}

class ClanPhotoView extends StatelessWidget {
  const ClanPhotoView({super.key, required this.sectionId});

  final String sectionId;

  @override
  Widget build(BuildContext context) {
    final section = ClanIntroContent.sections
        .where((item) => item.id == sectionId)
        .firstOrNull;
    if (section == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('사진')),
        body: const Center(child: Text('사진을 찾을 수 없습니다.')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(section.title),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: Image.asset(section.assetPath),
        ),
      ),
    );
  }
}
