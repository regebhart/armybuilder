import 'package:armybuilder/models/abilities.dart';

class SpecialAbility {
  Ability topability;
  List<Ability> subabilities;

  SpecialAbility({
    required this.topability,
    required this.subabilities,
  });

  factory SpecialAbility.fromJson(Map<String, dynamic> json) {
    Ability topability = Ability.fromJson(json['topability']);
    List<Ability> subs = [];
    for (var sa in json['subabilities']) {
      subs.add(Ability.fromJson(sa));
    }

    return SpecialAbility(
      topability: topability,
      subabilities: subs,
    );
  }
}
