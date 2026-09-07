import 'package:kimgane/data/models/enums.dart';

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.gender,
    required this.kinship,
    this.bonGwan = '광산',
    this.surname = '김',
    this.birthCalendar = CalendarKind.solar,
    this.birthYear,
    this.birthMonth,
    this.birthDay,
    this.birthLeapMonth = false,
    this.isDeceased = false,
    this.deathCalendar = CalendarKind.lunar,
    this.deathYear,
    this.deathMonth,
    this.deathDay,
    this.deathLeapMonth = false,
    this.officeTitle,
    this.notes,
  });

  final String id;
  final String name;
  final Gender gender;
  final Kinship kinship;
  final String bonGwan;
  final String surname;
  final CalendarKind birthCalendar;
  final int? birthYear;
  final int? birthMonth;
  final int? birthDay;
  final bool birthLeapMonth;
  final bool isDeceased;
  final CalendarKind deathCalendar;
  final int? deathYear;
  final int? deathMonth;
  final int? deathDay;
  final bool deathLeapMonth;
  final String? officeTitle;
  final String? notes;

  bool get isMale => gender == Gender.male;

  String get displayClan {
    if (bonGwan.isEmpty) return '$surname씨';
    return '$bonGwan$surname씨';
  }

  FamilyMember copyWith({
    String? name,
    Gender? gender,
    Kinship? kinship,
    String? bonGwan,
    String? surname,
    CalendarKind? birthCalendar,
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    bool? birthLeapMonth,
    bool? isDeceased,
    CalendarKind? deathCalendar,
    int? deathYear,
    int? deathMonth,
    int? deathDay,
    bool? deathLeapMonth,
    String? officeTitle,
    String? notes,
  }) {
    return FamilyMember(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      kinship: kinship ?? this.kinship,
      bonGwan: bonGwan ?? this.bonGwan,
      surname: surname ?? this.surname,
      birthCalendar: birthCalendar ?? this.birthCalendar,
      birthYear: birthYear ?? this.birthYear,
      birthMonth: birthMonth ?? this.birthMonth,
      birthDay: birthDay ?? this.birthDay,
      birthLeapMonth: birthLeapMonth ?? this.birthLeapMonth,
      isDeceased: isDeceased ?? this.isDeceased,
      deathCalendar: deathCalendar ?? this.deathCalendar,
      deathYear: deathYear ?? this.deathYear,
      deathMonth: deathMonth ?? this.deathMonth,
      deathDay: deathDay ?? this.deathDay,
      deathLeapMonth: deathLeapMonth ?? this.deathLeapMonth,
      officeTitle: officeTitle ?? this.officeTitle,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender.name,
    'kinship': kinship.name,
    'bonGwan': bonGwan,
    'surname': surname,
    'birthCalendar': birthCalendar.name,
    'birthYear': birthYear,
    'birthMonth': birthMonth,
    'birthDay': birthDay,
    'birthLeapMonth': birthLeapMonth,
    'isDeceased': isDeceased,
    'deathCalendar': deathCalendar.name,
    'deathYear': deathYear,
    'deathMonth': deathMonth,
    'deathDay': deathDay,
    'deathLeapMonth': deathLeapMonth,
    'officeTitle': officeTitle,
    'notes': notes,
  };

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: Gender.values.byName(json['gender'] as String),
      kinship: Kinship.values.byName(json['kinship'] as String),
      bonGwan: json['bonGwan'] as String? ?? '광산',
      surname: json['surname'] as String? ?? '김',
      birthCalendar: CalendarKind.values.byName(
        json['birthCalendar'] as String? ?? 'solar',
      ),
      birthYear: json['birthYear'] as int?,
      birthMonth: json['birthMonth'] as int?,
      birthDay: json['birthDay'] as int?,
      birthLeapMonth: json['birthLeapMonth'] as bool? ?? false,
      isDeceased: json['isDeceased'] as bool? ?? false,
      deathCalendar: CalendarKind.values.byName(
        json['deathCalendar'] as String? ?? 'lunar',
      ),
      deathYear: json['deathYear'] as int?,
      deathMonth: json['deathMonth'] as int?,
      deathDay: json['deathDay'] as int?,
      deathLeapMonth: json['deathLeapMonth'] as bool? ?? false,
      officeTitle: json['officeTitle'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
