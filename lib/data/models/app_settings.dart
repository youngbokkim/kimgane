class AppSettings {
  const AppSettings({
    required this.officiantId,
    this.defaultBonGwan = '광산',
    this.defaultSurname = '김',
    this.hometown = '경상북도 의성',
    this.notifyEnabled = true,
    this.notifyHour = 9,
    this.notifyMinute = 0,
  });

  final String officiantId;
  final String defaultBonGwan;
  final String defaultSurname;
  final String hometown;
  final bool notifyEnabled;
  final int notifyHour;
  final int notifyMinute;

  AppSettings copyWith({
    String? officiantId,
    String? defaultBonGwan,
    String? defaultSurname,
    String? hometown,
    bool? notifyEnabled,
    int? notifyHour,
    int? notifyMinute,
  }) {
    return AppSettings(
      officiantId: officiantId ?? this.officiantId,
      defaultBonGwan: defaultBonGwan ?? this.defaultBonGwan,
      defaultSurname: defaultSurname ?? this.defaultSurname,
      hometown: hometown ?? this.hometown,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
    );
  }

  Map<String, dynamic> toJson() => {
    'officiantId': officiantId,
    'defaultBonGwan': defaultBonGwan,
    'defaultSurname': defaultSurname,
    'hometown': hometown,
    'notifyEnabled': notifyEnabled,
    'notifyHour': notifyHour,
    'notifyMinute': notifyMinute,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      officiantId: SeedIds.officiant,
      defaultBonGwan: json['defaultBonGwan'] as String? ?? '광산',
      defaultSurname: json['defaultSurname'] as String? ?? '김',
      hometown: json['hometown'] as String? ?? '경상북도 의성',
      notifyEnabled: json['notifyEnabled'] as bool? ?? true,
      notifyHour: json['notifyHour'] as int? ?? 9,
      notifyMinute: json['notifyMinute'] as int? ?? 0,
    );
  }
}

class SeedIds {
  static const officiant = 'member-yeongpil';
  static const grandfather = 'member-myeongryong';
  static const grandmother = 'member-cheonbun';
  static const deokman = 'member-deokman';
  static const oibun = 'member-oibun';
  static const yeongpil = 'member-yeongpil';
  static const yeongsuk = 'member-yeongsuk';
  static const yeongtae = 'member-yeongtae';
  static const yeongok = 'member-yeongok';
  static const sujein = 'member-sujein';
  static const seohui = 'member-seohui';
  static const deoksu = 'member-deoksu';
  static const hamyeonghui = 'member-hamyeonghui';
  static const yeongbok = 'member-yeongbok';
  static const jeonghwa = 'member-jeonghwa';
  static const yeongjun = 'member-yeongjun';
  static const nuri = 'member-nuri';
}
