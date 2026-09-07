import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';

class ChukmunPaper extends StatelessWidget {
  const ChukmunPaper({
    super.key,
    required this.chukmun,
    this.height = 420,
  });

  final ChukmunText chukmun;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (chukmun.columns.isEmpty) {
      return const SizedBox.shrink();
    }
    final width = height * 0.78;
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          border: Border.all(color: AppColors.ink, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final column in chukmun.columns)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Column(
                    children: [
                      for (final ch in column.characters)
                        if (ch.trim().isNotEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                ch,
                                style: const TextStyle(
                                  fontFamily: 'NanumMyeongjo',
                                  fontFamilyFallback: ['NotoSerifKR'],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  height: 1,
                                  color: AppColors.ink,
                                ),
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
    );
  }
}

