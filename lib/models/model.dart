import 'package:armybuilder/models/abilities.dart';
import 'package:armybuilder/models/animi.dart';
import 'package:armybuilder/models/custombar.dart';
import 'package:armybuilder/models/hpbar.dart';
import 'package:armybuilder/models/spells.dart';
import '../models/base_stats.dart';
import '../models/grid.dart';
import '../models/specialability.dart';
import '../models/weapons.dart';

import 'feats.dart';
import 'modularoptions.dart';
import 'spiral.dart';
import 'trump.dart';
import 'web.dart';

class Model {
  String modelname;
  String title;
  List<String> modeltype;
  List<String>? keywords;
  List<Ability>? characterabilities;
  BaseStats stats;
  List<hpbar>? hpbars;
  List<CustomBar>? custombars;
  Ability? execution;
  List<NestedAbility>? nestedabilities;
  List<Weapon>? weapons;
  List<ModularOption>? modularoptions;
  Feat? feat;
  TrumpArcana? arcana;
  List<Spell>? spells;
  Grid? grid;
  String? shield;
  Spiral? spiral;
  Web? web;
  int? displayOrderIndex;
  List<Animus>? animi;
  bool? hasMarshal;
  String? heartofdarknessfaction;
  String? casteradeptfaction;

  Model({
    required this.modelname,
    required this.title,
    required this.modeltype,
    this.keywords,
    this.characterabilities,
    required this.stats,
    this.hpbars,
    this.custombars,
    this.execution,
    this.nestedabilities,
    this.weapons,
    this.modularoptions,
    this.feat,
    this.arcana,
    this.spells,
    this.grid,
    this.shield,
    this.spiral,
    this.web,
    this.displayOrderIndex,
    this.animi,
    this.hasMarshal,
    this.heartofdarknessfaction,
    this.casteradeptfaction,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    String name = '';
    if (json.containsKey('modelname')) {
      name = json['modelname'];
    } else {
      name = json['name'];
    }
    // print(name);

    String title = '';
    if (json.containsKey('title')) {
      title = json['title'];
    }

    int displayorder = 0;
    if (json.containsKey('displayorder')) {
      displayorder = json['displayorder'];
    }

    List<String> modeltype = [];
    if (json.containsKey('modeltype')) {
      for (var m in json['modeltype']) {
        modeltype.add(m);
      }
    }
    // print("keywords");
    List<String> keywords = [];
    bool hasMarshal = false;
    if (json.containsKey('keywords')) {
      for (String a in json['keywords']) {
        keywords.add(a);
        if (a.toLowerCase().contains('jack marshal')) {
          hasMarshal = true;
        }
      }
    }

    List<hpbar> hpbars = [];
    if (json.containsKey('hpbars')) {
      for (var hp in json['hpbars']) {
        hpbars.add(hpbar(name: hp['name'], hp: hp['hp'], damage: 0));
      }
    }

    List<CustomBar> custombars = [];
    if (json.containsKey('custombars')) {
      for (var c in json['custombars']) {
        custombars.add(CustomBar.fromJson(c));
      }
    }

    List<Weapon> weapons = [];
    if (json.containsKey('weapons')) {
      for (var w in json['weapons']) {
        Weapon weapon = Weapon.fromJson(w);
        weapons.add(weapon);
      }
    }

    List<ModularOption> modularoptions = [];
    if (json.containsKey('modularoptions')) {
      for (var op in json['modularoptions']) {
        ModularOption mo = ModularOption.fromJson(op);
        modularoptions.add(mo);
      }
    }

    List<Spell> spelllist = [];
    if (json.containsKey('spells')) {
      for (var sp in json['spells']) {
        spelllist.add(Spell.fromJson(sp));
      }
    }

    // print("character abilities");
    List<Ability> characterabilities = [];
    String heartofdarknessfaction = '';
    String casteradeptfaction = '';
    if (json.containsKey('characterabilities')) {
      for (var ab in json['characterabilities']) {
        characterabilities.add(Ability.fromJson(ab));
        String abname = characterabilities.last.name.toLowerCase();
        if (abname.contains('heart of darkness')) {
          heartofdarknessfaction = abname.substring(abname.indexOf('[') + 1, abname.length - 1);
        }
        if (abname.contains('caster adept')) {
          casteradeptfaction = abname.substring(abname.indexOf('[') + 1, abname.length - 1);
        }
      }
    }

    // print("execution");
    Ability execution = Ability(name: '', description: '');
    if (json.containsKey('execution')) {
      execution = Ability.fromJson(json['execution']);
    }

    // print("feat");
    Feat feat = Feat(name: "", description: "");
    if (json.containsKey('feat')) {
      feat = Feat.fromJson(json['feat']);
    }

    TrumpArcana arcana = TrumpArcana(name: "", description: "");
    if (json.containsKey('arcana')) {
      arcana = TrumpArcana.fromJson(json['arcana']);
    }

    List<NestedAbility> nestedabilities = [];
    if (json.containsKey('nestedabilities')) {
      for (var n in json['nestedabilities']) {
        nestedabilities.add(NestedAbility.fromJson(n));
      }
    }

    BaseStats baseStats = BaseStats.fromJson(json['stats']);

    Grid grid = Grid(columns: []);
    if (json.containsKey('grid')) {
      grid = Grid.fromJson(json['grid']);
    }

    String shield = '';
    if (json.containsKey('shield')) {
      shield = json['shield'];
    }

    Spiral spiral = Spiral(values: [], dots: []);
    if (json.containsKey('spiral')) {
      spiral = Spiral.fromJson(json['spiral']);
    }

    Web web = Web(values: [], dots: []);
    if (json.containsKey('web')) {
      web = Web.fromJson(json['web']);
    }

    List<Animus> animi = [];
    if (json.containsKey('animi')) {
      for (var a in json['animi']) {
        animi.add(Animus.fromJson(a));
      }
    }

    return Model(
      modelname: name,
      title: title,
      modeltype: modeltype,
      keywords: keywords,
      characterabilities: characterabilities,
      execution: execution,
      stats: baseStats,
      hpbars: hpbars,
      custombars: custombars,
      nestedabilities: nestedabilities,
      weapons: weapons,
      modularoptions: modularoptions,
      feat: feat,
      arcana: arcana,
      spells: spelllist,
      grid: grid,
      shield: shield,
      spiral: spiral,
      web: web,
      displayOrderIndex: displayorder,
      animi: animi,
      hasMarshal: hasMarshal,
      heartofdarknessfaction: heartofdarknessfaction,
      casteradeptfaction: casteradeptfaction,
    );
  }

  factory Model.copy(Model model) {
    Model newcopy = Model(
      modelname: model.modelname,
      title: model.title,
      modeltype: model.modeltype,
      keywords: model.keywords,
      characterabilities: List.generate(
        model.characterabilities!.length,
        (index) => Ability.copy(model.characterabilities![index]),
      ),
      execution: Ability.copy(model.execution!),
      stats: BaseStats.copy(model.stats),
      hpbars: List.generate(
        model.hpbars!.length,
        (index) => hpbar.copy(model.hpbars![index]),
      ),
      custombars: List.generate(
        model.custombars!.length,
        (index) => CustomBar.copy(model.custombars![index]),
      ),
      nestedabilities: List.generate(
        model.nestedabilities!.length,
        (index) => NestedAbility.copy(model.nestedabilities![index]),
      ),
      weapons: List.generate(
        model.weapons!.length,
        (index) => Weapon.copy(model.weapons![index]),
      ),
      modularoptions: List.generate(
        model.modularoptions!.length,
        (index) => ModularOption.copy(model.modularoptions![index]),
      ),
      feat: Feat.copy(model.feat!),
      arcana: TrumpArcana.copy(model.arcana!),
      spells: List.generate(
        model.spells!.length,
        (index) => Spell.copy(model.spells![index]),
      ),
      grid: Grid.copy(model.grid!),
      shield: model.shield,
      spiral: Spiral.copy(model.spiral!),
      web: Web.copy(model.web!),
      displayOrderIndex: model.displayOrderIndex,
      animi: List.generate(
        model.animi!.length,
        (index) => Animus.copy(model.animi![index]),
      ),
      hasMarshal: model.hasMarshal,
      heartofdarknessfaction: model.heartofdarknessfaction!,
      casteradeptfaction: model.casteradeptfaction!,
    );
    return newcopy;
  }
}
