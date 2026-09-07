class HanjaLine {
  const HanjaLine({
    required this.hanja,
    required this.hangul,
    required this.meaning,
  });

  final String hanja;
  final String hangul;
  final String meaning;
}

class ClanPhotoSection {
  const ClanPhotoSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.summary,
    required this.lines,
    this.glossary = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String assetPath;
  final String summary;
  final List<HanjaLine> lines;
  final List<HanjaLine> glossary;
}

class ClanIntroContent {
  static const intro =
      '광산김씨(光山金氏) 김가네 직계는 경상북도 의성 선영을 모십니다. '
      '아래 사진은 현재 가족묘의 비석과, 제사 때 할아버지·할머니께 올린 축문입니다. '
      '한문은 오른쪽에서 왼쪽으로 세로로 읽습니다. 판독이 족보와 다르면 족보를 따릅니다.';

  static const sections = <ClanPhotoSection>[
    ClanPhotoSection(
      id: 'seonjo',
      title: '직계선조 묘비',
      subtitle: '선조가 받으신 벼슬 · 광산김공 재근',
      assetPath: 'assets/images/jikgye_seonjo_myobi.jpeg',
      summary:
          '검은 비석에 흰 글씨로 새긴 직계선조 묘비입니다. 가운데가 주인공이고, 오른쪽은 벼슬, '
          '왼쪽은 배위(배우자)입니다. 조선 무반의 품계와 실직을 함께 밝혀 두었습니다.',
      lines: [
        HanjaLine(
          hanja: '嘉善大夫 折衝將軍 行龍驤衛副護軍',
          hangul: '가선대부 절충장군 행 용양위 부호군',
          meaning:
              '선조께서 받으신 벼슬입니다. 가선대부는 종이품(從二品), 절충장군은 정삼품(正三品) 무관 품계입니다. '
              '행(行)은 품계보다 낮은 실직을 맡았을 때 붙입니다. 실제 직책은 오위(五衛) 가운데 용양위 부호군(종4품)이었습니다.',
        ),
        HanjaLine(
          hanja: '光山金公在根之墓',
          hangul: '광산김공 재근지묘',
          meaning: '광산김씨 김재근 어른의 묘라는 뜻입니다. 공(公)은 높여 부르는 말입니다.',
        ),
        HanjaLine(
          hanja: '配貞夫人坡平尹氏云伊祔',
          hangul: '배 정부인 파평윤씨 운이 부',
          meaning:
              '배위는 정부인 파평윤씨 운이 여사입니다. 정부인은 종이품 관원의 부인에게 내리던 봉작이고, '
              '부(祔)는 한 묘에 합장하였다는 뜻입니다.',
        ),
      ],
      glossary: [
        HanjaLine(
          hanja: '嘉善大夫',
          hangul: '가선대부',
          meaning: '조선 문무 품계 종이품. 정2품 바로 아래입니다.',
        ),
        HanjaLine(
          hanja: '折衝將軍',
          hangul: '절충장군',
          meaning: '무관 품계 정삼품. 외적의 창을 꺾는 장군이라는 뜻입니다.',
        ),
        HanjaLine(
          hanja: '龍驤衛',
          hangul: '용양위',
          meaning: '조선 중앙군 오위(의흥·용양·호분·충좌·충무) 가운데 하나입니다.',
        ),
        HanjaLine(
          hanja: '副護軍',
          hangul: '부호군',
          meaning: '오위에 속한 군직. 종4품입니다.',
        ),
        HanjaLine(
          hanja: '貞夫人',
          hangul: '정부인',
          meaning: '종이품 관원 부인의 외명부 봉작입니다.',
        ),
      ],
    ),
    ClanPhotoSection(
      id: 'gen36',
      title: '가족묘 비석 · 36대 앞면',
      subtitle: '36世 김명룡 · 배위 상산박씨',
      assetPath: 'assets/images/family_stone_36_front.jpeg',
      summary:
          '현재 가족묘에 세워 둔 36대 표석입니다. 위쪽에 대수와 휘를 쓰고, 아래에 배위와 '
          '생졸(生卒)을 적었습니다. 父·母는 비를 세운 자손 입장에서 아버지·어머니를 가리킵니다.',
      lines: [
        HanjaLine(
          hanja: '36世 命龍之墓',
          hangul: '삼십육세 명룡지묘',
          meaning: '시조로부터 서른여섯 번째 대, 김명룡 어른의 묘입니다.',
        ),
        HanjaLine(
          hanja: '配 尙山朴千分 祔',
          hangul: '배 상산박 천분 부',
          meaning: '배위는 상산박씨 박천분 여사이며, 한자리에 합장하였습니다.',
        ),
        HanjaLine(
          hanja: '父 1908.7.5 生  1990.9.14 卒',
          hangul: '부 1908년 7월 5일 생 · 1990년 9월 14일 졸',
          meaning: '36대 김명룡 어른의 나신 날과 돌아가신 날입니다. 생(生)은 태어남, 졸(卒)은 돌아가심입니다.',
        ),
        HanjaLine(
          hanja: '母 1919.6.6 生  1991.2.10 卒',
          hangul: '모 1919년 6월 6일 생 · 1991년 2월 10일 졸',
          meaning: '배위 상산박씨 박천분 여사의 나신 날과 돌아가신 날입니다.',
        ),
      ],
      glossary: [
        HanjaLine(hanja: '世', hangul: '세', meaning: '대(代). 시조로부터 몇 번째인지를 적습니다.'),
        HanjaLine(hanja: '之墓', hangul: '지묘', meaning: '~의 무덤.'),
        HanjaLine(hanja: '配', hangul: '배', meaning: '배위. 배우자.'),
        HanjaLine(hanja: '祔', hangul: '부', meaning: '합장. 같은 자리에 모심.'),
        HanjaLine(hanja: '生 / 卒', hangul: '생 / 졸', meaning: '태어남 / 돌아가심.'),
      ],
    ),
    ClanPhotoSection(
      id: 'gen37-front',
      title: '가족묘 비석 · 37대 앞면',
      subtitle: '37世 김덕만 · 배위 해주오씨',
      assetPath: 'assets/images/family_stone_37_front.jpeg',
      summary:
          '37대 표석 앞면입니다. 36대와 같은 형식으로, 위는 휘와 배위, 아래는 생졸입니다. '
          '할아버지·할머니 기제와 묘제를 준비할 때 이름과 기일을 확인하는 돌입니다.',
      lines: [
        HanjaLine(
          hanja: '37世 德萬之墓',
          hangul: '삼십칠세 덕만지묘',
          meaning: '서른일곱 번째 대, 김덕만 어른의 묘입니다.',
        ),
        HanjaLine(
          hanja: '配海州吳利粉祔',
          hangul: '배 해주오 이분 부',
          meaning: '배위는 해주오씨 오이분(利粉) 여사이며, 합장하였습니다.',
        ),
        HanjaLine(
          hanja: '父 1936.2.2 生  2010.3.16 卒',
          hangul: '부 1936년 2월 2일 생 · 2010년 3월 16일 졸',
          meaning: '37대 김덕만 어른의 나신 날과 돌아가신 날입니다.',
        ),
        HanjaLine(
          hanja: '母 1937.11.28 生  2023.7.29 卒',
          hangul: '모 1937년 11월 28일 생 · 2023년 7월 29일 졸',
          meaning: '배위 해주오씨 오이분 여사의 나신 날과 돌아가신 날입니다.',
        ),
      ],
      glossary: [
        HanjaLine(hanja: '海州吳氏', hangul: '해주오씨', meaning: '배위의 본관과 성씨입니다.'),
        HanjaLine(hanja: '德萬', hangul: '덕만', meaning: '37대 선조의 휘입니다.'),
      ],
    ),
    ClanPhotoSection(
      id: 'gen37-back',
      title: '가족묘 비석 · 37대 뒷면',
      subtitle: '비를 세운 해와 자손의 이름',
      assetPath: 'assets/images/family_stone_37_back.jpeg',
      summary:
          '비석 뒷면(음기)에는 언제 누구의 손으로 비를 세웠는지를 적습니다. '
          '오른쪽이 앞이고, 아들·며느리·딸·사위·손자·손녀 순으로 이어집니다. '
          '2012년 5월에 세운 기록입니다.',
      lines: [
        HanjaLine(
          hanja: '二〇十二年五月 日',
          hangul: '이공십이년 오월 일',
          meaning: '서기 2012년 5월에 비를 세웠습니다. 날짜 칸은 비워 두는 경우가 많습니다.',
        ),
        HanjaLine(
          hanja: '子 永弼  ·  子婦 金永淑',
          hangul: '자 영필 · 자부 김영숙',
          meaning: '아들 영필, 며느리 김영숙입니다. 자(子)는 아들, 자부(子婦)는 며느리입니다.',
        ),
        HanjaLine(
          hanja: '永泰  ·  永玉  ·  壻 李秀珍',
          hangul: '영태 · 영옥 · 서 이수진',
          meaning: '자손 영태·영옥과, 사위 이수진입니다. 서(壻)는 사위입니다.',
        ),
        HanjaLine(
          hanja: '女 점이  ·  壻 윤재원  ·  광순  ·  이춘근',
          hangul: '녀 점이 · 서 윤재원 · 광순 · 이춘근',
          meaning: '딸 점이와 사위 윤재원, 그리고 광순·이춘근 내외입니다. 여(女)는 딸입니다.',
        ),
        HanjaLine(
          hanja: '孫 기윤  ·  孫女 지선 지은 민경 서희 가민',
          hangul: '손 기윤 · 손녀 지선·지은·민경·서희·가민',
          meaning: '손자 기윤, 손녀 지선·지은·민경·서희·가민입니다. 손(孫)은 손자, 손녀(孫女)는 손녀입니다.',
        ),
      ],
      glossary: [
        HanjaLine(hanja: '子', hangul: '자', meaning: '아들'),
        HanjaLine(hanja: '子婦', hangul: '자부', meaning: '며느리'),
        HanjaLine(hanja: '女', hangul: '여', meaning: '딸'),
        HanjaLine(hanja: '壻', hangul: '서', meaning: '사위'),
        HanjaLine(hanja: '孫', hangul: '손', meaning: '손자'),
        HanjaLine(hanja: '孫女', hangul: '손녀', meaning: '손녀'),
      ],
    ),
    ClanPhotoSection(
      id: 'chukmun',
      title: '제사 축문',
      subtitle: '할아버지·할머니 기제에 올린 글',
      assetPath: 'assets/images/jesa_chukmun.jpeg',
      summary:
          '묘소 앞에서 할아버지·할머니께 고할 때 쓴 축문입니다. 한문 축문을 한글로 풀어 쓴 글로, '
          '오른쪽부터 세로로 읽습니다. 효손 영필이 제주가 되어 기일을 알리고 술과 음식을 올리며 흠향을 청합니다.',
      lines: [
        HanjaLine(
          hanja: '丙午年 七月 二十五日',
          hangul: '병오년 칠월 스무닷새',
          meaning:
              '병오년(丙午年) 음력 7월 25일입니다. 육십갑자로 해를 적는 제사 축문의 첫머리입니다.',
        ),
        HanjaLine(
          hanja: '孝孫 永弼',
          hangul: '효손 영필이 할아버지 할머님께 고하옵니다',
          meaning: '효손(孝孫)은 효성을 다하는 손자라는 뜻입니다. 제주 영필이 조부모께 아뢰는 인사입니다.',
        ),
        HanjaLine(
          hanja: '忌日',
          hangul: '세월이 흘러 할아버님 할머님의 기일이 도래하였네요',
          meaning: '기일(忌日)은 돌아가신 날입니다. 한 해가 돌아와 제사를 올리게 되었음을 고합니다.',
        ),
        HanjaLine(
          hanja: '恩功',
          hangul: '생전에 할아버님과 할머님의 은공을 갚을 길이 없사옵니다',
          meaning: '은공(恩功)은 끼쳐 주신 은혜와 공덕입니다. 다 갚을 수 없음을 아뢰는 대목입니다.',
        ),
        HanjaLine(
          hanja: '歆饗',
          hangul: '이에 후손들이 여러가지 음식과 맑은 술을 올리오니 흠향 하시옵소서',
          meaning:
              '흠향(歆饗)은 조상께서 제물을 흠향하신다는 말입니다. 잡수시고 받아 달라는 청입니다.',
        ),
        HanjaLine(
          hanja: '保佑',
          hangul: '할아버지 할머님 저희 집안을 두루두루 살펴 주시옵소서',
          meaning: '자손을 보살펴 달라는 기원의 맺음입니다. 전통 축문의 보호(保佑)에 해당하는 뜻입니다.',
        ),
      ],
      glossary: [
        HanjaLine(hanja: '軸文 / 祝文', hangul: '축문', meaning: '제사 때 조상께 고하는 글.'),
        HanjaLine(hanja: '孝孫', hangul: '효손', meaning: '제사를 주관하는 손자.'),
        HanjaLine(hanja: '告', hangul: '고하다', meaning: '신위 앞에 아뢰다.'),
        HanjaLine(hanja: '忌日', hangul: '기일', meaning: '돌아가신 날.'),
        HanjaLine(hanja: '恩功', hangul: '은공', meaning: '은혜와 공덕.'),
        HanjaLine(hanja: '歆饗', hangul: '흠향', meaning: '제물을 받아 누리심.'),
      ],
    ),
  ];
}
