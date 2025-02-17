import '../models/abilities.dart';
import '../models/specialability.dart';

class Weapon {
  String name;
  String type;
  String? fieldoffire;
  String rng;
  String? rof;
  String? aoe;
  String pow;
  String? system;
  List<NestedAbility>? nestedabilities;
  List<String>? damagetype;
  List<Ability>? abilities;
  List<String>? presetabilities;
  String? count;

  Weapon({
    required this.name,
    required this.type,
    this.fieldoffire,
    required this.rng,
    this.rof,
    this.aoe,
    required this.pow,
    this.system,
    this.nestedabilities,
    this.damagetype,
    this.abilities,
    this.presetabilities,
    this.count,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    List<String> damagetypes = [];
    String fieldoffire = '';

    if (json.containsKey('damagetype')) {
      for (var d in json['damagetype']) {
        damagetypes.add(d);
      }
    }

    List<Ability> abilities = [];
    if (json.containsKey('ability')) {
      for (var a in json['ability']) {
        Ability ability = Ability.fromJson(a);
        abilities.add(ability);
      }
    }

    List<NestedAbility> nestedabilities = [];
    if (json.containsKey('nestedabilities')) {
      for (var n in json['nestedabilities']) {
        nestedabilities.add(NestedAbility.fromJson(n));
      }
    }

    List<String> presetabilities = [];
    if (json.containsKey('presetabilities')) {
      for (var ab in json['presetabilities']) {
        presetabilities.add(ab);
      }
    }

    if (json.containsKey('fieldoffire')) {
      fieldoffire = json['fieldoffire'].toString().toLowerCase();
    }

    return Weapon(
      name: json['name'],
      type: json['type'],
      fieldoffire: fieldoffire,
      rng: json['rng'],
      rof: json['rof'] ?? '-',
      aoe: json['aoe'] ?? '-',
      pow: json['pow'] ?? '-',
      system: json['system'] ?? '',
      count: json['count'] ?? '1',
      nestedabilities: nestedabilities,
      damagetype: damagetypes,
      abilities: abilities,
      presetabilities: presetabilities,
    );
  }

  factory Weapon.copy(Weapon weapon) {
    return Weapon(
        name: weapon.name,
        type: weapon.type,
        fieldoffire: weapon.fieldoffire,
        rng: weapon.rng,
        rof: weapon.rof,
        aoe: weapon.aoe,
        pow: weapon.pow,
        system: weapon.system,
        count: weapon.count,
        nestedabilities: List.generate(
          weapon.nestedabilities!.length,
          (index) => NestedAbility.copy(weapon.nestedabilities![index]),
        ),
        damagetype: weapon.damagetype!,
        abilities: List.generate(
          weapon.abilities!.length,
          (index) => Ability.copy(weapon.abilities![index]),
        ),
        presetabilities: weapon.presetabilities!);
  }
}
