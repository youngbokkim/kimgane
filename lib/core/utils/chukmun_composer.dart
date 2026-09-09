import 'package:kimgane/core/utils/lunar_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/data/models/family_member.dart';

class ChukmunText {
  const ChukmunText({required this.columns, required this.plainText});

  final List<String> columns;
  final String plainText;

  List<String> charsOf(String column) {
    return [for (final rune in column.trim().runes) String.fromCharCode(rune)];
  }

  int get lineCount => columns.where((c) => charsOf(c).isNotEmpty).length;

  int get longestLineLength {
    var longest = 0;
    for (final column in columns) {
      final n = charsOf(column).length;
      if (n > longest) longest = n;
    }
    return longest;
  }

  double visualLengthOf(List<String> chars) {
    var length = 0.0;
    for (final ch in chars) {
      length += ch.trim().isEmpty ? ChukmunFit.spaceHeightFactor : 1.0;
    }
    return length;
  }

  /// 각 구절을 세로 한 줄로 둔다. 칸이 모자라면 띄어쓰기에서 다음 줄로 넘기고,
  /// 단어 중간(없사옵니다, 음식과 등)은 끊지 않는다.
  List<List<String>> verticalLines({required num maxCharsPerColumn}) {
    final limit = maxCharsPerColumn < 1 ? 1.0 : maxCharsPerColumn.toDouble();
    final lines = <List<String>>[];
    for (final column in columns) {
      final chars = charsOf(column);
      if (chars.isEmpty) continue;
      lines.addAll(_wrapColumn(chars, limit));
    }
    return lines;
  }

  List<List<String>> _wrapColumn(List<String> chars, double limit) {
    if (visualLengthOf(chars) <= limit + 0.05) {
      return [List<String>.from(chars)];
    }

    final tokens = <List<String>>[];
    var word = <String>[];
    for (final ch in chars) {
      if (ch.trim().isEmpty) {
        if (word.isNotEmpty) {
          tokens.add(word);
          word = [];
        }
        tokens.add([ch]);
      } else {
        word.add(ch);
      }
    }
    if (word.isNotEmpty) tokens.add(word);

    final lines = <List<String>>[];
    var line = <String>[];
    var used = 0.0;
    for (final token in tokens) {
      final tokenLen = visualLengthOf(token);
      final isSpace = token.length == 1 && token.first.trim().isEmpty;
      if (line.isNotEmpty && used + tokenLen > limit + 0.05) {
        if (isSpace) continue;
        // 없사옵니다. / 음식과처럼 짧은 끝이 다음 줄로 떨어지지 않게 한 줄에 붙인다.
        if (used + tokenLen <= limit + 2.0) {
          line.addAll(token);
          used += tokenLen;
          continue;
        }
        if (tokenLen <= limit + 0.001) {
          lines.add(line);
          line = List<String>.from(token);
          used = tokenLen;
          continue;
        }
        lines.add(line);
        line = [];
        used = 0;
        for (final piece in _hardWrap(token, limit)) {
          if (line.isNotEmpty) lines.add(line);
          line = piece;
          used = visualLengthOf(piece);
        }
        continue;
      }
      if (tokenLen > limit + 0.001 && line.isEmpty) {
        for (final piece in _hardWrap(token, limit)) {
          if (line.isNotEmpty) lines.add(line);
          line = piece;
          used = visualLengthOf(piece);
        }
        continue;
      }
      line.addAll(token);
      used += tokenLen;
    }
    if (line.isNotEmpty) lines.add(line);
    return lines;
  }

  List<List<String>> _hardWrap(List<String> chars, double limit) {
    final lines = <List<String>>[];
    var line = <String>[];
    var used = 0.0;
    for (final ch in chars) {
      final unit = ch.trim().isEmpty ? ChukmunFit.spaceHeightFactor : 1.0;
      if (line.isNotEmpty && used + unit > limit + 0.001) {
        lines.add(line);
        line = [];
        used = 0;
      }
      line.add(ch);
      used += unit;
    }
    if (line.isNotEmpty) lines.add(line);
    return lines;
  }
}

class ChukmunFit {
  const ChukmunFit({
    required this.fontSize,
    required this.charHeight,
    required this.columnWidth,
    required this.columnGap,
    required this.maxCharsPerColumn,
    this.maxVisualUnits,
  });

  static const spaceHeightFactor = 0.55;

  final double fontSize;
  final double charHeight;
  final double columnWidth;
  final double columnGap;
  final int maxCharsPerColumn;
  final double? maxVisualUnits;

  double get wrapLimit => maxVisualUnits ?? maxCharsPerColumn.toDouble();

  double heightOf(String ch) {
    return ch.trim().isEmpty ? charHeight * spaceHeightFactor : charHeight;
  }

  /// A4 가로 한 장의 안쪽 영역에 맞게, 들어갈 수 있는 가장 큰 글자 크기를 고른다.
  /// 글자 간격은 페이지를 채우려고 늘리지 않고, 구절은 되도록 한 줄에 둔다.
  factory ChukmunFit.forPage({
    required ChukmunText text,
    required double innerWidth,
    required double innerHeight,
    double maxFontSize = 42,
    double minFontSize = 9,
    bool brush = false,
  }) {
    final lines = text.lineCount;
    final longest = text.longestLineLength;
    if (lines == 0 || longest == 0) {
      return const ChukmunFit(
        fontSize: 14,
        charHeight: 16.5,
        columnWidth: 17,
        columnGap: 6,
        maxCharsPerColumn: 1,
        maxVisualUnits: 1,
      );
    }

    final heightFactor = brush ? 1.28 : 1.16;
    final widthFactor = brush ? 1.4 : 1.36;
    final gapFactor = brush ? 0.42 : 0.36;
    final cap = brush ? 14.0 : maxFontSize;
    final packedColumns = [
      for (final column in text.columns)
        if (text.charsOf(column).isNotEmpty) text.charsOf(column),
    ];

    ChukmunFit at(double font) {
      final charHeight = font * heightFactor;
      final maxVisual = innerHeight / charHeight;
      return ChukmunFit(
        fontSize: font,
        charHeight: charHeight,
        columnWidth: font * widthFactor,
        columnGap: font * gapFactor,
        maxCharsPerColumn: maxVisual.floor().clamp(1, 1000),
        maxVisualUnits: maxVisual,
      );
    }

    bool fitsUnwrapped(ChukmunFit fit) {
      final usedWidth =
          packedColumns.length * (fit.columnWidth + fit.columnGap);
      var usedHeight = 0.0;
      for (final line in packedColumns) {
        final height = text.visualLengthOf(line) * fit.charHeight;
        if (height > usedHeight) usedHeight = height;
      }
      return usedWidth <= innerWidth - 0.5 && usedHeight <= innerHeight - 0.5;
    }

    var lo = minFontSize;
    var hi = cap;
    var best = at(minFontSize);
    for (var i = 0; i < 24; i++) {
      final mid = (lo + hi) / 2;
      final candidate = at(mid);
      if (fitsUnwrapped(candidate)) {
        best = candidate;
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return best;
  }
}

class ChukmunComposer {
  const ChukmunComposer(this._lunar);

  final LunarService _lunar;

  static const officiantGivenName = '영필';

  static const _stems = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
  static const _branches = [
    '자',
    '축',
    '인',
    '묘',
    '진',
    '사',
    '오',
    '미',
    '신',
    '유',
    '술',
    '해',
  ];
  static const _months = [
    '',
    '정월',
    '이월',
    '삼월',
    '사월',
    '오월',
    '유월',
    '칠월',
    '팔월',
    '구월',
    '시월',
    '동짓달',
    '섣달',
  ];
  static const _days = [
    '',
    '초하루',
    '초이틀',
    '초사흘',
    '초나흘',
    '초닷새',
    '초엿새',
    '초이레',
    '초여드레',
    '초아흐레',
    '초열흘',
    '열하루',
    '열이틀',
    '열사흘',
    '열나흘',
    '보름',
    '열엿새',
    '열이레',
    '열여드레',
    '열아흐레',
    '스무날',
    '스무하루',
    '스무이틀',
    '스무사흘',
    '스무나흘',
    '스무닷새',
    '스무엿새',
    '스무이레',
    '스무여드레',
    '스무아흐레',
    '그믐',
  ];

  ChukmunText compose({
    required List<FamilyMember> ancestors,
    required List<FamilyEvent> events,
    DateTime? now,
  }) {
    if (ancestors.isEmpty) {
      return const ChukmunText(columns: [], plainText: '');
    }
    final people = [...ancestors]
      ..sort((a, b) {
        if (a.isMale == b.isMale) return 0;
        return a.isMale ? -1 : 1;
      });
    final today = now ?? DateTime.now();
    final date = _riteDate(people, events, today);
    final dateLabel =
        '${_sexagenaryYear(date.year)}년${date.leap ? ' 윤' : ' '}${_monthName(date.month)} ${_dayName(date.day)}';
    final shortNames = people.map(_shortTitle).toList();
    final honorifics = people.map(_honorificTitle).toList();
    final given = officiantGivenName;
    final particle = _hasBatchim(given) ? '이' : '가';
    final filial = '${_filialTitle(people)} $given$particle';
    final columns = _columns(
      dateLabel: dateLabel,
      filial: filial,
      shortNames: shortNames,
      honorifics: honorifics,
    );
    return ChukmunText(columns: columns, plainText: columns.join('\n'));
  }

  List<String> _columns({
    required String dateLabel,
    required String filial,
    required List<String> shortNames,
    required List<String> honorifics,
  }) {
    if (shortNames.length >= 2) {
      return [
        dateLabel,
        '$filial ${shortNames[0]},',
        '${shortNames[1]}께 고하옵니다.',
        '세월이 흘러 ${honorifics[0]} ${honorifics[1]}',
        '의 기일이 도래하였네요.',
        '생전에 ${honorifics[0]}과 ${honorifics[1]}의',
        '은공을 갚을 길이 없사옵니다.',
        '이에 후손들이 여러 가지 음식과',
        '맑은 술을 올리오니',
        '흠향 하시옵소서.',
        '${shortNames[0]} ${shortNames[1]} 저희',
        '집안을 두루두루 살펴',
        '주시옵소서.',
      ];
    }
    return [
      dateLabel,
      '$filial ${shortNames.first}께',
      '고하옵니다.',
      '세월이 흘러 ${honorifics.first}의',
      '기일이 도래하였네요.',
      '생전에 ${honorifics.first}의',
      '은공을 갚을 길이 없사옵니다.',
      '이에 후손들이 여러 가지 음식과',
      '맑은 술을 올리오니',
      '흠향 하시옵소서.',
      '${shortNames.first} 저희',
      '집안을 두루두루 살펴',
      '주시옵소서.',
    ];
  }

  ({int year, int month, int day, bool leap}) _riteDate(
    List<FamilyMember> people,
    List<FamilyEvent> events,
    DateTime today,
  ) {
    final ids = people.map((m) => m.id).toSet();
    FamilyEvent? match;
    for (final event in events) {
      if (event.type != EventType.jesa) continue;
      final eventIds = {
        if (event.memberId != null) event.memberId!,
        ...event.ancestorIds,
      };
      if (ids.every(eventIds.contains) || eventIds.every(ids.contains)) {
        match = event;
        break;
      }
    }
    var year = today.year;
    var month = match?.month ?? people.first.deathMonth ?? today.month;
    var day = match?.day ?? people.first.deathDay ?? today.day;
    var leap = match?.isLeapMonth ?? people.first.deathLeapMonth;
    var kind = match?.calendarKind ?? people.first.deathCalendar;
    if (kind == CalendarKind.solar) {
      final lunar = _lunar.solarToLunar(DateTime(year, month, day));
      year = lunar.year;
      month = lunar.month;
      day = lunar.day;
      leap = lunar.isLeapMonth;
    }
    return (year: year, month: month, day: day, leap: leap);
  }

  String _sexagenaryYear(int year) {
    return '${_stems[(year - 4) % 10]}${_branches[(year - 4) % 12]}';
  }

  String _monthName(int month) {
    if (month < 1 || month > 12) return '$month월';
    return _months[month];
  }

  String _dayName(int day) {
    if (day < 1 || day > 30) return '$day일';
    return _days[day];
  }

  String _filialTitle(List<FamilyMember> people) {
    final kinships = people.map((m) => m.kinship).toSet();
    if (kinships.contains(Kinship.grandfather) ||
        kinships.contains(Kinship.grandmother) ||
        kinships.contains(Kinship.greatGrandfather) ||
        kinships.contains(Kinship.greatGrandmother) ||
        kinships.contains(Kinship.ggGrandfather) ||
        kinships.contains(Kinship.ggGrandmother)) {
      return '효손';
    }
    if (kinships.contains(Kinship.paternalUncleElder) ||
        kinships.contains(Kinship.paternalUncleYounger) ||
        kinships.contains(Kinship.paternalAuntElder) ||
        kinships.contains(Kinship.paternalAuntYounger)) {
      return '효질';
    }
    return '효자';
  }

  String _shortTitle(FamilyMember member) {
    return switch (member.kinship) {
      Kinship.father => '아버지',
      Kinship.mother => '어머니',
      Kinship.grandfather => '할아버지',
      Kinship.grandmother => '할머니',
      Kinship.greatGrandfather => '증조할아버지',
      Kinship.greatGrandmother => '증조할머니',
      Kinship.ggGrandfather => '고조할아버지',
      Kinship.ggGrandmother => '고조할머니',
      Kinship.paternalUncleElder => '큰아버지',
      Kinship.paternalUncleYounger => '작은아버지',
      Kinship.paternalAuntElder => '큰어머니',
      Kinship.paternalAuntYounger => '작은어머니',
      _ => _givenName(member),
    };
  }

  String _honorificTitle(FamilyMember member) {
    return switch (member.kinship) {
      Kinship.father => '아버님',
      Kinship.mother => '어머님',
      Kinship.grandfather => '할아버님',
      Kinship.grandmother => '할머님',
      Kinship.greatGrandfather => '증조할아버님',
      Kinship.greatGrandmother => '증조할머님',
      Kinship.ggGrandfather => '고조할아버님',
      Kinship.ggGrandmother => '고조할머님',
      Kinship.paternalUncleElder => '큰아버님',
      Kinship.paternalUncleYounger => '작은아버님',
      Kinship.paternalAuntElder => '큰어머님',
      Kinship.paternalAuntYounger => '작은어머님',
      _ => '${_givenName(member)}님',
    };
  }

  bool _hasBatchim(String text) {
    if (text.isEmpty) return false;
    final code = text.runes.last;
    if (code < 0xAC00 || code > 0xD7A3) return false;
    return (code - 0xAC00) % 28 != 0;
  }

  String _givenName(FamilyMember? member) {
    if (member == null) return '제주';
    final name = member.name;
    final surname = member.surname;
    if (surname.isNotEmpty &&
        name.startsWith(surname) &&
        name.length > surname.length) {
      return name.substring(surname.length);
    }
    return name;
  }
}
