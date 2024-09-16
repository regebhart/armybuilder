import 'package:armybuilder/models/abilities.dart';
import 'package:armybuilder/models/animi.dart';

import 'specialability.dart';
import 'stat_mods.dart';
import 'weapons.dart';

class ModularOption {
  String groupname;
  List<Option>? options;

  ModularOption({
    required this.groupname,
    this.options,
  });

  factory ModularOption.fromJson(Map<String, dynamic> json) {
    List<Option> options = [];

    if (json.containsKey('options')) {
      for (var op in json['options']) {
        options.add(Option.fromJson(op));
      }
    }

    return ModularOption(
      groupname: json['groupname'],
      options: options,
    );
  }

  factory ModularOption.copy(ModularOption option) {
    return ModularOption(
      groupname: option.groupname,
      options: List.generate(
        option.options!.length,
        (index) => Option.copy(option.options![index]),
      ),
    );
  }
}

class Option {
  List<String>? keywords;
  List<Ability>? abilities;
  List<NestedAbility>? nestedabilities;
  List<Weapon>? weapons;
  List<Animus>? animi;
  StatMods? statmods;
  String name;
  String cost;

  Option({
    this.keywords,
    this.abilities,
    this.nestedabilities,
    this.weapons,
    this.animi,
    this.statmods,
    required this.name,
    required this.cost,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    List<String> keywords = [];
    List<Ability> abilities = [];
    List<NestedAbility> nestedabilities = [];
    List<Weapon> weapons = [];
    List<Animus> animi = [];
    StatMods stats = StatMods();

    if (json.containsKey('keywords')) {
      for (var k in json['keywords']) {
        keywords.add(k);
      }
    }

    if (json.containsKey('abilities')) {
      for (var ab in json['abilities']) {
        abilities.add(Ability.fromJson(ab));
      }
    }

    if (json.containsKey('nestedabilities')) {
      for (var n in json['nestedabilities']) {
        nestedabilities.add(NestedAbility.fromJson(n));
      }
    }

    if (json.containsKey('weapons')) {
      for (var wp in json['weapons']) {
        weapons.add(Weapon.fromJson(wp));
      }
    }

    if (json.containsKey('animi')) {
      for (var a in json['animi']) {
        animi.add(Animus.fromJson(a));
      }
    }

    if (json.containsKey('statmods')) {
      stats = StatMods.fromJson(json['statmods']);
    }

    return Option(
      cost: json['cost'],
      name: json['name'],
      keywords: keywords,
      abilities: abilities,
      nestedabilities: nestedabilities,
      weapons: weapons,
      animi: animi,
      statmods: stats,
    );
  }

  factory Option.copy(Option option) {
    return Option(
      cost: option.cost,
      name: option.name,
      keywords: option.keywords,
      abilities: List.generate(
        option.abilities!.length,
        (index) => Ability.copy(option.abilities![index]),
      ),
      nestedabilities: List.generate(
        option.nestedabilities!.length,
        (index) => NestedAbility.copy(option.nestedabilities![index]),
      ),
      weapons: List.generate(
        option.weapons!.length,
        (index) => Weapon.copy(option.weapons![index]),
      ),
      animi: List.generate(
        option.animi!.length,
        (index) => option.animi![index],
      ),
      statmods: StatMods.copy(option.statmods!),
    );
  }
}
