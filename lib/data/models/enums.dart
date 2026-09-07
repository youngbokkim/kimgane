enum CalendarKind { solar, lunar }

enum EventType { birthday, jesa, gyeongjosa }

enum JesaKind { gije, charye, sije, myoje }

enum GyeongjosaKind { wedding, funeral, dol, birth, other }

enum Gender { male, female }

enum Kinship {
  officiant,
  father,
  mother,
  grandfather,
  grandmother,
  greatGrandfather,
  greatGrandmother,
  ggGrandfather,
  ggGrandmother,
  paternalUncleElder,
  paternalUncleYounger,
  paternalAuntElder,
  paternalAuntYounger,
  elderBrother,
  sisterInLaw,
  husband,
  wife,
  other,
}

extension CalendarKindX on CalendarKind {
  String get label => this == CalendarKind.solar ? '양력' : '음력';
}

extension EventTypeX on EventType {
  String get label => switch (this) {
    EventType.birthday => '생일',
    EventType.jesa => '제사',
    EventType.gyeongjosa => '경조사',
  };

  CalendarKind get defaultCalendar =>
      this == EventType.jesa ? CalendarKind.lunar : CalendarKind.solar;
}

extension JesaKindX on JesaKind {
  String get label => switch (this) {
    JesaKind.gije => '기제사',
    JesaKind.charye => '차례',
    JesaKind.sije => '시제',
    JesaKind.myoje => '묘제',
  };
}

extension GyeongjosaKindX on GyeongjosaKind {
  String get label => switch (this) {
    GyeongjosaKind.wedding => '혼인',
    GyeongjosaKind.funeral => '상(喪)',
    GyeongjosaKind.dol => '돌',
    GyeongjosaKind.birth => '출산',
    GyeongjosaKind.other => '기타',
  };
}

extension GenderX on Gender {
  String get label => this == Gender.male ? '남' : '여';
}

extension KinshipX on Kinship {
  String get label => switch (this) {
    Kinship.officiant => '제주(본인)',
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
    Kinship.elderBrother => '형',
    Kinship.sisterInLaw => '형수',
    Kinship.husband => '남편',
    Kinship.wife => '아내',
    Kinship.other => '기타',
  };

  String get hanjaRelation => switch (this) {
    Kinship.officiant => '祭主',
    Kinship.father => '考',
    Kinship.mother => '妣',
    Kinship.grandfather => '祖考',
    Kinship.grandmother => '祖妣',
    Kinship.greatGrandfather => '曾祖考',
    Kinship.greatGrandmother => '曾祖妣',
    Kinship.ggGrandfather => '高祖考',
    Kinship.ggGrandmother => '高祖妣',
    Kinship.paternalUncleElder => '伯父',
    Kinship.paternalUncleYounger => '叔父',
    Kinship.paternalAuntElder => '伯母',
    Kinship.paternalAuntYounger => '叔母',
    Kinship.elderBrother => '兄',
    Kinship.sisterInLaw => '兄嫂',
    Kinship.husband => '辟',
    Kinship.wife => '室',
    Kinship.other => '',
  };

  String get hangulRelation => switch (this) {
    Kinship.officiant => '제주',
    Kinship.father => '고',
    Kinship.mother => '비',
    Kinship.grandfather => '조고',
    Kinship.grandmother => '조비',
    Kinship.greatGrandfather => '증조고',
    Kinship.greatGrandmother => '증조비',
    Kinship.ggGrandfather => '고조고',
    Kinship.ggGrandmother => '고조비',
    Kinship.paternalUncleElder => '백부',
    Kinship.paternalUncleYounger => '숙부',
    Kinship.paternalAuntElder => '백모',
    Kinship.paternalAuntYounger => '숙모',
    Kinship.elderBrother => '형',
    Kinship.sisterInLaw => '형수',
    Kinship.husband => '벽',
    Kinship.wife => '실',
    Kinship.other => '',
  };

  bool get defaultMale => switch (this) {
    Kinship.mother ||
    Kinship.grandmother ||
    Kinship.greatGrandmother ||
    Kinship.ggGrandmother ||
    Kinship.paternalAuntElder ||
    Kinship.paternalAuntYounger ||
    Kinship.sisterInLaw ||
    Kinship.wife => false,
    _ => true,
  };

  bool get usesGoPrefix => this == Kinship.wife;
}
