// ignore_for_file: unused_local_variable

import 'package:armybuilder/models/activearmylist.dart';
import 'package:armybuilder/models/armylist.dart';
import 'package:armybuilder/models/model.dart';
import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/models/spiral.dart';
import 'package:armybuilder/models/stat_mods.dart';
import 'package:armybuilder/models/web.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';

import '../models/cohort.dart';
import '../models/modularoptions.dart';
import '../models/spells.dart';
import '../models/unit.dart';
import '../appdata.dart';

class ArmyListNotifier extends ChangeNotifier {
  late ScrollController _listController;
  late TextEditingController _listnameController;
  late List<Product> _categoryProductsList;
  late int _addToIndex;
  late ArmyList _armyList;
  late bool _deploying;
  late List<DeployedArmyList> _deployedLists;
  late String _factionSelected;
  late Map<String, dynamic> _encounterLevelSelected;
  late String _encounterlevel;
  late int _currentpoints;
  late int _cohortpoints;
  late int _selectedcaster;
  late String _selectedcastertype;
  late Product _selectedcasterProduct;
  late List<int> _selectedcasterFactionIndexes;
  late int _castercount;
  late Product _selectedProduct;
  late Cohort _selectedCohort;
  late List<bool> _viewingcohort;
  late String _status; //list building status - 'new' for new list, 'edit' for editing an existing list
  late int _armylistindex;
  late String _armylistFactionFilter;
  late int _cohortleaderindex;
  late int _cohortindex;
  // late int _groupindex;
  late String _leadertype;

  List<List<dynamic>> _hptracking = [];
  List<List<dynamic>> _custombartracking = [];
  List<int> _castergroupindex = []; //used to track if caster's are added from primary, allies or mercs to list

  Option blankOption = Option(
    cost: '0',
    name: '',
    abilities: [],
    animi: [],
    keywords: [],
    nestedabilities: [],
    weapons: [],
    statmods: StatMods(
      aat: '0',
      arc: '0',
      arm: '0',
      cmd: '0',
      ctrl: '0',
      def: '0',
      ess: '0',
      fury: '0',
      mat: '0',
      rat: '0',
      spd: '0',
      str: '0',
      thr: '0',
    ),
  );

  Product blankproduct = Product(
    primaryFaction: [],
    factions: [],
    name: '',
    category: '',
    fa: '',
    points: '0',
    models: [],
    fanum: 0,
  );

  Spell blankspell = Spell(
    cost: '',
    description: '',
    name: '',
    off: '',
    rng: '',
  );

  ScrollController get listController => _listController;
  TextEditingController get listnameController => _listnameController;
  List<Product> get categoryProductsList => _categoryProductsList;
  int get addToIndex => _addToIndex;
  String get factionSelected => _factionSelected;
  Map<String, dynamic> get encounterLevelSelected => _encounterLevelSelected;
  ArmyList get armyList => _armyList;
  bool get deploying => _deploying;
  List<DeployedArmyList> get deployedLists => _deployedLists;
  int get currentpoints => _currentpoints;
  int get cohortpoints => _cohortpoints;
  String get encounterlevel => _encounterlevel;
  int get selectedcaster => _selectedcaster;
  String get selectedcastertype => _selectedcastertype;
  Product get selectedcasterProduct => _selectedcasterProduct;
  List<int> get selectedcasterFactionIndexes => _selectedcasterFactionIndexes;
  Product get selectedProduct => _selectedProduct;
  Cohort get selectedCohort => _selectedCohort;
  List<bool> get viewingcohort => _viewingcohort;
  String get status => _status;
  int get armylistindex => _armylistindex;
  String get armylistFactionFilter => _armylistFactionFilter;
  // int get cohortcasterindex => _cohortcasterindex;
  // int get cohortindex => _cohortindex;
  // int get groupindex => _groupindex;

  List<List<dynamic>> get hptracking => _hptracking;
  List<List<dynamic>> get custombartracking => _custombartracking;
  List<int> get castergroupindex => _castergroupindex;

  ArmyListNotifier() {
    _categoryProductsList = [];
    _factionSelected = '';
    _encounterLevelSelected = AppData().encounterlevels[0];
    _addToIndex = 0;
    _encounterlevel = '0';
    _currentpoints = 0;
    _cohortpoints = 0;
    _selectedcaster = 0;
    _selectedcastertype = 'warcaster';
    _castercount = -1;
    _selectedProduct = blankproduct;
    _selectedCohort = Cohort(product: blankproduct, selectedOptions: []);
    _selectedcasterFactionIndexes = [];
    _viewingcohort = [false, false];
    _selectedcasterProduct = blankproduct;
    _status = '';
    _armyList = ArmyList(
      name: '',
      listfaction: '',
      pointtarget: '',
      totalpoints: '',
      favorite: false,
      leadergroup: [LeaderGroup(leader: blankproduct, leaderattachment: blankproduct, cohort: [], spellrack: [])],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
    );
    _deploying = false;
    _deployedLists = [];
    _armylistindex = 0;
    _armylistFactionFilter = 'All';
    _hptracking = [];
    _custombartracking = [];
    _cohortindex = 0;
    // _groupindex = 0;
    _leadertype = 'warcaster';
    _castergroupindex = [0];
  }

  notify() {
    notifyListeners();
  }

  setStatus(String value) {
    _status = value;
  }

  setlistnameController(TextEditingController con) {
    _listnameController = con;
  }

  setlistname() {
    _armyList.name = _listnameController.text;
  }

  setFactionSelected(String faction) {
    _factionSelected = faction;
    _armyList.listfaction = faction;

    notifyListeners();
  }

  setAddtoIndex(int index) {
    _addToIndex = index;
  }

  setDeploying(bool value) {
    _deploying = value;
  }

  setSelectedProduct(Product product) {
    _selectedProduct = product;
    _viewingcohort[0] = false;
    notifyListeners();
  }

  setSelectedCohortWithOptions(Cohort cohort) {
    _selectedCohort = cohort;
    _viewingcohort[0] = true;
    notifyListeners();
  }

  setDeployedListSelectedProduct(int listindex, Product product, int modelindex, int listmodelindex, int barcount) {
    _deployedLists[listindex].selectedProduct = product;
    _deployedLists[listindex].selectedCohort = Cohort(product: blankproduct, selectedOptions: []);
    _deployedLists[listindex].selectedModelIndex = modelindex;
    _deployedLists[listindex].selectedListModelIndex = listmodelindex;
    _deployedLists[listindex].barcount = barcount;
    _viewingcohort[listindex] = false;
    notifyListeners();
  }

  setDeployedListSelectedCohort(int listindex, Cohort cohort, int modelindex, int listmodelindex, int barcount) {
    _deployedLists[listindex].selectedProduct = blankproduct;
    _deployedLists[listindex].selectedCohort = cohort;
    _deployedLists[listindex].selectedModelIndex = modelindex;
    _deployedLists[listindex].selectedListModelIndex = listmodelindex;
    _deployedLists[listindex].barcount = barcount;
    _viewingcohort[listindex] = true;
    notifyListeners();
  }

  setDeployFactionFilter(String value) {
    _armylistFactionFilter = value;
    notifyListeners();
  }

  setEncounterLevel(Map<String, dynamic> level) {
    _encounterLevelSelected = level;
    _encounterlevel = level['level'];
    _armyList.pointtarget = level['armypoints'].toString();
    if (_armyList.leadergroup[0].leader.name != '') {
      updateSelectedCaster(0, 'warcaster');
    }
    if (_armyList.leadergroup.length > level['castercount']) {
      do {
        _armyList.leadergroup.removeLast();
        updateCasterCount(-1);
        _castergroupindex.removeLast();
      } while (_armyList.leadergroup.length > level['castercount']);
    } else if (_armyList.leadergroup.length < level['castercount']) {
      do {
        _armyList.leadergroup.add(LeaderGroup(leader: blankproduct, leaderattachment: blankproduct, cohort: [], spellrack: []));
        updateCasterCount(1);
        _castergroupindex.add(0);
      } while (_armyList.leadergroup.length < level['castercount']);
    }
    notifyListeners();
  }

  updateCasterCount(int value) {
    _castercount += value;
    if (_selectedcaster > _castercount) {
      _selectedcaster = _castercount;
    }
    notifyListeners();
  }

  bool updateSelectedCaster(int value, String type) {
    bool found = false;

    _selectedcaster = value;
    _selectedcastertype = type;
    switch (type) {
      case 'warcaster':
        if (value < armyList.leadergroup.length) {
          for (var a = 0; a < armyList.leadergroup.length; a++) {
            if (value == a) {
              _selectedcasterProduct = armyList.leadergroup[a].leader;
              setcasterfactionindex();
              found = true;
              break;
            }
          }
        }
        break;
      case 'jrcaster':
        for (var a = armyList.leadergroup.length; a < armyList.leadergroup.length + armyList.jrcasters.length; a++) {
          if (value == a) {
            _selectedcasterProduct = _armyList.jrcasters[a - armyList.leadergroup.length].leader;
            setcasterfactionindex();
            found = true;
            break;
          }
        }
        break;
      case 'unit':
        int totalcasters = armyList.leadergroup.length + armyList.jrcasters.length;
        int marshals = 0;
        for (var u = 0; u < armyList.units.length; u++) {
          if (FactionNotifier().checkUnitForMashal(armyList.units[u])) {
            if (value == totalcasters + marshals) {
              _selectedcasterProduct = _armyList.units[u].unit;
              setcasterfactionindex();
              found = true;
              break;
            }
            marshals++;
          }
        }
        break;

      default:
        break;
    }
    notifyListeners();
    return found;
  }

  setcasterfactionindex() {
    //sets faction indexes to show the appropriate cohort models that the caster can take
    int primaryfactionindex = 0;
    _selectedcasterFactionIndexes.clear();
    for (var f in _selectedcasterProduct.primaryFaction) {
      _selectedcasterFactionIndexes.add(AppData().factionList.indexWhere((element) => element['name'] == f));
    }
    for (var ab in _selectedcasterProduct.models[0].characterabilities!) {
      // Partisan - not mercenary, faction of selected faction
      // Mercenary
      // Strange Bedfellows - faction of caster
      // Attachment
      // Attached
      // Requisition - gains tagged faction
      // Military Atache - mercenary model for tagged faction
      // Split Loyalties - two primary factions, selected faction is valid
      // Animosity - can not be in army that includes tag
      // Faithful - is a Religion of the Twins model as well as primary faction ///should be primary faction
      // Garrison Troops - is Ord or Llael - //////should be primary
      // Flames in the Darkness - faction of the caster
      // Heart of Darkness - faction of the caster - /////should be primary
      // Special Issue - can be included in any list with character listed

      if (ab.name.toLowerCase().contains("split loyalties")) {
        _selectedcasterFactionIndexes.clear();
        _selectedcasterFactionIndexes.add(AppData().factionList.indexWhere((element) => element['name'] == _armyList.listfaction));
      }
      if (ab.name.toLowerCase().contains('partisan')) {
        if (_armyList.listfaction != "Mercenaries") {
          _selectedcasterFactionIndexes.clear();
          _selectedcasterFactionIndexes.add(AppData().factionList.indexWhere((element) => element['name'] == _armyList.listfaction));
        }
      }
      if (ab.name.toLowerCase().contains('heart of darkness')) {
        if (_armyList.listfaction == "Infernals") {
          _selectedcasterFactionIndexes.remove("Infernals");
        }
      }

      // case "strange bedfellows":
      //   //no changes
      //   break;
      // case "requisition":
      //   //should be primary faction
      //   break;
      // case "faitful":
      //   //should be primary faction
      //   break;
      // case "mercenary atache":
      //   //becomes mercenary for llael, cohort
      //   break;
      // case "garrison"
      //   break;
    }
    // if (_selectedcasterProduct.primaryFaction.length > 1) {
    //   primaryfactionindex = _selectedcasterProduct.primaryFaction.indexWhere((element) => element == _armyList.listfaction);
    //   _selectedcasterFactionIndex =
    //       AppData().factionList.indexWhere((element) => element == _selectedcasterProduct.primaryFaction[primaryfactionindex]);
    // }
    notifyListeners();
  }

  updateEverything() {
    recalulateFA();
    calculatePoints();
    notifyListeners();
  }

  // setCasterGroupIndex(int casterindex, int value) {
  //   _castergroupindex[casterindex] = value;
  // }

  addModelToList(Product product) {
    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        addLeaderandSelect(product);
        break;
      // case 'Warjacks/Warbeasts/Horrors':
      // if (_selectedcaster <= _armyList.leadergroup.length - 1) {
      //   addCohort(product);
      // } else {
      //   addJrCohort(product);
      // }
      // break;
      case 'Solos':
        if (FactionNotifier().checkSoloForJourneyman(product) || FactionNotifier().checkProductForMashal(product)) {
          addJrCaster(product);
        } else {
          addSolo(product);
        }
        break;
      case 'Battle Engines':
        addBattleEngine(product);
        break;
      case 'Structures':
        addStructure(product);
        break;
    }
    updateEverything();
  }

  removeModelFromList(Product product, int groupnum) {
    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        removeSelectedLeader(groupnum);
        break;
      case 'Warjacks/Warbeasts/Horrors':
      // if (groupnum <= _armyList.leadergroup.length - 1) {
      //   // removeCohort(product, groupnum);
      // } else {
      //   removeJrCohort(product, groupnum - _armyList.leadergroup.length);
      // }
      // break;
      case 'Solos':
        if (product.models[0].title.toLowerCase().contains('warcaster') || product.models[0].title.toLowerCase().contains('warlock')) {
          _castercount -= 1;
          removeJrCaster(groupnum);
        } else {
          removeSolo(product);
        }
        break;
      case 'Attachments':
        for (var ab in product.models[0].characterabilities!) {
          if (ab.name == "Attached") {
            removeLeaderAttachment(groupnum);
          }
        }
        break;
      case 'Battle Engines':
        removeBattleEnging(product);
        break;
      case 'Structures':
        removeStructure(product);
        break;
    }
    updateEverything();
  }

  calculatePoints() {
    _currentpoints = 0;
    for (var a = 0; a < _armyList.leadergroup.length; a++) {
      int bgp = 0;
      int leaderpoints = int.parse(_armyList.leadergroup[a].leader.points!);
      if (_armyList.leadergroup[a].leaderattachment.name != '') {
        _currentpoints += int.parse(_armyList.leadergroup[a].leaderattachment.points!);
      }
      for (var c in _armyList.leadergroup[a].cohort) {
        if (bgp < leaderpoints) {
          if (c.product.points != '*') {
            bgp += int.parse(c.product.points!);
          } else {
            for (var o in c.selectedOptions!) {
              bgp += int.parse(o.cost);
            }
          }

          if (bgp > leaderpoints) {
            _currentpoints = _currentpoints + (bgp - leaderpoints);
          }
        } else {
          if (c.product.points != '*') {
            _currentpoints += int.parse(c.product.points!);
          } else {
            for (var o in c.selectedOptions!) {
              _currentpoints += int.parse(o.cost);
            }
          }
        }
      }
    }

    for (var s in _armyList.solos) {
      _currentpoints += int.parse(s.points!);
    }
    for (var u in _armyList.units) {
      if (u.unit.points == '') {
        _currentpoints += int.parse(u.unit.unitPoints![u.minsize ? 'mincost' : 'maxcost']!);
        if (u.commandattachment.name != '') {
          _currentpoints += int.parse(u.commandattachment.points!);
        }
        if (u.weaponattachments.isNotEmpty) {
          for (var wa in u.weaponattachments) {
            _currentpoints += int.parse(wa.points!);
          }
        }
        if (u.hasMarshal) {
          for (var c in u.cohort) {
            if (c.product.points != '*') {
              _currentpoints += int.parse(c.product.points!);
            } else {
              for (var o in c.selectedOptions!) {
                _currentpoints += int.parse(o.cost);
              }
            }
          }
        }
      }
    }
    for (var be in _armyList.battleengines) {
      _currentpoints += int.parse(be.points!);
    }
    for (var st in _armyList.structures) {
      _currentpoints += int.parse(st.points!);
    }
    for (var jr in _armyList.jrcasters) {
      _currentpoints += int.parse(jr.leader.points!);
      for (var c in jr.cohort) {
        if (c.product.points != '*') {
          _currentpoints += int.parse(c.product.points!);
        } else {
          for (var o in c.selectedOptions!) {
            _currentpoints += int.parse(o.cost);
          }
        }
      }
    }
    _armyList.totalpoints = _currentpoints.toString();
    // notifyListeners();
  }

  int calculateBGP(int groupnum) {
    int bgp = 0;
    if (_armyList.leadergroup.length > groupnum) {
      for (var c in _armyList.leadergroup[groupnum].cohort) {
        if (c.product.points != '*') {
          bgp += int.parse(c.product.points!);
        } else {
          for (var o in c.selectedOptions!) {
            bgp += int.parse(o.cost);
          }
        }
      }
    } else {
      return 0;
    }
    if (bgp > int.parse(_armyList.leadergroup[groupnum].leader.points!)) {
      bgp = int.parse(_armyList.leadergroup[groupnum].leader.points!);
    }
    return bgp;
  }

  String faName(String name) {
    String faname = name;

    if (int.tryParse(faname.substring(faname.length - 1)) != null) {
      faname = name.substring(0, name.length - 2);
    }
    return faname;
  }

  bool atFALimit(ArmyList army, Product product) {
    List<String> FALimitNames = [];
    for (var m in product.models) {
      FALimitNames.add(faName(m.modelname));
    }
    int limit = 0;
    String modelname = '';
    switch (product.fa) {
      case 'C':
        limit = 1;
        break;
      case 'U':
        return false;
      default:
        limit = int.parse(product.fa);
    }
    //all lists are looped through in reverse to find the last item of the selected products to get the highest fanum value
    //fanum is equal to it's FA count when it's added, so the first one is 1, second is 2, etc...
    //looping through every model because of cases like Black 13th and Caine and Hellslingers
    for (String fa in FALimitNames) {
      //leaders (warcasters/warlocks/masters)
      for (LeaderGroup lg in army.leadergroup.reversed) {
        if (lg.leader.name == product.name) return lg.leader.fanum >= limit;

        if (lg.leader.name != '') {
          for (Model m in lg.leader.models) {
            modelname = faName(m.modelname);
            //the whole model name contains the Product model's name or the FA name contains the model's shortened name (Caine 3 contains Caine or Caine contains Caine)
            if (m.modelname.contains(fa) || fa.contains(modelname)) {
              return lg.leader.fanum >= limit;
            }
          }
        }

        if (lg.leaderattachment.name != '') {
          if (lg.leaderattachment.name == fa) {
            return lg.leaderattachment.fanum >= limit;
          }
          for (var m in lg.leaderattachment.models) {
            modelname = faName(m.modelname);
            //the whole model name contains the Product model's name or the FA name contains the model's shortened name (Caine 3 contains Caine or Caine contains Caine)
            if (m.modelname.contains(fa) || fa.contains(modelname)) {
              return lg.leaderattachment.fanum >= limit;
            }
          }
        }

        for (Cohort c in lg.cohort.reversed) {
          if (c.product.name == product.name) return c.product.fanum >= limit;

          for (Model cohort in c.product.models) {
            modelname = faName(cohort.modelname);
            if (cohort.modelname.contains(fa) || fa.contains(modelname)) {
              return c.product.fanum >= limit;
            }
          }
        }
      }

      //jr casters
      for (JrCasterGroup jr in army.jrcasters.reversed) {
        if (jr.leader.name == product.name) return jr.leader.fanum >= limit;

        for (Model m in jr.leader.models) {
          modelname = faName(m.modelname);
          if (m.modelname.contains(fa) || fa.contains(modelname)) {
            return jr.leader.fanum >= limit;
          }
          for (Cohort c in jr.cohort.reversed) {
            if (c.product.name == product.name) return c.product.fanum >= limit;

            for (Model m in c.product.models) {
              modelname = faName(m.modelname);
              if (m.modelname.contains(fa) || fa.contains(modelname)) {
                return c.product.fanum >= limit;
              }
            }
          }
        }
      }

      //solos
      for (var s in army.solos.reversed) {
        //solos should only be one model so no need to loop through all the models
        modelname = faName(s.models[0].modelname);
        if (s.name == product.name || s.models[0].modelname.contains(fa) || fa.contains(modelname)) {
          return s.fanum >= limit;
        }
      }

      //units
      for (var u in army.units.reversed) {
        if (u.unit.name == product.name) return u.unit.fanum >= limit;
        if (u.unit.fa == 'C') {
          //character unit with named models like Black 13th
          for (Model m in u.unit.models) {
            modelname = faName(m.modelname);
            if (m.modelname.contains(fa) || fa.contains(modelname)) {
              return u.unit.fanum >= limit;
            }
          }
        }

        if (u.commandattachment.name == product.name) return u.commandattachment.fanum >= limit;
        if (u.commandattachment.fa == 'C') {
          //character with named models
          for (Model m in u.commandattachment.models) {
            modelname = faName(m.modelname);
            if (m.modelname.contains(fa) || fa.contains(modelname)) {
              return u.commandattachment.fanum >= limit;
            }
          }
        }

        if (u.weaponattachments.isNotEmpty) {
          for (var wa in u.weaponattachments.reversed) {
            if (wa.name == fa) return wa.fanum >= limit;
            if (wa.fa == 'C') {
              //character with named models
              for (Model m in wa.models) {
                modelname = faName(m.modelname);
                if (m.modelname.contains(fa) || fa.contains(modelname)) {
                  return u.commandattachment.fanum >= limit;
                }
              }
            }
          }
        }
      }
      for (var be in army.battleengines.reversed) {
        if (be.name == fa) return be.fanum >= limit;
      }
      for (var st in army.structures.reversed) {
        if (st.name == fa) return st.fanum >= limit;
      }
    }
    return false;
  }

  int calculateFA(ArmyList army, Product product) {
    //if product is FA C, compare model to model with other FA C in the list
    //else only compare product names

    int count = 0;

    if (product.fa == 'C') {
      for (LeaderGroup lg in army.leadergroup) {
        //loop through each caster in the army list
        for (Model m in lg.leader.models) {
          //loop through each model of the caster to compare names
          bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
          for (Model productmodel in product.models) {
            //loop through the product names to calculate
            String searchName = faName(productmodel.modelname);
            if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
              count += 1;
              found = true;
              break; //stop searching the current product
            }
          }
          if (found) break; //go to next caster product
        }

        //loop through each model of the caster attachment if there is one if it is FA C
        if (lg.leaderattachment.name != '' && lg.leaderattachment.fa == 'C') {
          for (Model m in lg.leaderattachment.models) {
            bool found = false;
            for (Model productmodel in product.models) {
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break;
          }
        }

        //loop through each FA C cohort model
        for (Cohort c in lg.cohort) {
          if (c.product.fa == 'C') {
            for (var m in c.product.models) {
              bool found = false;
              for (Model productmodel in product.models) {
                String searchName = faName(productmodel.modelname);
                if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                  count += 1;
                  found = true;
                  break; //stop searching the current product
                }
              }
              if (found) break;
            }
          }
        }
      }

      //repeat for each jr caster
      for (JrCasterGroup jr in army.jrcasters) {
        //loop through each jr caster in the army list
        if (jr.leader.fa == 'C') {
          for (Model m in jr.leader.models) {
            //loop through each model of the jr caster to compare names
            bool found = false;
            for (Model productmodel in product.models) {
              //loop through the product names to calculate
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break;
          }
        }

        //loop through each FA C cohort model
        for (Cohort c in jr.cohort) {
          if (c.product.fa == 'C') {
            for (var m in c.product.models) {
              bool found = false;
              for (Model productmodel in product.models) {
                String searchName = faName(productmodel.modelname);
                if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                  count += 1;
                  found = true;
                  break; //stop searching the current product
                }
              }
              if (found) break;
            }
          }
        }
      }

      //loop through each FA C solo
      for (Product s in army.solos) {
        //loop through each solo in the army list
        if (s.fa == 'C') {
          for (Model m in s.models) {
            //loop through each model of the solo to compare names....there shouldn't be more than 1 model in a solo but testing anyway
            bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
            for (Model productmodel in product.models) {
              //loop through the product names to calculate
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break; //go to next caster product
          }
        }
      }

      //loop through each FA C unit
      for (Unit u in army.units) {
        //loop through each unit in the army list
        if (u.unit.fa == 'C') {
          Iterable<Model> searchresults = u.unit.models.where((element) => element.modelname.toLowerCase().contains('leader'));
          if (searchresults.isEmpty) {
            //no model with leader in the name so assume the unit contains a named model
            for (Model m in u.unit.models) {
              //loop through each model of the unit to compare names. for units most are Leader and Grunts such is the need for FA C.  Silverline Stormguard are an exception though
              bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
              for (Model productmodel in product.models) {
                //loop through the product names to calculate
                String searchName = faName(productmodel.modelname);
                if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                  count += 1;
                  found = true;
                  break; //stop searching the current product
                }
              }
              if (found) break; //go to next caster product
            }
          } else {
            //FA C unit with no named models, instead compare the product names
            if (u.unit.name == product.name) {
              count += 1;
            }
          }
        }

        if (u.commandattachment.fa == 'C') {
          for (Model m in u.commandattachment.models) {
            bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
            for (Model productmodel in product.models) {
              //loop through the product names to calculate
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break; //stop search models of the CA
          }
        }

        for (Product wa in u.weaponattachments) {
          if (wa.fa == 'C') {
            for (Model m in wa.models) {
              //loop through each model of the solo to compare names....there shouldn't be more than 1 model in a solo but testing anyway
              bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
              for (Model productmodel in product.models) {
                //loop through the product names to calculate
                String searchName = faName(productmodel.modelname);
                if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                  count += 1;
                  found = true;
                  break; //stop searching the current product
                }
              }
              if (found) break; //go to next caster product
            }
          }
        }

        //loop through unit cohort (jack marshals)
        for (Cohort c in u.cohort) {
          if (c.product.fa == 'C') {
            for (var m in c.product.models) {
              bool found = false;
              for (Model productmodel in product.models) {
                String searchName = faName(productmodel.modelname);
                if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                  count += 1;
                  found = true;
                  break; //stop searching the current product
                }
              }
              if (found) break;
            }
          }
        }
      }

      //loop through each FA C battle engine
      for (Product be in army.battleengines) {
        if (be.fa == 'C') {
          for (Model m in be.models) {
            bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
            for (Model productmodel in product.models) {
              //loop through the product names to calculate
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break; //go to next caster product
          }
        }
      }

      //loop through each FA C structure
      for (Product st in army.battleengines) {
        if (st.fa == 'C') {
          for (Model m in st.models) {
            bool found = false; //will be used to break from the current product for cases like Black 13 vs Hellslingers
            for (Model productmodel in product.models) {
              //loop through the product names to calculate
              String searchName = faName(productmodel.modelname);
              if (m.modelname.contains(searchName) || searchName.contains(faName(m.modelname))) {
                count += 1;
                found = true;
                break; //stop searching the current product
              }
            }
            if (found) break; //go to next caster product
          }
        }
      }
    } else {
      for (LeaderGroup lg in army.leadergroup) {
        //skip looping through casters, they are all FA C
        if (lg.leaderattachment.name == product.name) count += 1; //check leader attachment
        for (Cohort c in lg.cohort) {
          //loop through each no C cohort
          if (c.product.fa != 'C' && c.product.name == product.name) count += 1;
        }
      }

      for (JrCasterGroup jr in army.jrcasters) {
        if (jr.leader.name == product.name) count += 1;
        for (Cohort c in jr.cohort) {
          if (c.product.fa != 'C' && c.product.name == product.name) count += 1;
        }
      }

      for (Product s in army.solos) {
        if (s.fa != 'C' && s.name == product.name) count += 1;
      }

      for (Unit u in army.units) {
        if (u.unit.fa != 'C') {
          if (u.unit.name == product.name) count += 1;
        }
        if (u.commandattachment.fa != 'C' && u.commandattachment.name == product.name) count += 1;
        for (Product wa in u.weaponattachments) {
          if (wa.fa != 'C' && wa.name == product.name) count += 1;
        }
        for (Cohort c in u.cohort) {
          if (c.product.fa != 'C' && c.product.name == product.name) count += 1;
        }
      }

      for (Product be in army.battleengines) {
        if (be.fa != 'C' && be.name == product.name) count += 1;
      }

      for (Product st in army.structures) {
        if (st.fa != 'C' && st.name == product.name) count += 1;
      }
    }
    return count;
  }

  recalulateFA() {
    ArmyList newarmy = ArmyList(
      name: _armyList.name,
      listfaction: _armyList.listfaction,
      pointtarget: encounterLevelSelected['armypoints'].toString(),
      totalpoints: _currentpoints.toString(),
      favorite: false,
      leadergroup: [],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
    );

    for (var g in _armyList.leadergroup) {
      newarmy.leadergroup.add(LeaderGroup(leader: blankproduct, leaderattachment: blankproduct, cohort: [], spellrack: g.spellrack!));
      if (g.leader.name != '') {
        newarmy.leadergroup.last.leader = Product.copyProduct(g.leader);
        newarmy.leadergroup.last.leader.fanum = calculateFA(newarmy, g.leader);
      }
      if (g.leaderattachment.name != '') {
        newarmy.leadergroup.last.leaderattachment = Product.copyProduct(g.leaderattachment);
        newarmy.leadergroup.last.leaderattachment.fanum = calculateFA(newarmy, g.leaderattachment);
      }
      for (var c in g.cohort) {
        newarmy.leadergroup.last.cohort.add(Cohort(product: Product.copyProduct(c.product), selectedOptions: c.selectedOptions));
        newarmy.leadergroup.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
      }
    }
    for (var jr in _armyList.jrcasters) {
      newarmy.jrcasters.add(JrCasterGroup(leader: blankproduct, cohort: []));
      newarmy.jrcasters.last.leader = Product.copyProduct(jr.leader);
      newarmy.jrcasters.last.leader.fanum = calculateFA(newarmy, jr.leader);
      for (var c in jr.cohort) {
        newarmy.jrcasters.last.cohort.add(Cohort(product: Product.copyProduct(c.product), selectedOptions: c.selectedOptions));
        newarmy.jrcasters.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
      }
    }
    for (var u in _armyList.units) {
      newarmy.units.add(Unit(
        unit: blankproduct,
        minsize: u.minsize,
        hasMarshal: false,
        commandattachment: blankproduct,
        weaponattachments: [],
        cohort: [],
        weaponattachmentlimits: [],
      ));
      newarmy.units.last.unit = Product.copyProduct(u.unit);
      newarmy.units.last.unit.fanum = calculateFA(newarmy, u.unit);
      if (u.commandattachment.name != '') {
        newarmy.units.last.commandattachment = Product.copyProduct(u.commandattachment);
        newarmy.units.last.commandattachment.fanum = calculateFA(newarmy, u.commandattachment);
      }
      for (var wa in u.weaponattachments) {
        newarmy.units.last.weaponattachments.add(Product.copyProduct(wa));
        newarmy.units.last.weaponattachments.last.fanum = calculateFA(newarmy, wa);
      }
      newarmy.units.last.hasMarshal = FactionNotifier().checkUnitForMashal(newarmy.units.last);
      if (newarmy.units.last.hasMarshal) {
        for (var c in u.cohort) {
          newarmy.units.last.cohort.add(Cohort(product: Product.copyProduct(c.product), selectedOptions: c.selectedOptions));
          newarmy.units.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
        }
      }
      newarmy.units.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(u.unit.name);
    }
    for (var s in _armyList.solos) {
      newarmy.solos.add(Product.copyProduct(s));
      newarmy.solos.last.fanum = calculateFA(newarmy, s);
    }
    for (var be in _armyList.battleengines) {
      newarmy.battleengines.add(Product.copyProduct(be));
      newarmy.battleengines.last.fanum = calculateFA(newarmy, be);
    }
    for (var st in _armyList.structures) {
      newarmy.structures.add(Product.copyProduct(st));
      newarmy.structures.last.fanum = calculateFA(newarmy, st);
    }
    _armyList = newarmy;
  }

  String armyListToString() {
    List<String> list = [];
    for (var g in _armyList.leadergroup) {
      if (g.leader.name != '') {
        list.add(g.leader.name);
      }
      if (g.leaderattachment.name != '') {
        list.add('-${g.leaderattachment.name}');
      }
      for (var c in g.cohort) {
        list.add('-${c.product.name}');
      }
    }
    for (var jr in _armyList.jrcasters) {
      list.add(jr.leader.name);
      for (var c in jr.cohort) {
        list.add('-${c.product.name}');
      }
    }
    for (var u in _armyList.units) {
      list.add('${u.unit.name} - min unit: ${u.minsize}');
      if (u.commandattachment.name != '') {
        list.add(u.commandattachment.name);
      }
      for (var wa in u.weaponattachments) {
        list.add(wa.name);
      }
      if (u.hasMarshal) {
        for (var c in u.cohort) {
          list.add('-${c.product.name}');
        }
      }
    }
    for (var s in _armyList.solos) {
      list.add(s.name);
    }
    for (var be in _armyList.battleengines) {
      list.add(be.name);
    }
    for (var st in _armyList.structures) {
      list.add(st.name);
    }
    return list.toString();
  }

  Color checkFALimit(Product product) {
    if (product.fa == 'C' && product.fanum > 1) {
      return Colors.red;
    }
    if (int.tryParse(product.fa) != null) {
      if (product.fanum > int.parse(product.fa)) {
        return Colors.red;
      }
    }
    return Colors.white;
  }

  addLeaderandSelect(Product leader) {
    int index = 0;
    for (var a = 0; a < _armyList.leadergroup.length; a++) {
      if (_armyList.leadergroup[a].leader.name == '') {
        index = a;
        updateCasterCount(1);
        break;
      }
    }
    _armyList.leadergroup[index].leader = leader;
    _armyList.leadergroup[index].spellrack!.clear();
    int spellcount = FactionNotifier().casterHasSpellRack(leader);
    if (spellcount > 0) {
      for (var s = 0; s < spellcount; s++) {
        _armyList.leadergroup[index].spellrack!.add(blankspell);
      }
    }
    updateSelectedCaster(index, 'warcaster');
  }

  removeSelectedLeader(int groupnum) {
    _armyList.leadergroup[groupnum].leader = blankproduct;
    _armyList.leadergroup[groupnum].spellrack!.clear();
    updateCasterCount(-1);
  }

  setLeaderAttachment(Product product) {
    if (_armyList.leadergroup.isNotEmpty && _armyList.leadergroup.length - 1 >= _selectedcaster) {
      if (_armyList.leadergroup[_selectedcaster].leader.name != '') {
        _armyList.leadergroup[_selectedcaster].leaderattachment = Product.copyProduct(product);
      }
    }
    updateEverything();
  }

  removeLeaderAttachment(int groupnum) {
    _armyList.leadergroup[groupnum].leaderattachment = blankproduct;
    updateEverything();
  }

  int getSelectedCasterIndex() {
    int index = -1;
    switch (_selectedcastertype) {
      case 'warcaster':
        index = _selectedcaster;
        break;
      case 'jrcaster':
        index = _selectedcaster - _armyList.leadergroup.length;
        break;
      case 'unit':
        index = _selectedcaster - _armyList.leadergroup.length - _armyList.jrcasters.length;
        break;
      default:
        break;
    }
    return index;
  }

  addSpellToSpellRack(Spell spell, int leaderindex, int spellindex) {
    _armyList.leadergroup[leaderindex].spellrack![spellindex] = spell;
  }

  removeSpellFromSpellRack(int leaderindex, int spellindex) {
    _armyList.leadergroup[leaderindex].spellrack!.removeAt(spellindex);
  }

  addCohort(Cohort cohort, int leaderindex) {
    if (_selectedcastertype == 'warcaster') {
      _armyList.leadergroup[leaderindex].cohort.add(Cohort(product: Product.copyProduct(cohort.product), selectedOptions: cohort.selectedOptions));
      if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) {
        if (cohort.product.models[0].modularoptions!.isNotEmpty) {
          for (var element in cohort.product.models[0].modularoptions!) {
            _armyList.leadergroup[leaderindex].cohort.last.selectedOptions!.add(blankOption);
          }
        }
      }
      _armyList.leadergroup[leaderindex].cohort.sort(
        (a, b) => a.product.name.compareTo(b.product.name),
      );
    }
    if (_selectedcastertype == 'jrcaster') {
      // int index = selectedcaster - _armyList.leadergroup.length;
      _armyList.jrcasters[leaderindex].cohort.add(Cohort(product: Product.copyProduct(cohort.product), selectedOptions: cohort.selectedOptions));
      if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) {
        if (cohort.product.models[0].modularoptions!.isNotEmpty) {
          for (var element in cohort.product.models[0].modularoptions!) {
            _armyList.jrcasters[leaderindex].cohort.last.selectedOptions!.add(blankOption);
          }
        }
      }
      _armyList.jrcasters[leaderindex].cohort.sort(
        (a, b) => a.product.name.compareTo(b.product.name),
      );
    }
    if (_selectedcastertype == 'unit') {
      int marshals = 0;
      // for (int u = 0; u < _armyList.units.length; u++) {
      // if (_armyList.units[u].hasMarshal) {  //&& (_selectedcaster == marshals + _armyList.leadergroup.length + _armyList.jrcasters.length)) {
      _armyList.units[leaderindex].cohort.add(Cohort(product: Product.copyProduct(cohort.product), selectedOptions: cohort.selectedOptions));
      if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) {
        if (cohort.product.models[0].modularoptions!.isNotEmpty) {
          for (var element in cohort.product.models[0].modularoptions!) {
            _armyList.units[leaderindex].cohort.last.selectedOptions!.add(blankOption);
          }
        }
        _armyList.units[leaderindex].cohort.sort(
          (a, b) => a.product.name.compareTo(b.product.name),
        );
        // break;
        // }
        // }
        marshals++;
      }
    }
    updateEverything();
  }

  setCohortVals(int casterindex, int cohortindex, String type) {
    _cohortleaderindex = casterindex;
    _cohortindex = cohortindex;
    // _groupindex = groupindex;
    _leadertype = type;
  }

  setCohortOption(Option option, int groupindex) {
    switch (_leadertype) {
      case 'warcaster':
        _armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'jrcaster':
        _armyList.jrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'unit':
        _armyList.units[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  bool checkIfOptionSelected(Option option, int groupindex) {
    switch (_leadertype) {
      case 'warcaster':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
            return true;
          }
        }
        break;
      case 'jrcaster':
        if (_armyList.jrcasters.isNotEmpty) {
          if (_armyList.jrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.jrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
            return true;
          }
        }
        break;
      case 'unit':
        if (_armyList.units.isNotEmpty) {
          if (_armyList.units[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.units[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
            return true;
          }
        }
        break;
      default:
        return false;
    }
    return false;
  }

  bool checkIfAnyOptionSelected(int groupindex) {
    switch (_leadertype) {
      case 'warcaster':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      case 'jrcaster':
        if (_armyList.jrcasters.isNotEmpty) {
          if (_armyList.jrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      case 'unit':
        if (_armyList.units.isNotEmpty) {
          if (_armyList.units[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      default:
        return false;
    }
    return false;
  }

  removeCohortOption(int index, int cohortindex, int optionindex, String type) {
    switch (type) {
      case 'warcaster':
        _armyList.leadergroup[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'jrcaster':
        _armyList.jrcasters[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'unit':
        _armyList.units[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  removeCohort(int index, int cohortindex, String type) {
    switch (type) {
      case 'warcaster':
        _armyList.leadergroup[index].cohort.removeAt(cohortindex);
        break;
      case 'jrcaster':
        _armyList.jrcasters[index].cohort.removeAt(cohortindex);
        break;
      case 'unit':
        _armyList.units[index].cohort.removeAt(cohortindex);
        break;
      default:
        break;
    }
    updateEverything();
  }

  addSolo(Product product) {
    _armyList.solos.add(Product.copyProduct(product));
    _armyList.solos.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    updateEverything();
  }

  removeSolo(Product product) {
    _armyList.solos.remove(product);
    updateEverything();
  }

  addUnit(Unit unit) {
    _armyList.units.add(unit);
    _armyList.units.last.hasMarshal = FactionNotifier().checkUnitForMashal(unit);
    _armyList.units.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(unit.unit.name);
    if (_armyList.units.last.hasMarshal) {
      updateCasterCount(1);
      updateSelectedCaster(_castercount, 'unit');
    }
    _armyList.units.sort(
      (a, b) => a.unit.name.compareTo(b.unit.name),
    );
    updateEverything();
  }

  removeUnit(int unitnum) {
    _armyList.units.removeAt(unitnum);
    updateEverything();
  }

  updateUnitSize(int unitnum) {
    _armyList.units[unitnum].minsize = !_armyList.units[unitnum].minsize;
    calculatePoints();
    notifyListeners();
  }

  setUnitCommandAttachment(Product product) {
    _armyList.units[_addToIndex].commandattachment = Product.copyProduct(product);
    updateEverything();
  }

  removeUnitCommandAttachment(int unitnum) {
    _armyList.units[unitnum].commandattachment = blankproduct;
    updateEverything();
  }

  addUnitWeaponAttachment(Product product) {
    int walimit = _armyList.units[_addToIndex].minsize
        ? _armyList.units[_addToIndex].weaponattachmentlimits[0]
        : _armyList.units[_addToIndex].weaponattachmentlimits[1];
    if (_armyList.units[_addToIndex].weaponattachments.length < walimit) {
      _armyList.units[_addToIndex].weaponattachments.add(Product.copyProduct(product));
    }
    updateEverything();
  }

  removeUnitWeaponAttachment(Product product, int unitnum) {
    _armyList.units[unitnum].weaponattachments.remove(product);
    updateEverything();
  }

  addBattleEngine(Product product) {
    _armyList.battleengines.add(Product.copyProduct(product));
    _armyList.battleengines.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    updateEverything();
  }

  removeBattleEnging(Product product) {
    _armyList.battleengines.remove(product);
    updateEverything();
  }

  addStructure(Product product) {
    _armyList.structures.add(Product.copyProduct(product));
    _armyList.structures.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    updateEverything();
  }

  removeStructure(Product product) {
    _armyList.structures.remove(product);
    updateEverything();
  }

  addJrCaster(Product product) {
    _armyList.jrcasters.add(JrCasterGroup(leader: Product.copyProduct(product), cohort: []));
    _armyList.jrcasters.sort((a, b) => a.leader.name.compareTo(b.leader.name));
    updateCasterCount(1);
    updateSelectedCaster(_castercount, 'jrcaster');
    updateEverything();
  }

  removeJrCaster(int productnum) {
    JrCasterGroup jrgroup = _armyList.jrcasters[productnum];
    _armyList.jrcasters.remove(jrgroup);
    updateCasterCount(-1);
    updateEverything();
  }

  removeJrCohort(Cohort cohort, int groupnum) {
    _armyList.jrcasters[groupnum].cohort.remove(cohort);
    updateEverything();
  }

  removeUnitCohort(Cohort cohort, int groupnum) {
    _armyList.units[groupnum].cohort.remove(cohort);
    updateEverything();
  }

  resetList() {
    _armyList = ArmyList(
      name: '',
      listfaction: _armyList.listfaction,
      pointtarget: encounterLevelSelected['armypoints'].toString(),
      totalpoints: '0',
      favorite: false,
      leadergroup: [LeaderGroup(leader: blankproduct, leaderattachment: blankproduct, cohort: [], spellrack: [])],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
    );
    _addToIndex = 0;
    _currentpoints = 0;
    _cohortpoints = 0;
    _selectedcaster = 0;
    _castercount = -1;
    _selectedcasterFactionIndexes = [];
    _selectedProduct = blankproduct;
    _leadertype = 'warcaster';
    _status = 'new';
    notifyListeners();
  }

  resetEncounterLevel() {
    _encounterLevelSelected = AppData().encounterlevels[0];
    _encounterlevel = _encounterLevelSelected['level'];
    notifyListeners();
  }

  String copytListToClipboard() {
    // String export = 'WM3.5 Army\n\n$factionSelected - ${_listnameController.text}\n\n$_currentpoints / ${_encounterLevelSelected['armypoints']}\n';
    ArmyList list;
    if (_deploying) {
      list = _deployedLists[0].list;
    } else {
      list = _armyList;
    }
    String export = 'WM3.5 Army\n\n${list.listfaction} - ${list.name}\n\n${list.totalpoints} / ${list.pointtarget}\n';

    for (var g in list.leadergroup) {
      if (g.leader.name != '') {
        export = '$export\n${g.leader.name} - BGP: +${g.leader.points}';
      }
      if (g.leaderattachment.name != '') {
        export = '$export\n- ${g.leaderattachment.name} - PC: ${g.leaderattachment.points}';
      }
      for (var c in g.cohort) {
        export = '$export\n- ${c.product.name} - PC: ${c.product.points}';
        if (c.selectedOptions!.isNotEmpty) {
          for (var op in c.selectedOptions!) {
            export = '$export \n + ${op.name} - PC: ${op.cost}';
          }
        }
      }
    }
    if (list.jrcasters.isNotEmpty) {
      export = '$export\n';
      for (var jr in list.jrcasters) {
        export = '$export\n${jr.leader.name} - PC: ${jr.leader.points}';
        for (var c in jr.cohort) {
          export = '$export\n- ${c.product.name} - PC: ${c.product.points}';
          if (c.selectedOptions!.isNotEmpty) {
            for (var op in c.selectedOptions!) {
              export = '$export \n + ${op.name} - PC: ${op.cost}';
            }
          }
        }
      }
    }
    if (list.units.isNotEmpty) {
      export = '$export\n';
      for (var u in list.units) {
        export =
            '$export\n${u.unit.name} - ${u.unit.unitPoints![u.minsize ? 'minunit' : 'maxunit']} - PC: ${u.unit.unitPoints![u.minsize ? 'mincost' : 'maxcost']}';
        if (u.commandattachment.name != '') {
          export = '$export\n- ${u.commandattachment.name} - PC: ${u.commandattachment.points!}';
        }
        for (var wa in u.weaponattachments) {
          export = '$export\n- ${wa.name} - PC: ${wa.points}';
        }
        if (u.hasMarshal) {
          for (var c in u.cohort) {
            export = '$export\n- ${c.product.name} - PC: ${c.product.points}';
            if (c.selectedOptions!.isNotEmpty) {
              for (var op in c.selectedOptions!) {
                export = '$export \n + ${op.name} - PC: ${op.cost}';
              }
            }
          }
        }
      }
    }
    if (list.solos.isNotEmpty) {
      export = '$export\n';
      for (var s in list.solos) {
        export = '$export\n${s.name} - PC: ${s.points}';
      }
    }
    if (list.battleengines.isNotEmpty) {
      export = '$export\n';
      for (var be in list.battleengines) {
        export = '$export\n${be.name} - PC: ${be.points}';
      }
    }
    if (list.structures.isNotEmpty) {
      export = '$export\n';
      for (var st in list.structures) {
        export = '$export\n${st.name} - PC: ${st.points}';
      }
    }

    return export;
  }

  setArmyList(ArmyList army, int index, String status) async {
    _selectedcaster = 0;
    _status = status;
    _selectedProduct = blankproduct;
    _armylistindex = index;
    _armyList = ArmyList(
      name: '',
      listfaction: '',
      pointtarget: '',
      totalpoints: '',
      favorite: false,
      leadergroup: [LeaderGroup(leader: blankproduct, leaderattachment: blankproduct, cohort: [], spellrack: [])],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
    );
    _castercount = 0;

    int firstcasterindex = -1;
    String firstcastertype = '';

    setFactionSelected(army.listfaction);
    setEncounterLevel(AppData().encounterlevels.firstWhere((element) => element['armypoints'].toString() == army.pointtarget));
    _armyList.name = army.name;
    for (var g = 0; g < army.leadergroup.length; g++) {
      _addToIndex = g;
      LeaderGroup group = army.leadergroup[g];
      addLeaderandSelect(group.leader);
      if (firstcasterindex == -1) {
        firstcasterindex = g;
        firstcastertype = 'warcaster';
      }
      if (group.leaderattachment.name != '') setLeaderAttachment(group.leaderattachment);
      for (var c in group.cohort) {
        addCohort(c, g);
      }
    }
    for (var g = 0; g < army.jrcasters.length; g++) {
      _addToIndex = g + army.leadergroup.length;
      JrCasterGroup group = army.jrcasters[g];
      addJrCaster(group.leader);
      if (firstcasterindex == -1) {
        firstcasterindex = g;
        firstcastertype = 'jrcaster';
      }
      for (var c in group.cohort) {
        addCohort(c, g);
      }
    }
    for (var g = 0; g < army.units.length; g++) {
      _addToIndex = g;
      Unit group = army.units[g];
      addUnit(group);
      if (group.hasMarshal) {
        if (firstcasterindex == -1) {
          firstcasterindex = g;
          firstcastertype = 'unit';
        }
      }
    }
    for (var g = 0; g < army.solos.length; g++) {
      _addToIndex = g;
      addModelToList(army.solos[g]);
    }
    for (var g = 0; g < army.battleengines.length; g++) {
      _addToIndex = g;
      addModelToList(army.battleengines[g]);
    }
    for (var g = 0; g < army.structures.length; g++) {
      _addToIndex = g;
      addModelToList(army.structures[g]);
    }
    updateSelectedCaster(firstcasterindex, firstcastertype);
    notifyListeners();
  }

  resetDeployedLists() {
    _deployedLists.clear();
    resetHPListTracking();
  }

  deployList(ArmyList list) {
    _deployedLists.add(DeployedArmyList(
        list: list,
        selectedProduct: blankproduct,
        selectedCohort: Cohort(product: blankproduct, selectedOptions: []),
        selectedModelIndex: -1,
        selectedListModelIndex: -1,
        barcount: -1));
    notifyListeners();
  }

  resetHPListTracking() {
    _hptracking.clear();
  }

  addNewListHPTracking() {
    _hptracking.add([]);
  }

  addSingleHPBarHPTracking(int listindex) {
    Map<String, dynamic> hp = {'damage': 0};
    _hptracking[listindex].add(hp);
  }

  addUnitHPBarsHPTracking(int listindex, int barcount) {
    List<int> bars = List.generate(barcount, (index) => 0);
    Map<String, dynamic> hp = {'damage': 0, 'hpbarsdamage': bars};
    _hptracking[listindex].add(hp);
  }

  addGridHPTracking(int listindex, int columncount) {
    List<List<bool>> grid = [];
    for (int c = 0; c < columncount; c++) {
      grid.add([]);
      for (int i = 0; i < 6; i++) {
        grid[c].add(false);
      }
    }
    Map<String, dynamic> hp = {'damage': 0, 'grid': grid};
    _hptracking[listindex].add(hp);
  }

  addShieldTracking(int listindex) {
    List<List<bool>> shield = [];
    for (int c = 0; c < 2; c++) {
      shield.add([]);
      for (int i = 0; i < 6; i++) {
        shield[c].add(false);
      }
    }
  }

  addSpiralHPTracking(int listindex, Spiral s) {
    List<List<bool>> spiral = List.generate(6, (index) => List.generate(int.parse(s.values[index]), (index) => false));
    Map<String, dynamic> hp = {'damage': 0, 'spiral': spiral};
    _hptracking[listindex].add(hp);
  }

  addWebHPTracking(int listindex, Web w) {
    List<List<bool>> web = List.generate(3, (index) => List.generate(int.parse(w.values[index]), (index) => false));
    Map<String, dynamic> hp = {'damage': 0, 'web': web};
    _hptracking[listindex].add(hp);
  }

  adjustHPDamage(int listindex, int modelindex, int value, int? hpbarindex) {
    if (hpbarindex == null) {
      if (_hptracking[listindex][modelindex]['damage'] == value) {
        _hptracking[listindex][modelindex]['damage'] = 0;
      } else {
        _hptracking[listindex][modelindex]['damage'] = value;
      }
    } else {
      if (_hptracking[listindex][modelindex]['hpbarsdamage'][hpbarindex] == value) {
        _hptracking[listindex][modelindex]['hpbarsdamage'][hpbarindex] = 0;
      } else {
        _hptracking[listindex][modelindex]['hpbarsdamage'][hpbarindex] = value;
      }
    }
    notifyListeners();
  }

  adjustCustomBar(int listindex, int modelindex, int value, int barindex) {
    if (_custombartracking[listindex][modelindex]['value'] == value) {
      _custombartracking[listindex][modelindex]['value'] = 0;
    } else {
      _custombartracking[listindex][modelindex]['value'] = value;
    }
    notifyListeners();
  }

  adjustGridDamage(int listindex, int modelindex, int columnindex, int rowindex) {
    bool active = !_hptracking[listindex][modelindex]['grid'][columnindex][rowindex];
    _hptracking[listindex][modelindex]['grid'][columnindex][rowindex] = active;
    if (active) {
      //add damage
      _hptracking[listindex][modelindex]['damage']++;
    } else {
      //remove damage
      _hptracking[listindex][modelindex]['damage']--;
    }
    notifyListeners();
  }

  adjustShieldDamage(int listindex, int modelindex, int columnindex, int rowindex) {
    bool active = !_hptracking[listindex][modelindex]['shield'][columnindex][rowindex];
    _hptracking[listindex][modelindex]['shield'][columnindex][rowindex] = active;
    if (active) {
      //add damage
      _hptracking[listindex][modelindex]['shield']++;
    } else {
      //remove damage
      _hptracking[listindex][modelindex]['shield']--;
    }
    notifyListeners();
  }

  adjustSpiralDamage(int listindex, int modelindex, int branchindex, int dotnum) {
    bool active = !_hptracking[listindex][modelindex]['spiral'][branchindex][dotnum];
    _hptracking[listindex][modelindex]['spiral'][branchindex][dotnum] = active;
    if (active) {
      //add damage
      _hptracking[listindex][modelindex]['damage']++;
    } else {
      //remove damage
      _hptracking[listindex][modelindex]['damage']--;
    }
    notifyListeners();
  }

  adjustWebDamage(int listindex, int modelindex, int ringindex, int dotnum) {
    bool active = !_hptracking[listindex][modelindex]['web'][ringindex][dotnum];
    _hptracking[listindex][modelindex]['web'][ringindex][dotnum] = active;
    if (active) {
      //add damage
      _hptracking[listindex][modelindex]['damage']++;
    } else {
      //remove damage
      _hptracking[listindex][modelindex]['damage']--;
    }
    notifyListeners();
  }
}
