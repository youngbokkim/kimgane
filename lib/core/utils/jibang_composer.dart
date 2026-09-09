import 'package:kimgane/core/constants/clan.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_member.dart';

class JibangPersonText {
  const JibangPersonText({
    required this.hanja,
    required this.hangul,
    required this.isMale,
    required this.name,
  });

  final String hanja;
  final String hangul;
  final bool isMale;
  final String name;

  List<String> get hanjaChars => hanja.characters.toList();
  List<String> get hangulChars => hangul.characters.toList();
}

extension on String {
  List<String> get characters => runes.map(String.fromCharCode).toList();
}

class JibangComposer {
  JibangPersonText compose(FamilyMember member) {
    if (member.isMale) {
      return _male(member);
    }
    return _female(member);
  }

  JibangPersonText _male(FamilyMember member) {
    final relation = member.kinship.hanjaRelation;
    final hangulRelation = member.kinship.hangulRelation;
    final title = (member.officeTitle == null || member.officeTitle!.isEmpty)
        ? '學生'
        : member.officeTitle!;
    final hangulTitle = title == '學生' ? '학생' : title;
    final prefix = member.kinship.usesGoPrefix ? '故' : '顯';
    final hangulPrefix = member.kinship.usesGoPrefix ? '고' : '현';
    final hanja =
        '$prefix$relation$title${relation.isEmpty ? member.name : '府君'}神位';
    final hangul =
        '$hangulPrefix$hangulRelation$hangulTitle${hangulRelation.isEmpty ? member.name : '부군'}신위';
    return JibangPersonText(
      hanja: hanja,
      hangul: hangul,
      isMale: true,
      name: member.name,
    );
  }

  JibangPersonText _female(FamilyMember member) {
    final relation = member.kinship.hanjaRelation;
    final hangulRelation = member.kinship.hangulRelation;
    final title = (member.officeTitle == null || member.officeTitle!.isEmpty)
        ? '孺人'
        : member.officeTitle!;
    final hangulTitle = title == '孺人' ? '유인' : title;
    final prefix = member.kinship.usesGoPrefix ? '故' : '顯';
    final hangulPrefix = member.kinship.usesGoPrefix ? '고' : '현';
    final clan = ClanCatalog.hanjaOfBonGwan(member.bonGwan);
    final surname = ClanCatalog.hanjaOfSurname(member.surname);
    final hanja = '$prefix$relation$title$clan$surname氏神位';
    final hangul =
        '$hangulPrefix$hangulRelation$hangulTitle${member.bonGwan}${member.surname}씨신위';
    return JibangPersonText(
      hanja: hanja,
      hangul: hangul,
      isMale: false,
      name: member.name,
    );
  }

  List<JibangPersonText> pairFor(List<FamilyMember> members) {
    final texts = members.map(compose).toList();
    texts.sort((a, b) {
      if (a.isMale == b.isMale) return 0;
      return a.isMale ? -1 : 1;
    });
    return texts;
  }
}
