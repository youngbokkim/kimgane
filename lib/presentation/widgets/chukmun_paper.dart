import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/chukmun_composer.dart';

class ChukmunPaper extends StatelessWidget {
  const ChukmunPaper({
    super.key,
    required this.chukmun,
    this.height = 300,
  });

  final ChukmunText chukmun;
  final double height;

  static const _a4Landscape = 297 / 210;
  static const _padding = EdgeInsets.fromLTRB(28, 32, 28, 24);

  @override
  Widget build(BuildContext context) {
    if (chukmun.columns.isEmpty) {
      return const SizedBox.shrink();
    }
    final width = height * _a4Landscape;
    final innerHeight = math.max(1.0, height - _padding.vertical - 2.4);
    final innerWidth = math.max(1.0, width - _padding.horizontal - 2.4);
    final fit = ChukmunFit.forPage(
      text: chukmun,
      innerWidth: innerWidth,
      innerHeight: innerHeight,
    );
    final lines = chukmun.verticalLines(maxCharsPerColumn: fit.maxCharsPerColumn);

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
        padding: _padding,
        child: Align(
          alignment: Alignment.topRight,
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in lines)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: fit.columnGap / 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final ch in line)
                        SizedBox(
                          width: fit.columnWidth,
                          height: ch.trim().isEmpty
                              ? fit.charHeight * 0.55
                              : fit.charHeight,
                          child: ch.trim().isEmpty
                              ? null
                              : Center(
                                  child: Text(
                                    ch,
                                    style: TextStyle(
                                      fontFamily: 'NotoSerifKRBlack',
                                      fontFamilyFallback: const [
                                        'NanumMyeongjo',
                                        'NotoSerifKR',
                                      ],
                                      fontWeight: FontWeight.w900,
                                      fontSize: fit.fontSize,
                                      height: 1,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
