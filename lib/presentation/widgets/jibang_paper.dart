import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/jibang_composer.dart';
import 'package:kimgane/core/utils/jibang_layout.dart';

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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: _buildPaper(),
    );
  }

  Widget _buildPaper() {
    if (people.isEmpty) {
      return const SizedBox.shrink();
    }
    final metrics = JibangLayout.measure(
      height: height,
      people: people,
      useHanja: useHanja,
    );
    return Center(
      child: Container(
        width: metrics.width,
        height: metrics.height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(metrics.domeRadius),
          ),
          border: Border.all(color: AppColors.ink, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.fromLTRB(
          metrics.left,
          metrics.top,
          metrics.right,
          metrics.bottom,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slotHeight =
                constraints.maxHeight / math.max(1, metrics.maxChars);
            final columnWidth =
                constraints.maxWidth / math.max(1, metrics.columns);
            final fontSize = math.min(slotHeight, columnWidth * 0.86);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final person in people)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final ch
                            in (useHanja
                                ? person.hanjaChars
                                : person.hangulChars))
                          SizedBox(
                            height: slotHeight,
                            width: double.infinity,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  ch,
                                  style: TextStyle(
                                    fontFamily: useHanja
                                        ? 'NotoSerifKR'
                                        : 'NanumMyeongjo',
                                    fontFamilyFallback: useHanja
                                        ? const ['NanumMyeongjo']
                                        : const ['NotoSerifKR'],
                                    fontWeight: FontWeight.w700,
                                    fontSize: fontSize,
                                    height: 1,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
