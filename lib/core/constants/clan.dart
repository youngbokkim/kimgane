class ClanCatalog {
  static const hometown = '경상북도 의성';
  static const clanName = '광산김씨';
  static const clanHanja = '光山金氏';

  static const bonGwanHanja = <String, String>{
    '광산': '光山',
    '김해': '金海',
    '경주': '慶州',
    '전주': '全州',
    '안동': '安東',
    '밀양': '密陽',
    '파평': '坡平',
    '청주': '淸州',
    '해주': '海州',
    '연안': '延安',
    '한산': '韓山',
    '의성': '義城',
    '순천': '順天',
    '나주': '羅州',
    '진주': '晉州',
    '수원': '水原',
    '이천': '利川',
    '문화': '文化',
    '창녕': '昌寧',
    '상산': '尙山',
    '함양': '咸陽',
    '동래': '東萊',
    '달성': '達城',
    '해주오': '海州',
    '풍산': '豊山',
    '성산': '星山',
    '영천': '永川',
    '고성': '固城',
    '창원': '昌原',
    '평산': '平山',
    '덕수': '德水',
  };

  static const surnameHanja = <String, String>{
    '김': '金',
    '이': '李',
    '박': '朴',
    '최': '崔',
    '정': '鄭',
    '강': '姜',
    '조': '趙',
    '윤': '尹',
    '장': '張',
    '임': '林',
    '한': '韓',
    '오': '吳',
    '서': '徐',
    '신': '申',
    '권': '權',
    '황': '黃',
    '안': '安',
    '송': '宋',
    '류': '柳',
    '유': '柳',
    '홍': '洪',
    '고': '高',
    '문': '文',
    '양': '梁',
    '손': '孫',
    '배': '裵',
    '백': '白',
    '허': '許',
    '남': '南',
    '심': '沈',
    '노': '盧',
    '하': '河',
    '전': '全',
    '민': '閔',
    '구': '具',
    '진': '陳',
    '엄': '嚴',
    '원': '元',
    '천': '千',
    '방': '方',
    '공': '孔',
    '현': '玄',
    '함': '咸',
    '여': '呂',
    '추': '秋',
  };

  static String hanjaOfBonGwan(String? bonGwan) {
    if (bonGwan == null || bonGwan.isEmpty) return '光山';
    return bonGwanHanja[bonGwan] ?? bonGwan;
  }

  static String hanjaOfSurname(String? surname) {
    if (surname == null || surname.isEmpty) return '金';
    return surnameHanja[surname] ?? surname;
  }
}
