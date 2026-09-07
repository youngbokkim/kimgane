class AppSettings {
  const AppSettings({
    required this.officiantId,
    this.defaultBonGwan = '광산',
    this.defaultSurname = '김',
    this.hometown = '경상북도 의성',
  });

  final String officiantId;
  final String defaultBonGwan;
  final String defaultSurname;
  final String hometown;

  AppSettings copyWith({
    String? officiantId,
    String? defaultBonGwan,
    String? defaultSurname,
    String? hometown,
  }) {
    return AppSettings(
      officiantId: officiantId ?? this.officiantId,
      defaultBonGwan: defaultBonGwan ?? this.defaultBonGwan,
      defaultSurname: defaultSurname ?? this.defaultSurname,
      hometown: hometown ?? this.hometown,
    );
  }

  Map<String, dynamic> toJson() => {
    'officiantId': officiantId,
    'defaultBonGwan': defaultBonGwan,
    'defaultSurname': defaultSurname,
    'hometown': hometown,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      officiantId: SeedIds.officiant,
      defaultBonGwan: json['defaultBonGwan'] as String? ?? '광산',
      defaultSurname: json['defaultSurname'] as String? ?? '김',
      hometown: json['hometown'] as String? ?? '경상북도 의성',
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
