import 'package:korean_lunar_utils/korean_lunar_utils.dart';

class CalendarDate {
  const CalendarDate({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
  });

  final int year;
  final int month;
  final int day;
  final bool isLeapMonth;

  DateTime get asDateTime => DateTime(year, month, day);
}

class LunarService {
  static const minYear = 1900;
  static const maxYear = 2049;

  CalendarDate solarToLunar(DateTime solar) {
    final date = DateTime(solar.year, solar.month, solar.day);
    final lunarDt = LunarSolarConverter.convertSolarToLunar(date);
    final asNormal = LunarSolarConverter.convertLunarDateToSolar(
      LunarDate(lunarDt.year, lunarDt.month, lunarDt.day),
    );
    final isLeap = !_sameDay(asNormal, date);
    return CalendarDate(
      year: lunarDt.year,
      month: lunarDt.month,
      day: lunarDt.day,
      isLeapMonth: isLeap,
    );
  }

  DateTime lunarToSolar({
    required int year,
    required int month,
    required int day,
    bool isLeapMonth = false,
  }) {
    try {
      return _dateOnly(
        LunarSolarConverter.convertLunarDateToSolar(
          LunarDate(year, month, day, isLeapMonth: isLeapMonth),
        ),
      );
    } catch (_) {
      if (isLeapMonth) {
        return _dateOnly(
          LunarSolarConverter.convertLunarDateToSolar(
            LunarDate(year, month, day),
          ),
        );
      }
      rethrow;
    }
  }

  bool yearHasLeapMonth(int year, int month) {
    try {
      lunarToSolar(year: year, month: month, day: 1, isLeapMonth: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  String formatLunar(
    CalendarDate date, {
    bool includeYear = true,
    bool includeLeap = true,
  }) {
    final leap = includeLeap && date.isLeapMonth ? '윤' : '';
    if (includeYear) {
      return '음력 ${date.year}. $leap${date.month}. ${date.day}.';
    }
    return '음력 $leap${date.month}. ${date.day}.';
  }

  String formatSolar(DateTime date, {bool includeYear = true}) {
    if (includeYear) {
      return '양력 ${date.year}. ${date.month}. ${date.day}.';
    }
    return '양력 ${date.month}. ${date.day}.';
  }

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
