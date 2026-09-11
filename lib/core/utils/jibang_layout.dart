import 'dart:math' as math;

import 'package:kimgane/core/utils/jibang_composer.dart';

class JibangMetrics {
  const JibangMetrics({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.slotHeight,
    required this.fontSize,
    required this.columns,
    required this.maxChars,
    required this.borderWidth,
  });

  final double width;
  final double height;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double slotHeight;
  final double fontSize;
  final int columns;
  final int maxChars;
  final double borderWidth;

  double get innerWidth => math.max(1, width - left - right - borderWidth * 2);
  double get innerHeight =>
      math.max(1, height - top - bottom - borderWidth * 2);
  double get columnWidth => innerWidth / math.max(1, columns);
  double get domeRadius => width / 2;
}

class JibangLayout {
  static const widthCm = 6.0;
  static const heightCm = 22.0;

  static double paperWidthForHeight(double height) =>
      height * widthCm / heightCm;

  static JibangMetrics measure({
    required double height,
    required List<JibangPersonText> people,
    required bool useHanja,
    double borderWidth = 1.2,
  }) {
    final width = paperWidthForHeight(height);
    final columns = math.max(1, people.length);
    final maxChars = people.fold<int>(0, (best, person) {
      final chars = useHanja ? person.hanjaChars : person.hangulChars;
      return math.max(best, chars.length);
    });
    final top = math.max(width * 0.42, height * 0.07);
    final bottom = height * 0.05;
    final horizontal = width * (columns >= 2 ? 0.05 : 0.1);
    final innerWidth = math.max(1, width - horizontal * 2 - borderWidth * 2);
    final innerHeight = math.max(1, height - top - bottom - borderWidth * 2);
    final slotHeight = innerHeight / math.max(1, maxChars);
    final columnWidth = innerWidth / columns;
    final fontSize = math.min(slotHeight, columnWidth * 0.86);
    return JibangMetrics(
      width: width,
      height: height,
      left: horizontal,
      top: top,
      right: horizontal,
      bottom: bottom,
      slotHeight: slotHeight,
      fontSize: fontSize,
      columns: columns,
      maxChars: maxChars,
      borderWidth: borderWidth,
    );
  }
}
