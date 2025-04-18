import 'package:armybuilder/models/spells.dart';
import 'package:armybuilder/providers/armylist.dart';

import 'cohort.dart';
import 'product.dart';
import 'unit.dart';

class ArmyList {
  String name;
  String listfaction;
  String totalpoints;
  String pointtarget;
  bool favorite;
  List<LeaderGroup> leadergroup;
  List<Unit> units;
  List<Product> solos;
  List<Product> battleengines;
  List<Product> structures;
  List<JrCasterGroup> jrcasters;
  bool heartofdarkness;
  bool flamesinthedarkness;

  ArmyList({
    required this.name,
    required this.listfaction,
    required this.totalpoints,
    required this.pointtarget,
    required this.favorite,
    required this.leadergroup,
    required this.units,
    required this.solos,
    required this.battleengines,
    required this.structures,
    required this.jrcasters,
    required this.heartofdarkness,
    required this.flamesinthedarkness,
  });

  factory ArmyList.fromJson(Map<String, dynamic> json) {
    List<LeaderGroup> leaders = [];
    for (var a in json['leadergroups']) {
      leaders.add(LeaderGroup.fromJson(a));
    }

    List<Unit> units = [];
    if (json.containsKey('units')) {
      for (var u in json['units']) {
        units.add(Unit.fromJson(u));
      }
    }

    List<Product> solos = [];
    if (json.containsKey('solos')) {
      for (var s in json['solos']) {
        solos.add(Product.fromJson(s));
      }
    }

    List<Product> battleengines = [];
    if (json.containsKey('battleengines')) {
      for (var be in json['battleenegines']) {
        battleengines.add(Product.fromJson(be));
      }
    }

    List<Product> structures = [];
    if (json.containsKey('structures')) {
      for (var s in json['structures']) {
        structures.add(Product.fromJson(s));
      }
    }

    List<JrCasterGroup> jrs = [];
    if (json.containsKey('jrcasters')) {
      for (var jr in json['jrcasters']) {
        jrs.add(JrCasterGroup.fromJson(jr));
      }
    }

    bool favorite = false;
    if (json.containsKey('favorite')) {
      favorite = json['favorite'];
    }

    bool heartofdarkness = false;
    if (json.containsKey('heartofdarkness')) {
      heartofdarkness = json['heartofdarkness'];
    }

    bool flamesinthedarkness = false;
    if (json.containsKey('flamesinthedarkness')) {
      heartofdarkness = json['flamesinthedarkness'];
    }

    return ArmyList(
      name: json['name'],
      listfaction: json['faction'],
      totalpoints: json['totalpoints'],
      pointtarget: json['pointtarget'],
      favorite: favorite,
      leadergroup: leaders,
      units: units,
      solos: solos,
      battleengines: battleengines,
      structures: structures,
      jrcasters: jrs,
      heartofdarkness: heartofdarkness,
      flamesinthedarkness: flamesinthedarkness,
    );
  }

  bool isEmpty() {
    for (var lg in leadergroup) {
      if (lg.leader.name != '') return false;
      if (lg.leaderattachment.name != '') return false;
      if (lg.cohort.isNotEmpty) return false;
    }
    for (var jr in jrcasters) {
      if (jr.leader.name != '') return false;
      if (jr.cohort.isNotEmpty) return false;
    }
    if (units.isNotEmpty) return false;
    if (solos.isNotEmpty) return false;
    if (battleengines.isNotEmpty) return false;
    if (structures.isNotEmpty) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['faction'] = listfaction;
    data['totalpoints'] = totalpoints;
    data['pointtarget'] = pointtarget;
    data['favorite'] = favorite;
    data['heartofdarkness'] = heartofdarkness;
    data['flamesinthedarkness'] = flamesinthedarkness;
    if (leadergroup.isNotEmpty) {
      List<Map<String, dynamic>> leadergroups = [];
      for (var lg in leadergroup) {
        Map<String, dynamic> group = {};
        group['leader'] = lg.leader.name;
        if (lg.spellrack!.isNotEmpty) {
          List<String> spellrack = [];
          for (var sp in lg.spellrack!) {
            spellrack.add(sp.name);
          }
          group['spellrack'] = spellrack;
        }
        if (lg.leaderattachment.name != '') group['leaderattachment'] = lg.leaderattachment.name;
        List<Map<String, dynamic>> cohort = [];
        if (lg.cohort.isNotEmpty) {
          for (var c in lg.cohort) {
            cohort.add({'product': c.product.name});
            if (c.selectedOptions!.isNotEmpty) {
              List<String> options = [];
              for (var m in c.selectedOptions!) {
                options.add(m.name);
              }
              cohort.last['modularoptions'] = options;
            }
          }
          group['cohort'] = cohort;
        }
        List<Map<String, dynamic>> oofcohort = [];
        if (lg.oofcohort.isNotEmpty) {
          for (var c in lg.oofcohort) {
            oofcohort.add({'product': c.product.name});
            if (c.selectedOptions!.isNotEmpty) {
              List<String> options = [];
              for (var m in c.selectedOptions!) {
                options.add(m.name);
              }
              oofcohort.last['modularoptions'] = options;
            }
          }
          group['oofcohort'] = oofcohort;
        }
        if (lg.oofjrcasters.isNotEmpty) {
          List<Map<String, dynamic>> jrs = [];
          for (var j in lg.oofjrcasters) {
            Map<String, dynamic> jrgroup = {};
            jrgroup['leader'] = j.leader.name;
            List<Map<String, dynamic>> cohort = [];
            if (j.cohort.isNotEmpty) {
              for (var c in j.cohort) {
                cohort.add({'product': c.product.name});
                if (c.selectedOptions!.isNotEmpty) {
                  List<String> options = [];
                  for (var m in c.selectedOptions!) {
                    options.add(m.name);
                  }
                  cohort.last['modularoptions'] = options;
                }
              }
              jrgroup['cohort'] = cohort;
            }
            jrs.add(jrgroup);
          }
          group['oofjrcasters'] = jrs;
        }
        if (lg.oofsolos.isNotEmpty) {
          List<String> ss = [];
          for (var s in lg.oofsolos) {
            ss.add(s.name);
          }
          group['oofsolos'] = ss;
        }
        if (lg.oofunits.isNotEmpty) {
          List<Map<String, dynamic>> us = [];
          for (var u in lg.oofunits) {
            Map<String, dynamic> unit = {};
            unit['unit'] = u.unit.name;
            unit['minsize'] = u.minsize;
            if (u.commandattachment.name != '') unit['commandattachment'] = u.commandattachment.name;
            if (u.weaponattachments.isNotEmpty) {
              List<String> weaponattachments = [];
              for (var wa in u.weaponattachments) {
                weaponattachments.add(wa.name);
              }
              unit['weaponattachments'] = weaponattachments;
            }

            if (u.hasMarshal && u.cohort.isNotEmpty) {
              List<Map<String, dynamic>> cohort = [];
              for (var c in u.cohort) {
                cohort.add({'product': c.product.name});
                if (c.selectedOptions!.isNotEmpty) {
                  List<String> options = [];
                  for (var m in c.selectedOptions!) {
                    options.add(m.name);
                  }
                  cohort.last['modularoptions'] = options;
                }
              }
              unit['cohort'] = cohort;
            }
            us.add(unit);
          }
          group['oofunits'] = us;
        }
        leadergroups.add(group);
      }
      data['leadergroups'] = leadergroups;
    }
    if (jrcasters.isNotEmpty) {
      List<Map<String, dynamic>> jrs = [];
      for (var j in jrcasters) {
        Map<String, dynamic> group = {};
        group['leader'] = j.leader.name;
        List<Map<String, dynamic>> cohort = [];
        if (j.cohort.isNotEmpty) {
          for (var c in j.cohort) {
            cohort.add({'product': c.product.name});
            if (c.selectedOptions!.isNotEmpty) {
              List<String> options = [];
              for (var m in c.selectedOptions!) {
                options.add(m.name);
              }
              cohort.last['modularoptions'] = options;
            }
          }
          group['cohort'] = cohort;
        }
        jrs.add(group);
      }
      data['jrcasters'] = jrs;
    }
    if (units.isNotEmpty) {
      List<Map<String, dynamic>> us = [];
      for (var u in units) {
        Map<String, dynamic> unit = {};
        unit['unit'] = u.unit.name;
        unit['minsize'] = u.minsize;
        if (u.commandattachment.name != '') unit['commandattachment'] = u.commandattachment.name;
        if (u.weaponattachments.isNotEmpty) {
          List<String> weaponattachments = [];
          for (var wa in u.weaponattachments) {
            weaponattachments.add(wa.name);
          }
          unit['weaponattachments'] = weaponattachments;
        }

        if (u.hasMarshal && u.cohort.isNotEmpty) {
          List<Map<String, dynamic>> cohort = [];
          for (var c in u.cohort) {
            cohort.add({'product': c.product.name});
            if (c.selectedOptions!.isNotEmpty) {
              List<String> options = [];
              for (var m in c.selectedOptions!) {
                options.add(m.name);
              }
              cohort.last['modularoptions'] = options;
            }
          }
          unit['cohort'] = cohort;
        }
        us.add(unit);
      }
      data['units'] = us;
    }
    if (solos.isNotEmpty) {
      List<String> ss = [];
      for (var s in solos) {
        ss.add(s.name);
      }
      data['solos'] = ss;
    }
    if (battleengines.isNotEmpty) {
      List<String> bs = [];
      for (var be in battleengines) {
        bs.add(be.name);
      }
      data['battleengines'] = bs;
    }
    if (structures.isNotEmpty) {
      List<String> sts = [];
      for (var st in structures) {
        sts.add(st.name);
      }
      data['structures'] = sts;
    }
    return data;
  }
}

class LeaderGroup {
  Product leader;
  Product leaderattachment;
  List<Cohort> cohort;
  List<Spell>? spellrack;
  int? spellracklimit;
  bool heartofdarkness;
  bool flamesinthedarkness;
  String? heartofdarknessfaction;
  List<Cohort> oofcohort;
  List<JrCasterGroup> oofjrcasters;
  List<Unit> oofunits;
  List<Product> oofsolos;

  LeaderGroup({
    required this.leader,
    required this.leaderattachment,
    required this.cohort,
    this.spellrack,
    this.spellracklimit,
    required this.heartofdarkness,
    required this.flamesinthedarkness,
    this.heartofdarknessfaction,
    required this.oofcohort,
    required this.oofjrcasters,
    required this.oofunits,
    required this.oofsolos,
  });

  factory LeaderGroup.fromJson(Map<String, dynamic> json) {
    Product leader = Product.fromJson(json['leader']);
    Product attachment = ArmyListNotifier().blankproduct;

    List<Cohort> cohort = [];
    List<Cohort> oofcohort = [];
    List<Spell> spellrack = [];
    bool hod = false;
    bool fitd = false;

    for (var m in leader.models) {
      if (m.characterabilities!.isNotEmpty) {
        for (var ab in m.characterabilities!) {
          if (ab.name.toLowerCase().contains('heart of darkness')) hod = true;
          if (ab.name.toLowerCase().contains('flames in the darkness')) fitd = true;
        }
      }
    }

    if (json.containsKey('attachment')) {
      attachment = Product.fromJson(json['attachment']);
    }

    if (json.containsKey('cohort')) {
      for (var c in json['cohort']) {
        cohort.add(Cohort.fromJson(c));
      }
    }

    if (json.containsKey('oofcohort')) {
      for (var c in json['oofcohort']) {
        oofcohort.add(Cohort.fromJson(c));
      }
    }

    int spellracklimit = 0;
    if (json.containsKey('spellracklimit')) {
      for (var m in leader.models) {
        for (var ab in m.characterabilities!) {
          if (ab.name.toLowerCase().contains('spell rack')) {
            if (int.tryParse(ab.name[ab.name.indexOf('[') + 1]) != null) {
              spellracklimit = int.parse(ab.name[ab.name.indexOf('[') + 1]);
              break;
            }
          }
        }
      }
    }

    if (json.containsKey('spellrack')) {
      for (var sp in json['spellrack']) {
        spellrack.add(Spell.fromJson(sp));
      }
    }

    List<JrCasterGroup> oofjrs = [];
    if (json.containsKey('oofjrcasters')) {
      for (var jr in json['oofjrcasters']) {
        oofjrs.add(JrCasterGroup.fromJson(jr));
      }
    }

    List<Product> oofsolos = [];
    if (json.containsKey('oofsolos')) {
      for (var s in json['oofsolos']) {
        oofsolos.add(Product.fromJson(s));
      }
    }

    List<Unit> oofunits = [];
    if (json.containsKey('oofunits')) {
      for (var u in json['oofunits']) {
        oofunits.add(Unit.fromJson(u));
      }
    }

    return LeaderGroup(
      leader: leader,
      leaderattachment: attachment,
      cohort: cohort,
      spellrack: spellrack,
      spellracklimit: spellracklimit,
      heartofdarkness: hod,
      flamesinthedarkness: fitd,
      heartofdarknessfaction: '',
      oofcohort: oofcohort,
      oofjrcasters: oofjrs,
      oofsolos: oofsolos,
      oofunits: oofunits,
    );
  }

  bool isBlank(String text) {
    bool ret = false;
    if (text == '-' || text == '') {
      ret = true;
    }
    return ret;
  }
}

class JrCasterGroup {
  Product leader;
  List<Cohort> cohort;

  JrCasterGroup({
    required this.leader,
    required this.cohort,
  });

  factory JrCasterGroup.fromJson(Map<String, dynamic> json) {
    List<Cohort> cohort = [];

    if (json.containsKey('cohort')) {
      for (var c in json['cohort']) {
        cohort.add(Cohort.fromJson(c));
      }
    }

    return JrCasterGroup(
      leader: Product.fromJson(json['leader']),
      cohort: cohort,
    );
  }
}
