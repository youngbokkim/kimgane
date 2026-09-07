import 'package:flutter/material.dart';
import 'package:kimgane/core/theme/app_theme.dart';

class JesaTableDiagram extends StatelessWidget {
  const JesaTableDiagram({super.key, this.charye = false});

  final bool charye;

  @override
  Widget build(BuildContext context) {
    final rows = charye
        ? const [
            ['신위 (지방)'],
            ['잔', '시접', '떡국/송편', '전'],
            ['포', '과일 쟁반', '혜'],
          ]
        : const [
            ['신위 (지방) · 고위 西 / 비위 東'],
            ['잔', '시접', '메', '갱'],
            ['육적', '소적', '어적', '전'],
            ['탕', '탕', '탕'],
            ['포', '나물', '김치', '혜'],
            ['대추', '밤', '배', '감'],
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.hanjiCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          const Text(
            '북쪽 · 신위',
            style: TextStyle(
              fontFamily: 'NanumMyeongjo',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              children: [
                for (final cell in rows[i])
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppColors.cinnabar.withValues(alpha: 0.08)
                            : const Color(0xFFF7F0DE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: i == 0 ? AppColors.cinnabarSoft : AppColors.line,
                        ),
                      ),
                      child: Text(
                        cell,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w500,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            '남쪽 · 제주·제관',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
