import 'package:korean_lunar_utils/src/lunar_calendar.dart';

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

  /// 한국 표준 만세력 기점. UTC 날짜만 써서 시간대·옛 시차 때문에
  /// 음력이 하루 밀리지 않게 한다.
  static final DateTime _baseUtc = DateTime.utc(1900, 1, 31);

  CalendarDate solarToLunar(DateTime solar) {
    final utc = DateTime.utc(solar.year, solar.month, solar.day);
    if (utc.isBefore(_baseUtc)) {
      throw RangeError('Solar date must be on or after 1900-01-31.');
    }

    var offset = utc.difference(_baseUtc).inDays;
    var year = minYear;
    while (year <= maxYear) {
      final yearDays = _lunarYearDays(year);
      if (offset < yearDays) break;
      offset -= yearDays;
      year++;
    }
    if (year < minYear || year > maxYear) {
      throw RangeError('Year $year is out of supported range.');
    }

    final leapMonth = LunarCalendar.leapMonthOfYear(year);
    var isLeap = false;
    var month = 1;
    while (month <= 12) {
      final daysInMonth = isLeap
          ? LunarCalendar.leapMonthDays(year)
          : LunarCalendar.monthDays(year, month);
      if (offset < daysInMonth) break;
      offset -= daysInMonth;
      if (leapMonth == month && !isLeap) {
        isLeap = true;
      } else {
        if (isLeap) {
          isLeap = false;
        }
        month++;
      }
    }

    return CalendarDate(
      year: year,
      month: month,
      day: offset + 1,
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
      return _lunarToSolarUtc(
        year: year,
        month: month,
        day: day,
        isLeapMonth: isLeapMonth,
      );
    } catch (_) {
      if (isLeapMonth) {
        return _lunarToSolarUtc(
          year: year,
          month: month,
          day: day,
        );
      }
      rethrow;
    }
  }

  DateTime _lunarToSolarUtc({
    required int year,
    required int month,
    required int day,
    bool isLeapMonth = false,
  }) {
    if (year < minYear || year > maxYear) {
      throw RangeError('Year $year is out of supported range.');
    }

    var offset = 0;
    for (var y = minYear; y < year; y++) {
      offset += _lunarYearDays(y);
    }

    final leapMonth = LunarCalendar.leapMonthOfYear(year);
    for (var m = 1; m < month; m++) {
      offset += LunarCalendar.monthDays(year, m);
      if (leapMonth == m) {
        offset += LunarCalendar.leapMonthDays(year);
      }
    }

    if (isLeapMonth) {
      if (leapMonth != month) {
        throw RangeError('Year $year does not have leap month $month.');
      }
      offset += LunarCalendar.monthDays(year, month);
    }

    offset += day - 1;
    final utc = _baseUtc.add(Duration(days: offset));
    return DateTime(utc.year, utc.month, utc.day);
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

  static int _lunarYearDays(int year) {
    var sum = 0;
    final leap = LunarCalendar.leapMonthOfYear(year);
    for (var month = 1; month <= 12; month++) {
      sum += LunarCalendar.monthDays(year, month);
      if (leap == month) {
        sum += LunarCalendar.leapMonthDays(year);
      }
    }
    return sum;
  }
}
