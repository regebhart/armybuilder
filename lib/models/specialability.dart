import 'package:armybuilder/models/abilities.dart';

class NestedAbility {
  Ability topability;
  List<Ability> subabilities;

  NestedAbility({
    required this.topability,
    required this.subabilities,
  });

  factory NestedAbility.fromJson(Map<String, dynamic> json) {
    Ability topability = Ability.fromJson(json['topability']);
    List<Ability> subs = [];
    for (var sa in json['subabilities']) {
      subs.add(Ability.fromJson(sa));
    }

    return NestedAbility(
      topability: topability,
      subabilities: subs,
    );
  }

  factory NestedAbility.copy(NestedAbility nestedability) {
    return NestedAbility(
      topability: Ability.copy(nestedability.topability),
      subabilities: List.generate(
        nestedability.subabilities.length,
        (index) => nestedability.subabilities[index],
      ),
    );
  }
}
