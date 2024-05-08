import 'dart:convert';

import 'package:armybuilder/models/modularoptions.dart';
import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/armylist.dart';
import 'appdata.dart';

class FactionNotifier extends ChangeNotifier {
  late List<List<Product>> _factionProducts;
  late List<List<List<Product>>> _sortedProducts;
  late List<List<Product>> _filteredProducts;
  late List<Option> _modularOptions;
  late List<List<Map<String, List<Product>>>> _unitAttachments;
  late int _selectedCategory;
  late bool _showingoptions;
  late String _groupname;
  late List<ModularOption> _modeloptions;
  late List<bool> _factionHasCasterAttachments;

  List<List<Product>> get factionProducts => _factionProducts;
  List<List<Product>> get filteredProducts => _filteredProducts;
  int get selectedCategory => _selectedCategory;
  String get groupname => _groupname;
  List<Option> get modularOptions => _modularOptions;
  bool get showingoptions => _showingoptions;
  List<ModularOption> get modeloptions => _modeloptions;
  List<bool> get factionHasCasterAttachments => _factionHasCasterAttachments;

  FactionNotifier() {
    _showingoptions = false;
    _factionProducts = [[], [], []]; //1 list of faction models, 1 list of allys, 1 of mercs
    _selectedCategory = 0;
    _unitAttachments = [
      [{}, {}],
      [{}, {}],
      [{}, {}]
    ];
    _sortedProducts = [
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
    ];
    _filteredProducts = [[], [], []]; //selected model type, 1 list of faction models, 1 list of allys, 1 of mercs
    _modularOptions = [];
    _groupname = '';
    _modeloptions = [];
    _factionHasCasterAttachments = [false, false, false];
  }

  readFactionProducts(String filename) async {
    String data = await rootBundle.loadString('json/${filename.toLowerCase()}');
    var decodeddata = jsonDecode(data);
    // print('loading $faction');
    _factionProducts = [[], [], []];
    _factionHasCasterAttachments = [false, false, false];
    List<String> groups = [
      'primary',
      'allies',
      'mercenaries',
    ];

    for (var g = 0; g < groups.length; g++) {
      for (var p in decodeddata['group'][g][groups[g]]['products']) {
        _factionProducts[g].add(Product.fromJson(p));
      }
    }
  }

  resetLists() {
    _filteredProducts.clear();
    _unitAttachments.clear();
    _sortedProducts.clear();
    _filteredProducts = [[], [], []];
    _factionHasCasterAttachments = [false, false, false];
    _unitAttachments = [
      [{}, {}],
      [{}, {}],
      [{}, {}]
    ];
    _sortedProducts = [
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
    ];
  }

  sortFactionProducts() async {
    List<List<Map<String, List<Product>>>> ua = [
      [{}, {}],
      [{}, {}],
      [{}, {}]
    ];
    List<List<List<Product>>> products = [
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
      [[], [], [], [], [], [], []],
    ];
    resetLists();
    int index = 0;
    for (var g = 0; g < 3; g++) {
      for (var p in _factionProducts[g]) {
        String attachname = '';
        index = AppData().productCategories.indexWhere((element) => element == p.category);
        if (index == -1) {
          for (var ab in p.models[0].characterabilities!) {
            if (ab.name == "Attached") {
              index = 6;
              _factionHasCasterAttachments[g] = true;
              break;
            }
            if (ab.name.toLowerCase().contains('command attachment')) {
              index = 7;
              attachname = ab.name.substring(ab.name.indexOf('['));
              attachname = attachname.replaceAll('[', '').replaceAll(']', '');
              break;
            }
            if (ab.name.toLowerCase().contains('weapon attachment')) {
              index = 8;
              attachname = ab.name.substring(ab.name.indexOf('['));
              attachname = attachname.replaceAll('[', '').replaceAll(']', '');
              break;
            }
          }

          //break;
        }
        if (index == -1) {
          print('error: ${p.name}');
        } else {
          if (index <= 6) {
            products[g][index].add(p);
          } else {
            List<String> names = attachname.split(',');
            for (var n in names) {
              String name = n.trim();
              if (!ua[g][index - 7].containsKey(name)) {
                ua[g][index - 7][name] = [p];
              } else {
                ua[g][index - 7][name]!.add(p);
              }
            }
          }
        }
      }
    }
    _sortedProducts = products;
    _unitAttachments = ua;
  }

  setSelectedCategory(int index, String? unitname) {
    _selectedCategory = index;
    _filteredProducts.clear();
    _filteredProducts = [[], [], []];
    if (index <= 6) {
      _filteredProducts[0] = _sortedProducts[0][index];
      _filteredProducts[1] = _sortedProducts[1][index];
      _filteredProducts[2] = _sortedProducts[2][index];
    } else if (unitname != null) {
      _filteredProducts[0] = _unitAttachments[0][index - 7][unitname]!;
      _filteredProducts[1] = _unitAttachments[1][index - 7][unitname]!;
      _filteredProducts[2] = _unitAttachments[2][index - 7][unitname]!;
    }
    _showingoptions = false;
    notifyListeners();
  }

  setShowModularGroupOptions(Product product) {
    // _groupname = product.models[0].modularoptions![groupindex].groupname;
    // _modularOptions.clear();
    // _modularOptions.addAll(product.models[0].modularoptions![groupindex].options!);
    _showingoptions = true;
    _modeloptions.clear();
    _modeloptions.addAll(product.models[0].modularoptions!);
    notifyListeners();
  }

  setShowingOptions(bool value) {
    _showingoptions = value;
    notifyListeners();
  }

  int casterHasSpellRack(Product product) {
    for (var m in product.models) {
      if (m.characterabilities != null) {
        for (var ab in m.characterabilities!) {
          if (ab.name.toLowerCase().contains('spell rack')) {
            int start = ab.name.indexOf('[') + 1;
            if (int.tryParse(ab.name[start]) != null) {
              return int.parse(ab.name[start]);
            }
            break;
          }
        }
      }
    }
    return -1;
  }

  bool unitHasCommandAttachments(String unitname) {
    for (int g = 0; g < 3; g++) {
      if (_unitAttachments[g][0].containsKey(unitname)) return true;
    }
    return false;
  }

  bool unitHasWeaponAttachments(String unitname) {
    for (int g = 0; g < 3; g++) {
      if (_unitAttachments[g][1].containsKey(unitname)) return true;
    }
    return false;
  }

  bool checkSoloForJourneyman(Product product) {
    for (var m in product.models) {
      if (m.characterabilities != null) {
        for (var ab in m.characterabilities!) {
          if (ab.name.toLowerCase().contains('journeyman warcaster') || ab.name.toLowerCase().contains('journeyman warlock')) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool checkUnitForMashal(Unit unit) {
    for (var m in unit.unit.models) {
      if (m.keywords != null) {
        if (m.keywords.toString().toLowerCase().contains('jack marshal')) return true;
      }
    }
    if (unit.commandattachment.name != '') {
      for (var m in unit.commandattachment.models) {
        if (m.keywords != null) {
          if (m.keywords.toString().toLowerCase().contains('jack marshal')) return true;
        }
      }
      if (unit.weaponattachments.isNotEmpty) {
        for (var wa in unit.weaponattachments) {
          for (var m in wa.models) {
            if (m.keywords != null) {
              if (m.keywords.toString().toLowerCase().contains('jack marshal')) return true;
            }
          }
        }
      }
    }
    return false;
  }

  bool checkProductForMashal(Product product) {
    for (var m in product.models) {
      if (m.keywords != null) {
        if (m.keywords.toString().toLowerCase().contains('jack marshal')) return true;
      }
    }
    return false;
  }

  Product findByName(String name) {
    Product blankproduct = ArmyListNotifier().blankproduct;
    Product foundproduct = blankproduct;
    for (int g = 0; g < 3; g++) {
      foundproduct = _factionProducts[g].firstWhere((element) => element.name == name, orElse: () => blankproduct);
      if (foundproduct.name != '') {
        break;
      }
    }
    return foundproduct;
  }

  Future<ArmyList> convertJsonStringToArmyList(String productlist) async {
    Map<String, dynamic> list = jsonDecode(productlist);
    int factionindex = AppData().factionList.indexWhere((element) => element['name'] == list['faction']);
    String filename = AppData().factionList[factionindex]['file']!;
    await readFactionProducts(filename);
    await sortFactionProducts();
    ArmyList army = ArmyList(
      name: list['name'],
      listfaction: list['faction'],
      totalpoints: list['totalpoints'],
      pointtarget: list['pointtarget'],
      leadergroup: [],
      units: [],
      solos: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
    );
    if (list.containsKey('leadergroups')) {
      for (Map<String, dynamic> lg in list['leadergroups']) {
        LeaderGroup group =
            LeaderGroup(leader: ArmyListNotifier().blankproduct, leaderattachment: ArmyListNotifier().blankproduct, cohort: [], spellrack: []);
        group.leader = Product.copyProduct(findByName(lg['leader']));
        if (lg.containsKey('leaderattachment')) {
          group.leaderattachment = Product.copyProduct(findByName(lg['leaderattachment']));
        }
        if (lg.containsKey('cohort')) {
          group.cohort.addAll(getCohortModelsFromJson(lg['cohort']));
        }

        army.leadergroup.add(group);
      }
    }
    if (list.containsKey('jrcasters')) {
      for (Map<String, dynamic> jr in list['jrcasters']) {
        JrCasterGroup group = JrCasterGroup(leader: ArmyListNotifier().blankproduct, cohort: []);
        group.leader = Product.copyProduct(findByName(jr['leader']));
        if (jr.containsKey('cohort')) {
          group.cohort.addAll(getCohortModelsFromJson(jr['cohort']));
        }
        army.jrcasters.add(group);
      }
    }
    if (list.containsKey('units')) {
      for (Map<String, dynamic> u in list['units']) {
        Unit group = Unit(
          unit: Product.copyProduct(findByName(u['unit'])),
          minsize: u['minsize'],
          hasMarshal: false,
          commandattachment:
              u.containsKey('commandattachment') ? Product.copyProduct(findByName(u['commandattachment'])) : ArmyListNotifier().blankproduct,
          weaponattachments: [],
          cohort: [],
        );
        if (u.containsKey('weaponattachments')) {
          for (var wa in u['weaponattachments']) {
            group.weaponattachments.add(Product.copyProduct(findByName(wa)));
          }
        }
        group.hasMarshal = checkUnitForMashal(group);
        if (group.hasMarshal && u.containsKey('cohort')) {
          // for (Map<String, dynamic> c in u['cohort']) {
          group.cohort.addAll(getCohortModelsFromJson(u['cohort']));
          // if (c.containsKey('options')) {
          //   group.cohort.add(Cohort(product: Product.copyProduct(findByName(c['product'])), selectedOptions: c['options']));
          // } else {
          //   group.cohort.add(Cohort(product: Product.copyProduct(findByName(c['product'])), selectedOptions: []));
          // }
          // }
        }
        army.units.add(group);
      }
    }
    if (list.containsKey('solos')) {
      for (String s in list['solos']) {
        Product product = Product.copyProduct(findByName(s));
        army.solos.add(product);
      }
    }
    if (list.containsKey('battleengines')) {
      for (String s in list['battleengines']) {
        army.battleengines.add(Product.copyProduct(findByName(s)));
      }
    }
    if (list.containsKey('structures')) {
      for (String s in list['structures']) {
        army.structures.add(Product.copyProduct(findByName(s)));
      }
    }
    return army;
  }

  List<Cohort> getCohortModelsFromJson(List<dynamic> json) {
    List<Cohort> cohorts = [];
    for (Map<String, dynamic> c in json) {
      Cohort cohort = Cohort(product: Product.copyProduct(findByName(c['product'])), selectedOptions: []);
      if (c.containsKey('modularoptions')) {
        for (var op in c['modularoptions']) {
          bool added = false;
          for (var group in cohort.product.models[0].modularoptions!) {
            for (var options in group.options!) {
              if (options.name == op) {
                if (cohort.selectedOptions == null) cohort.selectedOptions == [];
                cohort.selectedOptions!.add(options);
                added = true;
                break;
              }
            }
            if (added) break;
          }
        }
      }
      cohorts.add(cohort);
    }

    return cohorts;
  }

  Future<bool> validateProductNames(String filename, List<String> products) async {
    Product blankproduct = ArmyListNotifier().blankproduct;
    Product foundproduct = blankproduct;
    await readFactionProducts(filename);
    // return true;
    for (var p in products) {
      if (p.contains(' - ')) {
        p = p.substring(0, p.indexOf(' - ')).trim();
      }
      if (!p.contains('+ ')) {
        //skip modular parts
        for (int g = 0; g < 3; g++) {
          foundproduct = factionProducts[g].firstWhere((element) => element.name == p, orElse: () => blankproduct);
          if (foundproduct.name != '') return true;
        }
        if (foundproduct.name == '') return false;
      }
    }
    return false;
  }

  Future<ArmyList> convertProductNameListToArmyList(ArmyList list, List<String> products) async {
    int factionindex = AppData().factionList.indexWhere((element) => element['name'] == list.listfaction);
    String filename = AppData().factionList[factionindex]['file']!;
    await readFactionProducts(filename);

    Product blankproduct = ArmyListNotifier().blankproduct;
    int leadergroup = -1;
    int jrgroup = -1;
    int unitgroup = -1;
    String lastleader = '';
    for (var p in products) {
      if (p.contains('+ ')) {
        String optionname = p.replaceFirst('+', '').trim();
        switch (lastleader) {
          case 'warcaster':
            if (list.leadergroup[leadergroup].cohort.last.selectedOptions == null) list.leadergroup[leadergroup].cohort.last.selectedOptions = [];
            Cohort thiscohort = list.leadergroup[leadergroup].cohort.last;
            for (var g in thiscohort.product.models[0].modularoptions!) {
              bool found = false;
              for (var op in g.options!) {
                if (op.name == optionname) {
                  list.leadergroup[leadergroup].cohort.last.selectedOptions!.add(op);
                  found = true;
                  break;
                }
              }
              if (found) break;
            }
            break;
          case 'jrcaster':
            if (list.jrcasters[jrgroup].cohort.last.selectedOptions == null) list.jrcasters[jrgroup].cohort.last.selectedOptions = [];
            Cohort thiscohort = list.jrcasters[jrgroup].cohort.last;
            for (var g in thiscohort.product.models[0].modularoptions!) {
              bool found = false;
              for (var op in g.options!) {
                if (op.name == optionname) {
                  list.jrcasters[jrgroup].cohort.last.selectedOptions!.add(op);
                  found = true;
                  break;
                }
              }
              if (found) break;
            }
            break;
          case 'unit':
            if (list.units[unitgroup].cohort.last.selectedOptions == null) list.units[unitgroup].cohort.last.selectedOptions = [];
            Cohort thiscohort = list.units[unitgroup].cohort.last;
            for (var g in thiscohort.product.models[0].modularoptions!) {
              bool found = false;
              for (var op in g.options!) {
                if (op.name == optionname) {
                  list.units[unitgroup].cohort.last.selectedOptions!.add(op);
                  found = true;
                  break;
                }
              }
              if (found) break;
            }
            break;
          default:
            break;
        }
      } else {
        String unitsize = '';
        if (p.contains(' - ')) {
          //unit
          unitsize = p.substring(p.indexOf(' - ') + 2).trim();
          p = p.substring(0, p.indexOf(' - ')).trim();
        }
        Product thisproduct = findByName(p); //factionProducts.firstWhere((element) => element.name == p, orElse: () => blankproduct);
        if (thisproduct.name != '') {
          switch (thisproduct.category) {
            case 'Warcasters/Warlocks/Masters':
              list.leadergroup.add(LeaderGroup(leader: thisproduct, leaderattachment: blankproduct, cohort: [], spellrack: []));
              leadergroup += 1;
              lastleader = 'warcaster';
              break;
            case 'Warjacks/Warbeasts/Horrors':
              if (lastleader == 'warcaster') {
                list.leadergroup[leadergroup].cohort.add(Cohort(product: thisproduct, selectedOptions: []));
              }
              if (lastleader == 'jrcaster') {
                list.jrcasters[jrgroup].cohort.add(Cohort(product: thisproduct, selectedOptions: []));
              }
              if (lastleader == 'unit') {
                list.units[unitgroup].cohort.add(Cohort(product: thisproduct, selectedOptions: []));
              }
              break;
            case 'Solos':
              if (checkSoloForJourneyman(thisproduct) || checkProductForMashal(thisproduct)) {
                list.jrcasters.add(JrCasterGroup(leader: thisproduct, cohort: []));
                jrgroup += 1;
                lastleader = 'jrcaster';
              } else {
                list.solos.add(thisproduct);
              }
              break;
            case 'Units':
              bool min = true;
              if (thisproduct.unitPoints!['maxunit'] == unitsize) min = false;
              list.units.add(Unit(
                unit: thisproduct,
                minsize: min,
                hasMarshal: false,
                commandattachment: blankproduct,
                weaponattachments: [],
                cohort: [],
              ));
              unitgroup += 1;
              list.units.last.hasMarshal = checkUnitForMashal(list.units.last);
              if (list.units.last.hasMarshal) {
                lastleader = 'unit';
              }
              break;
            case 'Attachments':
              for (var ab in thisproduct.models[0].characterabilities!) {
                if (ab.name == "Attached") {
                  list.leadergroup[leadergroup].leaderattachment = thisproduct;
                  break;
                }
                if (ab.name.toLowerCase().contains('command') && ab.name.toLowerCase().contains('attachment')) {
                  list.units[unitgroup].commandattachment = thisproduct;
                  break;
                }
                if (ab.name.toLowerCase().contains('weapon') && ab.name.toLowerCase().contains('attachment')) {
                  list.units[unitgroup].weaponattachments.add(thisproduct);
                  break;
                }
              }
              break;
            case 'Battle Engines':
              list.battleengines.add(thisproduct);
              break;
            case 'Structures':
              list.structures.add(thisproduct);
              break;
          }
        }
      }
    }
    return list;
  }

  Future<bool> validateListFromFile(Map<String, dynamic> army) async {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9+]');
    final numeric = RegExp(r'^[0-9]');
    if (army.containsKey('name')) {
      if (!alphanumeric.hasMatch(army['name'])) return false;
    } else {
      return false;
    }
    if (army.containsKey('faction')) {
      if (AppData().factionList.where((element) => element['name'] == army['faction']).isEmpty) return false;
    } else {
      return false;
    }
    if (army.containsKey('pointtarget')) {
      if (!numeric.hasMatch(army['pointtarget'])) return false;
    } else {
      return false;
    }
    if (army.containsKey('totalpoints')) {
      if (!numeric.hasMatch(army['totalpoints'])) return false;
    } else {
      return false;
    }
    int factionindex = AppData().factionList.indexWhere((element) => element['name'] == army['faction']);
    String filename = AppData().factionList[factionindex]['file']!;
    await readFactionProducts(filename);
    if (army.containsKey('leadergroups')) {
      for (Map<String, dynamic> lg in army['leadergroups']) {
        if (!validatename(lg['leader'])) return false;

        if (lg.containsKey('leaderattachment')) {
          if (!validatename(lg['leaderattachment'])) return false;
        }

        if (lg.containsKey('cohort')) {
          for (var c in lg['cohort']) {
            if (!validatename(c['product'])) return false;
          }
        }
      }
    }
    if (army.containsKey('jrcasters')) {
      for (Map<String, dynamic> jr in army['jrcasters']) {
        if (!validatename(jr['leader'])) return false;
        if (jr.containsKey('cohort')) {
          for (var c in jr['cohort']) {
            if (!validatename(c['product'])) return false;
          }
        }
      }
    }
    if (army.containsKey('units')) {
      for (Map<String, dynamic> u in army['units']) {
        if (!validatename(u['unit'])) return false;
        if (u.containsKey('commandattachment')) {
          if (!validatename(u['commandattachment'])) return false;
        }
        if (u.containsKey('weaponattachments')) {
          for (var wa in u['weaponattachments']) {
            if (!validatename(wa)) return false;
          }
        }
        if (u.containsKey('cohort')) {
          for (var c in u['cohort']) {
            if (!validatename(c['product'])) return false;
          }
        }
      }
    }
    if (army.containsKey('solos')) {
      for (var s in army['solos']) {
        if (!validatename(s)) return false;
      }
    }
    if (army.containsKey('battleengines')) {
      for (var be in army['battleengines']) {
        if (be) return false;
      }
    }
    if (army.containsKey('structures')) {
      for (var st in army['structures']) {
        if (!validatename(st)) return false;
      }
    }
    return true;
  }

  bool validatename(String name) {
    List<dynamic> found = [];
    for (int g = 0; g < 3; g++) {
      found.addAll(factionProducts[g].where((element) => element.name == name));
    }
    return found.isNotEmpty;
  }
}
