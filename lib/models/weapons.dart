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
  List<SpecialAbility>? nestedabilities;
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

    List<SpecialAbility> nestedabilities = [];
    if (json.containsKey('nestedabilities')) {
      for (var n in json['nestedabilities']) {
        nestedabilities.add(SpecialAbility.fromJson(n));
      }
    }

    List<String> presetabilities = [];
    if (json.containsKey('presetabilities')) {
      for (var ab in json['presetabilities']) {
        presetabilities.add(ab);
      }
    }

    return Weapon(
      name: json['name'],
      type: json['type'],
      fieldoffire: json['fieldoffire'] ?? '',
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
}
