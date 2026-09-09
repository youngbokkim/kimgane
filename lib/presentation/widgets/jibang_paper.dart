import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';

class JibangPaper extends StatelessWidget {
  const JibangPaper({
    super.key,
    required this.people,
    required this.useHanja,
    this.height = 420,
  });

  final List<JibangPersonText> people;
  final bool useHanja;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return const SizedBox.shrink();
    }
    final width = people.length == 1 ? height * 6 / 22 : height * 9 / 22;
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(160)),
          border: Border.all(color: AppColors.ink, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 36, 12, 20),
        child: Row(
          children: [
            for (final person in people)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final ch
                        in (useHanja ? person.hanjaChars : person.hangulChars))
                      Text(
                        ch,
                        style: TextStyle(
                          fontFamily: useHanja
                              ? 'NotoSerifKR'
                              : 'NanumMyeongjo',
                          fontFamilyFallback: useHanja
                              ? const ['NanumMyeongjo']
                              : const ['NotoSerifKR'],
                          fontWeight: FontWeight.w700,
                          fontSize: people.length == 1 ? 26 : 20,
                          height: 1,
                          color: AppColors.ink,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
