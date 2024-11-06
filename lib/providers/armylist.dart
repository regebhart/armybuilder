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
import 'package:uuid/uuid.dart';

import '../models/cohort.dart';
import '../models/modularoptions.dart';
import '../models/spells.dart';
import '../models/unit.dart';
import '../appdata.dart';

class ArmyListNotifier extends ChangeNotifier {
  TextEditingController? _listnameController;
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
  late String _selectedcasteruuid;
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
  late String _leadertype;
  late int _hodleaderindex;

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
      selectable: true,
      removable: true,
      uuid: '');

  Spell blankspell = Spell(
    cost: '',
    description: '',
    name: '',
    off: '',
    rng: '',
  );

  TextEditingController get listnameController => _listnameController!;
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
  String get selectedcasteruuid => _selectedcasteruuid;
  String get selectedcastertype => _selectedcastertype;
  Product get selectedcasterProduct => _selectedcasterProduct;
  List<int> get selectedcasterFactionIndexes => _selectedcasterFactionIndexes;
  Product get selectedProduct => _selectedProduct;
  Cohort get selectedCohort => _selectedCohort;
  List<bool> get viewingcohort => _viewingcohort;
  String get status => _status;
  int get armylistindex => _armylistindex;
  String get armylistFactionFilter => _armylistFactionFilter;
  int get cohortindex => _cohortindex;

  List<List<dynamic>> get hptracking => _hptracking;
  List<List<dynamic>> get custombartracking => _custombartracking;
  List<int> get castergroupindex => _castergroupindex;
  int get hodleaderindex => _hodleaderindex;

  ArmyListNotifier() {
    _categoryProductsList = [];
    _factionSelected = '';
    _encounterLevelSelected = AppData().encounterlevels[0];
    _addToIndex = 0;
    _encounterlevel = '0';
    _currentpoints = 0;
    _cohortpoints = 0;
    _selectedcaster = 0;
    _selectedcasteruuid = '';
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
      leadergroup: [
        LeaderGroup(
          leader: blankproduct,
          leaderattachment: blankproduct,
          cohort: [],
          spellrack: [],
          spellracklimit: 0,
          oofcohort: [],
          oofjrcasters: [],
          oofsolos: [],
          oofunits: [],
          heartofdarkness: false,
          heartofdarknessfaction: '',
          flamesinthedarkness: false,
        )
      ],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
      heartofdarkness: false,
      flamesinthedarkness: false,
    );
    _deploying = false;
    _deployedLists = [];
    _armylistindex = 0;
    _armylistFactionFilter = 'All';
    _hptracking = [];
    _custombartracking = [];
    _cohortindex = 0;
    _leadertype = 'warcaster';
    _castergroupindex = [0];
    _hodleaderindex = -1;
  }

  notify() {
    notifyListeners();
  }

  setStatus(String value) {
    //status of the list, new or updating existing list
    _status = value;
  }

  setlistnameController(TextEditingController con) {
    _listnameController = con;
    con.text = _armyList.name;
  }

  setlistname(String value) {
    _armyList.name = value;
    if (_listnameController != null) {
      _listnameController!.text = _armyList.name;
    }
  }

  setFactionSelected(String faction) {
    _factionSelected = faction;
    _armyList.listfaction = faction;

    notifyListeners();
  }

  setAddtoIndex(int index) {
    //used to set which unit the UA is being added to
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

  setHoDLeaderIndex(int value) {
    _hodleaderindex = value;
  }

  setEncounterLevel(Map<String, dynamic> level) {
    _encounterLevelSelected = level;
    _encounterlevel = level['level'];
    _armyList.pointtarget = level['armypoints'].toString();
    if (_armyList.leadergroup[0].leader.name != '') {
      updateSelectedCaster('warcaster', _armyList.leadergroup[0].leader);
    }
    if (_armyList.leadergroup.length > level['castercount']) {
      do {
        _armyList.leadergroup.removeLast();
        updateCasterCount(-1);
        _castergroupindex.removeLast();
      } while (_armyList.leadergroup.length > level['castercount']);
    } else if (_armyList.leadergroup.length < level['castercount']) {
      do {
        _armyList.leadergroup.add(LeaderGroup(
          leader: blankproduct,
          leaderattachment: blankproduct,
          cohort: [],
          spellrack: [],
          spellracklimit: 0,
          oofcohort: [],
          oofjrcasters: [],
          oofsolos: [],
          oofunits: [],
          heartofdarkness: false,
          heartofdarknessfaction: '',
          flamesinthedarkness: false,
        ));
        // updateCasterCount(1);
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

  int getSelectedCasterIndex(Product product) {
    int foundindex = -1;
    switch (_selectedcastertype) {
      case 'warcaster' || 'oofcohort':
        for (int a = 0; a < _armyList.leadergroup.length; a++) {
          if (_armyList.leadergroup[a].leader.uuid == product.uuid) {
            foundindex = a;
            break;
          }
        }
        break;
      case 'jrcaster':
        // int castercount = _armyList.leadergroup.length - 1;
        // int index = castercount;
        for (int jr = 0; jr < _armyList.jrcasters.length; jr++) {
          // index++;
          if (_armyList.jrcasters[jr].leader.uuid == product.uuid) {
            foundindex = jr;
            break;
          }
        }
        break;
      case 'unit':
        // int castercount = _armyList.leadergroup.length + _armyList.jrcasters.length - 1;
        // int index = castercount;
        for (int u = 0; u < _armyList.units.length; u++) {
          // if (_armyList.units[u].hasMarshal) index++;
          if (_armyList.units[u].unit.uuid == product.uuid) {
            foundindex = u;
            break;
          }
        }
        break;
      case 'oofjrcaster':
        bool found = false;
        int castercount =
            _armyList.leadergroup.length + _armyList.jrcasters.length + _armyList.units.where((element) => element.hasMarshal).length - 1;
        int index = castercount;
        for (int a = 0; a < _armyList.leadergroup.length; a++) {
          for (int jr = 0; jr < _armyList.leadergroup[a].oofjrcasters.length; jr++) {
            if (_armyList.leadergroup[a].oofjrcasters[jr].leader.uuid == product.uuid) {
              found = true;
              foundindex = index;
              break;
            }
          }
          if (found) break;
          index += _armyList.leadergroup[a].oofunits.where((element) => element.hasMarshal).length;
        }
        break;
      case 'oofunit':
        bool found = false;
        int castercount =
            _armyList.leadergroup.length + _armyList.jrcasters.length + _armyList.units.where((element) => element.hasMarshal).length - 1;
        int index = castercount;
        for (int a = 0; a < _armyList.leadergroup.length; a++) {
          index += _armyList.leadergroup[a].oofjrcasters.length;
          for (int u = 0; u < _armyList.leadergroup[a].oofunits.length; u++) {
            if (_armyList.leadergroup[a].oofunits[u].hasMarshal) index++;
            if (_armyList.leadergroup[a].oofunits[u].unit.uuid == product.uuid) {
              found = true;
              foundindex = index;
              break;
            }
          }
          if (found) break;
        }
        break;
      default:
        break;
    }
    return foundindex;
  }

  int getJrIndex(Product product) {
    int foundindex = -1;
    bool found = false;
    for (int a = 0; a < _armyList.leadergroup.length; a++) {
      for (int jr = 0; jr < _armyList.leadergroup[a].oofjrcasters.length; jr++) {
        if (_armyList.leadergroup[a].oofjrcasters[jr].leader.uuid == product.uuid) {
          found = true;
          foundindex = jr;
          break;
        }
      }
      if (found) break;
    }
    return foundindex;
  }

  int getUnitIndex(Product product) {
    late int foundindex;
    switch (_selectedcastertype) {
      case 'oofjrcaster':
        bool found = false;
        for (int a = 0; a < _armyList.leadergroup.length; a++) {
          for (int jr = 0; jr < _armyList.leadergroup[a].oofjrcasters.length; jr++) {
            if (_armyList.leadergroup[a].oofjrcasters[jr].leader.uuid == product.uuid) {
              found = true;
              foundindex = jr;
              break;
            }
          }
          if (found) break;
        }
        break;
      case 'oofunit':
        bool found = false;
        for (int a = 0; a < _armyList.leadergroup.length; a++) {
          for (int u = 0; u < _armyList.leadergroup[a].oofunits.length; u++) {
            if (_armyList.leadergroup[a].oofunits[u].unit.uuid == product.uuid) {
              found = true;
              foundindex = u;
              break;
            }
          }
          if (found) break;
        }
        break;
      default:
        break;
    }
    return foundindex;
  }

  bool updateSelectedCaster(String type, Product product) {
    if (_armyList.leadergroup[0].leader.name == '') return false;
    bool found = false;
    // _hodleaderindex = -1;
    _selectedcastertype = type;
    switch (type) {
      case 'warcaster' || 'oofcohort':
        for (var a = 0; a < _armyList.leadergroup.length; a++) {
          if (_armyList.leadergroup[a].leader.uuid == product.uuid) {
            _selectedcaster = a;
            _selectedcasterProduct = _armyList.leadergroup[a].leader;
            setcasterfactionindex();
            found = true;
            if (_selectedcasterProduct.models[0].heartofdarknessfaction! != '') {
              // _armyList.heartofdarkness = true;
              _armyList.leadergroup[a].heartofdarkness = true;
              _armyList.leadergroup[a].heartofdarknessfaction = _selectedcasterProduct.models[0].heartofdarknessfaction!;
              _hodleaderindex = a;
            } else {
              // _armyList.heartofdarkness = false;
              _armyList.leadergroup[a].heartofdarkness = false;
              _armyList.leadergroup[a].heartofdarknessfaction = '';
              _hodleaderindex = -1;
            }
            if (FactionNotifier().checkProductForFlamesintheDarkness(selectedcasterProduct)) {
              _armyList.flamesinthedarkness = true;
            }
            break;
          }
        }

        break;
      case 'jrcaster':
        int totalcasters = _armyList.leadergroup.where((element) => element.leader.name.isNotEmpty).length;
        int index = totalcasters - 1;
        for (var a = 0; a < _armyList.jrcasters.length; a++) {
          index++;
          if (_armyList.jrcasters[a].leader.uuid == product.uuid) {
            _selectedcaster = index;
            _selectedcasterProduct = _armyList.jrcasters[a].leader;
            setcasterfactionindex();
            found = true;
            break;
          }
        }
        break;
      case 'unit':
        int totalcasters = _armyList.leadergroup.length + _armyList.jrcasters.length;
        int index = totalcasters - 1;
        for (var u = 0; u < _armyList.units.length; u++) {
          if (armyList.units[u].hasMarshal) {
            index++;
            if (_armyList.units[u].unit.uuid == product.uuid) {
              _selectedcaster = index;
              _selectedcasterProduct = _armyList.units[u].unit;
              setcasterfactionindex();
              found = true;
              break;
            }
          }
        }
        break;
      case 'oofjrcaster':
        int totalmarshalunits = _armyList.units.where((element) => element.hasMarshal).length;
        int totalcasters = _armyList.leadergroup.length + _armyList.jrcasters.length + totalmarshalunits;
        int index = totalcasters - 1;
        for (int ldr = 0; ldr < _armyList.leadergroup.length; ldr++) {
          for (var jr in _armyList.leadergroup[ldr].oofjrcasters) {
            index++;
            if (jr.leader.uuid == product.uuid) {
              _selectedcasterProduct = jr.leader;
              _selectedcaster = index;
              setcasterfactionindex();
              found = true;
              break;
            }
          }
          if (found) break;
          index += _armyList.leadergroup[ldr].oofunits.where((element) => element.hasMarshal).length;
        }

        break;
      case 'oofunit':
        int oofjrcastercount = 0;
        int totalmarshalunits = _armyList.units.where((element) => element.hasMarshal).length;
        int totalcasters = _armyList.leadergroup.length + _armyList.jrcasters.length + totalmarshalunits;

        int index = totalcasters - 1;
        for (int ldr = 0; ldr < _armyList.leadergroup.length; ldr++) {
          index += _armyList.leadergroup[ldr].oofjrcasters.length;
          for (var u in _armyList.leadergroup[ldr].oofunits) {
            if (u.hasMarshal) index++;
            if (u.unit.uuid == product.uuid) {
              _hodleaderindex = ldr;
              _selectedcasterProduct = u.unit;
              _selectedcaster = index;
              setcasterfactionindex();
              found = true;
              break;
            }
            // index++;
          }
          if (found) break;
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
    if (_selectedcasterProduct.name != '') {
      int primaryfactionindex = 0;
      bool merc = false;
      bool partisan = false;
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
        if (ab.name.toLowerCase().contains('mercenary')) {
          merc = true;
        }
        if (ab.name.toLowerCase().contains("split loyalties")) {
          _selectedcasterFactionIndexes.clear();
          _selectedcasterFactionIndexes
              .add(AppData().factionList.indexWhere((element) => element['name'].toString().toLowerCase() == _armyList.listfaction.toLowerCase()));
        }
        if (ab.name.toLowerCase().contains('partisan')) {
          if (_armyList.listfaction != "Mercenaries" && ab.name.toLowerCase().contains(_armyList.listfaction.toLowerCase())) {
            //change the model to a faction model
            partisan = true;
            _selectedcasterFactionIndexes.clear();
            _selectedcasterFactionIndexes
                .add(AppData().factionList.indexWhere((element) => element['name'].toString().toLowerCase() == _armyList.listfaction.toLowerCase()));
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
      if (merc && !partisan) {
        _selectedcasterFactionIndexes.clear();
        _selectedcasterFactionIndexes.add(AppData().factionList.indexWhere((element) => element['name'].toString().toLowerCase() == 'mercenaries'));
      }
      notifyListeners();
    }
  }

  updateEverything() {
    recalulateFA();
    calculatePoints();
    notifyListeners();
  }

  addModelToList(Product product, bool oof, int? leaderindex) {
    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        addLeaderandSelect(product);
        break;
      case 'Warjacks/Warbeasts/Horrors':
        break; //handled by addCohort
      case 'Solos':
        if (FactionNotifier().checkSoloForJourneyman(product) || FactionNotifier().checkProductForMarshal(product)) {
          addJrCaster(product, oof, leaderindex);
        } else {
          addSolo(product, oof, leaderindex);
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

  removeModelFromList(Product product, int? groupnum, bool oof, int? leaderindex) {
    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        removeSelectedLeader(groupnum!);
        break;
      case 'Warjacks/Warbeasts/Horrors':
        break; //handled by removeCohort
      case 'Solos':
        if (product.models[0].title.toLowerCase().contains('warcaster') || product.models[0].title.toLowerCase().contains('warlock')) {
          _castercount -= 1;
          removeJrCaster(groupnum!, oof, leaderindex);
        } else {
          removeSolo(product, oof, leaderindex);
        }
        break;
      case 'Attachments':
        for (var ab in product.models[0].characterabilities!) {
          if (ab.name == "Attached") {
            removeLeaderAttachment(groupnum!);
          }
        }
        break;
      case 'Battle Engines':
        removeBattleEngine(product);
        break;
      case 'Structures':
        removeStructure(product);
        break;
    }
    updateEverything();
  }

  addLeaderandSelect(Product leader) {
    int index = 0;
    bool factionchange = true;
    for (var a = 0; a < _armyList.leadergroup.length; a++) {
      if (_armyList.leadergroup[a].leader.name == '') {
        index = a;
        updateCasterCount(1);
        break;
      }
    }
    if (_armyList.leadergroup[index].leader.name != '') {
      //check if the faction changed between leaders, if so clear cohort/invalid models
      for (var f in _armyList.leadergroup[index].leader.primaryFaction) {
        for (var nf in leader.primaryFaction) {
          if (f == nf) {
            factionchange = false;
            break;
          }
          if (factionchange == false) break;
        }
      }
      if ((_armyList.leadergroup[index].leader.models[0].title.toLowerCase().contains('warcaster') &&
              !leader.models[0].title.toLowerCase().contains('warcaster')) ||
          (_armyList.leadergroup[index].leader.models[0].title.toLowerCase().contains('warlock') &&
              !leader.models[0].title.toLowerCase().contains('warlock')) ||
          (_armyList.leadergroup[index].leader.models[0].title.toLowerCase().contains('master') &&
              !leader.models[0].title.toLowerCase().contains('master')) ||
          (factionchange)) {
        _armyList.leadergroup[index].cohort.clear(); //clear cohort list if caster type changed ie warcaster to warlock
      }
    }
    _armyList.leadergroup[index].leader = leader;
    _armyList.leadergroup[index].leader.uuid = const Uuid().v1();
    _armyList.leadergroup[index].spellrack!.clear();
    _armyList.leadergroup[index].spellracklimit = FactionNotifier().casterHasSpellRack(leader);
    _armyList.leadergroup[index].heartofdarkness = FactionNotifier().checkProductForHeartofDarkness(leader);
    _armyList.leadergroup[index].flamesinthedarkness = FactionNotifier().checkProductForFlamesintheDarkness(leader);
    if (!_armyList.leadergroup[index].flamesinthedarkness && _armyList.leadergroup[index].oofcohort.isNotEmpty) {
      _armyList.leadergroup[index].oofcohort.clear();
    }
    //sort casters then find new index of caster that was just added
    _armyList.leadergroup.sort((a, b) => a.leader.name.toLowerCase().compareTo(b.leader.name != "" ? b.leader.name.toLowerCase() : "zzzzzzzzz"));

    for (var a = 0; a < _armyList.leadergroup.length; a++) {
      if (_armyList.leadergroup[a].leader.name == leader.name) {
        index = a;
        break;
      }
    }
    if (_armyList.listfaction == 'Infernals') updateHeartofDarkness();
    if (_armyList.listfaction == 'Religion of the Twins') updateFlamesintheDarkness();
    updateSelectedCaster('warcaster', leader);
  }

  updateHeartofDarkness() {
    bool hod = false;
    for (var l in _armyList.leadergroup) {
      hod = FactionNotifier().checkProductForHeartofDarkness(l.leader);
      if (hod) break;
    }
    if (!hod) {
      for (var ld in _armyList.leadergroup) {
        ld.oofjrcasters.clear();
        ld.oofsolos.clear();
        ld.oofunits.clear();
      }
    }
    _armyList.heartofdarkness = hod;
  }

  updateFlamesintheDarkness() {
    bool fitd = false;
    for (var l in _armyList.leadergroup) {
      fitd = FactionNotifier().checkProductForFlamesintheDarkness(l.leader);
      if (fitd) break;
    }
    if (!fitd) {
      for (var ld in _armyList.leadergroup) {
        ld.oofcohort.clear();
      }
    }
    _armyList.flamesinthedarkness = fitd;
  }

  removeSelectedLeader(int groupnum) {
    _armyList.leadergroup[groupnum].leader = blankproduct;
    _armyList.leadergroup[groupnum].spellrack!.clear();
    _armyList.leadergroup[groupnum].heartofdarknessfaction = "";
    _armyList.leadergroup[groupnum].heartofdarkness = false;
    _armyList.leadergroup[groupnum].oofjrcasters.clear();
    _armyList.leadergroup[groupnum].oofsolos.clear();
    _armyList.leadergroup[groupnum].oofunits.clear();
    _selectedcasterFactionIndexes.clear();
    updateCasterCount(-1);
    if (_castercount > 0) {
      //if there's still casters in the list, sort them
      _armyList.leadergroup.sort((a, b) => a.leader.name != ""
          ? a.leader.name.toLowerCase().compareTo(b.leader.name != "" ? b.leader.name.toLowerCase() : "zzzzzzzzz")
          : "zzzzzzzz".compareTo(b.leader.name != "" ? b.leader.name.toLowerCase() : "zzzzzzzzz"));
    }
    if (_armyList.listfaction == 'Infernals') updateHeartofDarkness();
    if (_armyList.listfaction == 'Religion of the Twins') updateFlamesintheDarkness();
    notifyListeners();
  }

  addCohort(Cohort cohort, int casterindex, bool oof, int? leaderindex) {
    switch (_selectedcastertype) {
      case 'warcaster':
        LeaderGroup ld = _armyList.leadergroup[casterindex];
        ld.cohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));
        if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);

        String cohortuuid = ld.cohort.last.product.uuid;
        ld.cohort.sort(
          (a, b) => a.product.name.compareTo(b.product.name),
        );
        for (int c = 0; c < ld.cohort.length; c++) {
          Cohort cohort = ld.cohort[c];
          if (cohort.product.uuid == cohortuuid) {
            _cohortindex = c;
            break;
          }
        }
        break;
      case 'oofcohort':
        LeaderGroup ld = _armyList.leadergroup[casterindex];
        if (ld.oofcohort.length == 2) ld.oofcohort.removeLast();
        ld.oofcohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));

        if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);
        String cohortuuid = ld.oofcohort.last.product.uuid;
        ld.oofcohort.sort(
          (a, b) => a.product.name.compareTo(b.product.name),
        );
        for (int c = 0; c < ld.oofcohort.length; c++) {
          Cohort cohort = ld.oofcohort[c];
          if (cohort.product.uuid == cohortuuid) {
            _cohortindex = c;
            break;
          }
        }
        break;
      case 'jrcaster':
        JrCasterGroup jr = _armyList.jrcasters[casterindex];
        if (FactionNotifier().checkProductForMarshal(jr.leader)) {
          jr.cohort.clear();
        }
        jr.cohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));
        if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);
        String cohortuuid = jr.cohort.last.product.uuid;
        jr.cohort.sort(
          (a, b) => a.product.name.compareTo(b.product.name),
        );
        for (int c = 0; c < jr.cohort.length; c++) {
          Cohort cohort = jr.cohort[c];
          if (cohort.product.uuid == cohortuuid) {
            _cohortindex = c;
            break;
          }
        }
        break;
      case 'unit':
        Unit unit = _armyList.units[casterindex];
        if (FactionNotifier().checkUnitForMashal(unit)) {
          unit.cohort.clear();
        }
        unit.cohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));
        if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);
        String cohortuuid = unit.cohort.last.product.uuid;
        unit.cohort.sort(
          (a, b) => a.product.name.compareTo(b.product.name),
        );
        for (int c = 0; c < unit.cohort.length; c++) {
          Cohort cohort = unit.cohort[c];
          if (cohort.product.uuid == cohortuuid) {
            _cohortindex = c;
            break;
          }
        }

        break;
      case 'oofjrcaster':
        for (var jr in _armyList.leadergroup[leaderindex!].oofjrcasters) {
          if (jr.leader.uuid == _selectedcasterProduct.uuid) {
            if (FactionNotifier().checkProductForMarshal(jr.leader)) {
              jr.cohort.clear();
            }
            jr.cohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));
            if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);
            String cohortuuid = jr.cohort.last.product.uuid;
            jr.cohort.sort((a, b) => a.product.name.compareTo(b.product.name));
            for (int c = 0; c < jr.cohort.length; c++) {
              Cohort cohort = jr.cohort[c];
              if (cohort.product.uuid == cohortuuid) {
                _cohortindex = c;
                break;
              }
            }
            break;
          }
        }
        break;
      case 'oofunit':
        for (var u in _armyList.leadergroup[leaderindex!].oofunits) {
          if (u.unit.uuid == _selectedcasterProduct.uuid) {
            u.cohort.clear();
            u.cohort.add(Cohort(product: Product.copyProduct(cohort.product, false), selectedOptions: cohort.selectedOptions));
            if (cohort.product.models[0].modularoptions != null && cohort.selectedOptions!.isEmpty) fillCohortOptions(cohort);
          }
        }
        break;
      default:
        break;
    }
    updateEverything();
  }

  fillCohortOptions(Cohort cohort) {
    if (cohort.product.models[0].modularoptions!.isNotEmpty) {
      {
        for (var element in cohort.product.models[0].modularoptions!) {
          if (element.options!.length != 1) {
            cohort.selectedOptions!.add(blankOption);
          } else {
            cohort.selectedOptions!.add(element.options![0]);
          }
        }
      }
    }
  }

  removeCohort(int index, int cohortindex, String type, bool oof, int? oofleaderindex) {
    switch (type) {
      case 'warcaster':
        _armyList.leadergroup[index].cohort.removeAt(cohortindex);
        break;
      case 'oofcohort':
        _armyList.leadergroup[index].oofcohort.removeAt(cohortindex);
        break;
      case 'jrcaster':
        _armyList.jrcasters[index].cohort.removeAt(cohortindex);
        break;
      case 'unit':
        _armyList.units[index].cohort.removeAt(cohortindex);
        break;
      case 'oofjrcaster':
        _armyList.leadergroup[oofleaderindex!].oofjrcasters[index].cohort.removeAt(cohortindex);
        break;
      case 'oofunit':
        _armyList.leadergroup[oofleaderindex!].oofunits[index].cohort.removeAt(cohortindex);
        break;
      default:
        break;
    }
    updateEverything();
  }

  setCohortOption(Option option, int groupindex, int? leaderindex) {
    switch (_leadertype) {
      case 'warcaster':
        _armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'oofcohort':
        _armyList.leadergroup[_cohortleaderindex].oofcohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'jrcaster':
        _armyList.jrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'unit':
        _armyList.units[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'oofjrcaster':
        _armyList.leadergroup[leaderindex!].oofjrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      case 'oofunit':
        _armyList.leadergroup[leaderindex!].oofunits[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] = option;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  removeCohortOption(int index, int cohortindex, int optionindex, String type, int? leaderindex) {
    switch (type) {
      case 'warcaster':
        _armyList.leadergroup[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'oofcohort':
        _armyList.leadergroup[index].oofcohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'jrcaster':
        _armyList.jrcasters[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'unit':
        _armyList.units[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'oofjrcaster':
        _armyList.leadergroup[leaderindex!].oofjrcasters[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      case 'oofunit':
        _armyList.leadergroup[leaderindex!].oofunits[index].cohort[cohortindex].selectedOptions![optionindex] = blankOption;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  addSolo(Product product, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.solos.add(Product.copyProduct(product, false));
      _armyList.solos.sort(
        (a, b) => a.name.compareTo(b.name),
      );
    } else {
      if (_armyList.leadergroup[leaderindex!].oofjrcasters.length + _armyList.leadergroup[leaderindex].oofsolos.length >= 3) {
        if (_armyList.leadergroup[leaderindex].oofsolos.isNotEmpty) {
          //remove the last one to add the jr (limit 3)
          _armyList.leadergroup[leaderindex].oofsolos.removeLast();
        } else {
          _armyList.leadergroup[leaderindex].oofjrcasters.removeLast();
        }
      }
      _armyList.leadergroup[leaderindex].oofsolos.add(Product.copyProduct(product, false));
      _armyList.leadergroup[leaderindex].oofsolos.sort(
        (a, b) => a.name.compareTo(b.name),
      );
    }
    updateEverything();
  }

  removeSolo(Product product, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.solos.remove(product);
    } else {
      _armyList.leadergroup[leaderindex!].oofsolos.remove(product);
    }
    updateEverything();
  }

  addUnit(Unit unit, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.units.add(unit);
      _armyList.units.last.unit.uuid = const Uuid().v1();
      _armyList.units.last.hasMarshal = FactionNotifier().checkUnitForMashal(unit);
      _armyList.units.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(unit.unit.name);
      if (_armyList.units.last.hasMarshal) {
        updateCasterCount(1);
        updateSelectedCaster('unit', _armyList.units.last.unit);
      }
      _armyList.units.sort(
        (a, b) => a.unit.name.compareTo(b.unit.name),
      );
    } else {
      if (_armyList.leadergroup[leaderindex!].oofunits.length >= 2) {
        _armyList.leadergroup[leaderindex].oofunits.removeLast();
      }
      _armyList.leadergroup[leaderindex].oofunits.add(unit);
      _armyList.leadergroup[leaderindex].oofunits.last.unit.uuid = const Uuid().v1();
      _armyList.leadergroup[leaderindex].oofunits.last.hasMarshal = FactionNotifier().checkUnitForMashal(unit);
      _armyList.leadergroup[leaderindex].oofunits.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(unit.unit.name);
      if (_armyList.leadergroup[leaderindex].oofunits.last.hasMarshal) {
        updateCasterCount(1);
        updateSelectedCaster('unit', _armyList.leadergroup[leaderindex].oofunits.last.unit);
      }
      _armyList.leadergroup[leaderindex].oofunits.sort(
        (a, b) => a.unit.name.compareTo(b.unit.name),
      );
    }
    updateEverything();
  }

  removeUnit(int unitnum, bool oof, int? leaderindex) {
    if (!oof) {
      if (FactionNotifier().checkUnitForMashal(_armyList.units[unitnum])) {
        //unit had jack marshal so reduce caster count
        updateCasterCount(-1);
      }
      _armyList.units.removeAt(unitnum);
    } else {
      if (FactionNotifier().checkUnitForMashal(_armyList.leadergroup[leaderindex!].oofunits[unitnum])) {
        //unit had jack marshal so reduce caster count
        updateCasterCount(-1);
      }
      _armyList.leadergroup[leaderindex].oofunits.removeAt(unitnum);
    }
    updateEverything();
  }

  updateUnitSize(int unitnum, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.units[unitnum].minsize = !_armyList.units[unitnum].minsize;
    } else {
      _armyList.leadergroup[leaderindex!].oofunits[unitnum].minsize = !_armyList.leadergroup[leaderindex].oofunits[unitnum].minsize;
    }
    calculatePoints();
    notifyListeners();
  }

  setUnitCommandAttachment(Product product, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.units[_addToIndex].commandattachment = Product.copyProduct(product, false);
      _armyList.units[_addToIndex].hasMarshal = FactionNotifier().checkUnitForMashal(_armyList.units[_addToIndex]);
      if (_armyList.units[_addToIndex].hasMarshal) {
        updateCasterCount(1);
        updateSelectedCaster('unit', _armyList.units[_addToIndex].unit);
      }
    } else {
      _armyList.leadergroup[leaderindex!].oofunits[_addToIndex].commandattachment = Product.copyProduct(product, false);
      _armyList.leadergroup[leaderindex].oofunits[_addToIndex].hasMarshal =
          FactionNotifier().checkUnitForMashal(_armyList.leadergroup[leaderindex].oofunits[_addToIndex]);
      if (_armyList.leadergroup[leaderindex].oofunits[_addToIndex].hasMarshal) {
        updateCasterCount(1);
        updateSelectedCaster('oofunit', _armyList.leadergroup[leaderindex].oofunits[_addToIndex].unit);
      }
    }
    //Ranking Officers
    switch (product.name) {
      case 'Koldun Kapitan Valachev':
        _armyList.units[_addToIndex].unit =
            Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Mercenary", "Khador"), true);
        break;
      case 'Captain Jonas Murdoch':
        _armyList.units[_addToIndex].unit =
            Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Mercenary", "Cygnar"), true);
        break;
      case 'Cephalyx Dominator':
        _armyList.units[_addToIndex].unit =
            Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Mercenary", "Cephalyx"), true);
        break;
      case 'Doctor Alejandro Mosby':
        _armyList.units[_addToIndex].unit =
            Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Mercenary", "Crucible Guard"), true);
        break;
      default:
        break;
    }
    updateEverything();
  }

  removeUnitCommandAttachment(int unitnum, bool oof, int? leaderindex) {
    //Ranking Officers

    if (!oof) {
      switch (_armyList.units[unitnum].commandattachment.name) {
        case 'Koldun Kapitan Valachev':
          _armyList.units[_addToIndex].unit =
              Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Khador", "Mercenary"), true);
          break;
        case 'Captain Jonas Murdoch':
          _armyList.units[_addToIndex].unit =
              Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Cygnar", "Mercenary"), true);
          break;
        case 'Cephalyx Dominator':
          _armyList.units[_addToIndex].unit =
              Product.copyProduct(FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Cephalyx", "Mercenary"), true);
          break;
        case 'Doctor Alejandro Mosby':
          _armyList.units[_addToIndex].unit = Product.copyProduct(
              FactionNotifier().changeModelFactionInTitles(_armyList.units[_addToIndex].unit, "Crucible Guard", "Mercenary"), true);
          break;
        default:
          break;
      }
      if (FactionNotifier().checkProductForMarshal(_armyList.units[unitnum].commandattachment) &&
          !FactionNotifier().checkProductForMarshal(_armyList.units[unitnum].unit)) {
        //command attachment had marshal but the unit itself does not so reduce caster count
        updateCasterCount(-1);
      }
      _armyList.units[unitnum].commandattachment = blankproduct;
    } else {
      switch (_armyList.leadergroup[leaderindex!].oofunits[unitnum].commandattachment.name) {
        case 'Koldun Kapitan Valachev':
          _armyList.units[_addToIndex].unit = Product.copyProduct(
              FactionNotifier().changeModelFactionInTitles(_armyList.leadergroup[leaderindex].oofunits[unitnum].unit, "Khador", "Mercenary"), true);
          break;
        case 'Captain Jonas Murdoch':
          _armyList.units[_addToIndex].unit = Product.copyProduct(
              FactionNotifier().changeModelFactionInTitles(_armyList.leadergroup[leaderindex].oofunits[unitnum].unit, "Cygnar", "Mercenary"), true);
          break;
        case 'Cephalyx Dominator':
          _armyList.units[_addToIndex].unit = Product.copyProduct(
              FactionNotifier().changeModelFactionInTitles(_armyList.leadergroup[leaderindex].oofunits[unitnum].unit, "Cephalyx", "Mercenary"), true);
          break;
        case 'Doctor Alejandro Mosby':
          _armyList.units[_addToIndex].unit = Product.copyProduct(
              FactionNotifier().changeModelFactionInTitles(_armyList.leadergroup[leaderindex].oofunits[unitnum].unit, "Crucible Guard", "Mercenary"),
              true);
          break;
        default:
          break;
      }
      if (FactionNotifier().checkProductForMarshal(_armyList.leadergroup[leaderindex].oofunits[unitnum].commandattachment) &&
          !FactionNotifier().checkProductForMarshal(_armyList.leadergroup[leaderindex].oofunits[unitnum].unit)) {
        //command attachment had marshal but the unit itself does not so reduce caster count
        updateCasterCount(-1);
      }
      _armyList.leadergroup[leaderindex].oofunits[unitnum].commandattachment = blankproduct;
    }
    updateEverything();
  }

  addUnitWeaponAttachment(Product product, bool oof, int? leaderindex) {
    //set weapon attachment limit to value determined by size of unit.
    //this is really only applicable to the newer Mk4 units with modular attachments
    if (!oof) {
      int walimit = _armyList.units[_addToIndex].minsize
          ? _armyList.units[_addToIndex].weaponattachmentlimits[0]
          : _armyList.units[_addToIndex].weaponattachmentlimits[1];
      if (_armyList.units[_addToIndex].weaponattachments.length < walimit) {
        _armyList.units[_addToIndex].weaponattachments.add(Product.copyProduct(product, false));
      }
    } else {
      int walimit = _armyList.leadergroup[leaderindex!].oofunits[_addToIndex].minsize
          ? _armyList.leadergroup[leaderindex].oofunits[_addToIndex].weaponattachmentlimits[0]
          : _armyList.leadergroup[leaderindex].oofunits[_addToIndex].weaponattachmentlimits[1];
      if (_armyList.leadergroup[leaderindex].oofunits[_addToIndex].weaponattachments.length < walimit) {
        _armyList.leadergroup[leaderindex].oofunits[_addToIndex].weaponattachments.add(Product.copyProduct(product, false));
      }
    }
    updateEverything();
  }

  removeUnitWeaponAttachment(Product product, int unitnum, bool oof, int? leaderindex) {
    if (!oof) {
      _armyList.units[unitnum].weaponattachments.remove(product);
    } else {
      _armyList.leadergroup[leaderindex!].oofunits[unitnum].weaponattachments.remove(product);
    }
    updateEverything();
  }

  addBattleEngine(Product product) {
    _armyList.battleengines.add(Product.copyProduct(product, false));
    _armyList.battleengines.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    updateEverything();
  }

  removeBattleEngine(Product product) {
    _armyList.battleengines.remove(product);
    updateEverything();
  }

  addStructure(Product product) {
    _armyList.structures.add(Product.copyProduct(product, false));
    _armyList.structures.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    updateEverything();
  }

  removeStructure(Product product) {
    _armyList.structures.remove(product);
    updateEverything();
  }

  addJrCaster(Product product, bool oof, int? leaderindex) async {
    Product addedProduct = blankproduct;
    // for (var ab in product.models[0].characterabilities!) {
    //   if (ab.name.toLowerCase().contains('limited battlegroup')) {
    //     product.selectable = false;
    //   }
    // }

    bool separatemodels = false;
    if (product.models.length > 1) {
      for (var m in product.models) {
        if (m.title.toLowerCase().contains('warjack') || m.title.toLowerCase().contains('warbeast') || m.title.toLowerCase().contains('horror')) {
          separatemodels = true;
        }
      }
    }

    if (separatemodels) {
      //has cohorts
      Product caster = Product.copyProduct(product, false);
      addedProduct = caster;
      caster.models.removeRange(1, caster.models.length);

      if (!oof) {
        _armyList.jrcasters.add(JrCasterGroup(leader: caster, cohort: []));
      } else {
        if (_armyList.leadergroup[leaderindex!].oofjrcasters.length + _armyList.leadergroup[leaderindex].oofsolos.length >= 3) {
          if (_armyList.leadergroup[leaderindex].oofsolos.isNotEmpty) {
            //remove the last one to add the jr (limit 3)
            _armyList.leadergroup[leaderindex].oofsolos.removeLast();
          } else {
            _armyList.leadergroup[leaderindex].oofjrcasters.removeLast();
          }
        }
        _armyList.leadergroup[leaderindex].oofjrcasters.add(JrCasterGroup(leader: caster, cohort: []));
      }

      Product additionalmodels = Product.copyProduct(product, false);
      additionalmodels.models.removeAt(0);
      for (var m in additionalmodels.models) {
        Product copy = ArmyListNotifier().blankproduct;
        copy.fanum = 0;
        copy.name = m.modelname;
        copy.points = '0';
        copy.fa = 'C';
        copy.category = 'Warjacks/Warbeasts/Horrors';
        copy.factions = [_armyList.listfaction];
        copy.primaryFaction = [_armyList.listfaction];
        copy.models.add(m);
        copy.removable = false;
        Cohort thiscohort = Cohort(product: copy, selectedOptions: []);
        if (!oof) {
          _armyList.jrcasters.last.cohort.add(thiscohort);
        } else {
          _armyList.leadergroup[leaderindex!].oofjrcasters.last.cohort.add(thiscohort);
        }
      }
    } else {
      if (!oof) {
        _armyList.jrcasters.add(JrCasterGroup(leader: Product.copyProduct(product, false), cohort: []));
        addedProduct = _armyList.jrcasters.last.leader;
      } else {
        if (_armyList.leadergroup[leaderindex!].oofjrcasters.length + _armyList.leadergroup[leaderindex].oofsolos.length >= 3) {
          if (_armyList.leadergroup[leaderindex].oofsolos.isNotEmpty) {
            //remove the last one to add the jr (limit 3)
            _armyList.leadergroup[leaderindex].oofsolos.removeLast();
          } else {
            _armyList.leadergroup[leaderindex].oofjrcasters.removeLast();
          }
        }
        _armyList.leadergroup[leaderindex].oofjrcasters.add(JrCasterGroup(leader: Product.copyProduct(product, false), cohort: []));
        addedProduct = _armyList.leadergroup[leaderindex].oofjrcasters.last.leader;
      }
    }
    int jrcasterindex = -1;
    if (!oof) {
      _armyList.jrcasters.sort((a, b) => a.leader.name.compareTo(b.leader.name));
      jrcasterindex = _armyList.leadergroup.length + _armyList.jrcasters.indexWhere((element) => element.leader.uuid == addedProduct.uuid);
    } else {
      _armyList.leadergroup[leaderindex!].oofjrcasters.sort((a, b) => a.leader.name.compareTo(b.leader.name));
      jrcasterindex = getJrIndex(addedProduct);
    }
    updateCasterCount(1);
    if (product.selectable) {
      updateSelectedCaster(!oof ? 'jrcaster' : 'oofjrcaster', addedProduct);
    }
    updateEverything();
  }

  removeJrCaster(int jrindex, bool oof, int? oofleaderindex) {
    if (!oof) {
      JrCasterGroup jrgroup = _armyList.jrcasters[jrindex];
      _armyList.jrcasters.remove(jrgroup);
    } else {
      JrCasterGroup jrgroup = _armyList.leadergroup[oofleaderindex!].oofjrcasters[jrindex];
      _armyList.leadergroup[oofleaderindex].oofjrcasters.remove(jrgroup);
    }
    updateCasterCount(-1);
    updateEverything();
  }

  removeJrCohort(Cohort cohort, int jrindex, bool oof, int? oofleaderindex) {
    if (!oof) {
      _armyList.jrcasters[jrindex].cohort.remove(cohort);
    } else {
      _armyList.leadergroup[oofleaderindex!].oofjrcasters[jrindex].cohort.remove(cohort);
    }
    updateEverything();
  }

  removeUnitCohort(Cohort cohort, int unitindex, bool oof, int? oofleaderindex) {
    if (!oof) {
      _armyList.units[unitindex].cohort.remove(cohort);
    } else {
      _armyList.leadergroup[oofleaderindex!].oofunits[unitindex].cohort.remove(cohort);
    }
    updateEverything();
  }

  setLeaderAttachment(Product product) {
    if (_armyList.leadergroup.isNotEmpty && _armyList.leadergroup.length - 1 >= _selectedcaster) {
      if (_armyList.leadergroup[_selectedcaster].leader.name != '') {
        _armyList.leadergroup[_selectedcaster].leaderattachment = Product.copyProduct(product, false);
      }
    }
    updateEverything();
  }

  removeLeaderAttachment(int casterindex) {
    _armyList.leadergroup[casterindex].leaderattachment = blankproduct;
    updateEverything();
  }

  setCohortVals(int casterindex, int cohortindex, String type) {
    _cohortleaderindex = casterindex;
    _cohortindex = cohortindex;
    _leadertype = type;
  }

  calculatePoints() {
    _currentpoints = 0;
    for (var a = 0; a < _armyList.leadergroup.length; a++) {
      int bgp = 0;
      int leaderpoints = int.parse(_armyList.leadergroup[a].leader.points!);
      if (_armyList.leadergroup[a].leaderattachment.name != '') {
        _currentpoints += int.parse(_armyList.leadergroup[a].leaderattachment.points!);
      }
      if (_armyList.leadergroup[a].spellrack!.isNotEmpty) {
        for (var sp in _armyList.leadergroup[a].spellrack!) {
          int cost = int.parse(sp.poolcost!);
          if (bgp < leaderpoints) {
            bgp += cost;
            if (bgp > leaderpoints) {
              _currentpoints = _currentpoints + (bgp - leaderpoints);
            }
          } else {
            _currentpoints += cost;
          }
        }
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

      for (var c in _armyList.leadergroup[a].oofcohort) {
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

      for (var jr in _armyList.leadergroup[a].oofjrcasters) {
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

      for (var s in _armyList.leadergroup[a].oofsolos) {
        _currentpoints += int.parse(s.points!);
      }

      for (var u in _armyList.leadergroup[a].oofunits) {
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
      if (_armyList.leadergroup[groupnum].spellrack!.isNotEmpty) {
        for (var sp in _armyList.leadergroup[groupnum].spellrack!) {
          bgp += int.parse(sp.poolcost!);
        }
      }
      for (var c in _armyList.leadergroup[groupnum].cohort) {
        if (c.product.points != '*') {
          bgp += int.parse(c.product.points!);
        } else {
          for (var o in c.selectedOptions!) {
            bgp += int.parse(o.cost);
          }
        }
      }
      for (var c in _armyList.leadergroup[groupnum].oofcohort) {
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
      case '':
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

        //out of faction jr casters
        for (JrCasterGroup jr in lg.oofjrcasters.reversed) {
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

        //out of faction solos
        for (var s in lg.oofsolos.reversed) {
          //solos should only be one model so no need to loop through all the models
          modelname = faName(s.models[0].modelname);
          if (s.name == product.name || s.models[0].modelname.contains(fa) || fa.contains(modelname)) {
            return s.fanum >= limit;
          }
        }

        //out of faction units
        for (var u in lg.oofunits.reversed) {
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

        //loop through each FA C out of faction cohort model
        for (Cohort c in lg.oofcohort) {
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

        //repeat for each out of faction jr caster
        for (JrCasterGroup jr in lg.oofjrcasters) {
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

        //loop through each FA C unit
        for (Unit u in lg.oofunits) {
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

        //loop through each FA C solo
        for (Product s in lg.oofsolos) {
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
      for (Product st in army.structures) {
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
        for (Cohort c in lg.oofcohort) {
          //loop through each no C cohort
          if (c.product.fa != 'C' && c.product.name == product.name) count += 1;
        }
        for (JrCasterGroup jr in lg.oofjrcasters) {
          if (jr.leader.name == product.name) count += 1;
          for (Cohort c in jr.cohort) {
            if (c.product.fa != 'C' && c.product.name == product.name) count += 1;
          }
        }

        for (Product s in lg.oofsolos) {
          if (s.fa != 'C' && s.name == product.name) count += 1;
        }

        for (Unit u in lg.oofunits) {
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
      heartofdarkness: _armyList.heartofdarkness,
      flamesinthedarkness: _armyList.flamesinthedarkness,
    );

    for (var g in _armyList.leadergroup) {
      newarmy.leadergroup.add(LeaderGroup(
        leader: blankproduct,
        leaderattachment: blankproduct,
        cohort: [],
        spellrack: g.spellrack!,
        spellracklimit: g.spellracklimit!,
        oofcohort: [],
        oofjrcasters: [],
        oofsolos: [],
        oofunits: [],
        heartofdarkness: g.heartofdarkness,
        heartofdarknessfaction: g.heartofdarknessfaction,
        flamesinthedarkness: g.flamesinthedarkness,
      ));
      if (g.leader.name != '') {
        newarmy.leadergroup.last.leader = Product.copyProduct(g.leader, true);
        newarmy.leadergroup.last.leader.fanum = calculateFA(newarmy, g.leader);
      }
      if (g.leaderattachment.name != '') {
        newarmy.leadergroup.last.leaderattachment = Product.copyProduct(g.leaderattachment, true);
        newarmy.leadergroup.last.leaderattachment.fanum = calculateFA(newarmy, g.leaderattachment);
      }
      for (var c in g.cohort) {
        newarmy.leadergroup.last.cohort.add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
        newarmy.leadergroup.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
      }
      for (var c in g.oofcohort) {
        newarmy.leadergroup.last.oofcohort.add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
        newarmy.leadergroup.last.oofcohort.last.product.fanum = calculateFA(newarmy, c.product);
      }
      for (var jr in g.oofjrcasters) {
        newarmy.leadergroup.last.oofjrcasters.add(JrCasterGroup(leader: blankproduct, cohort: []));
        newarmy.leadergroup.last.oofjrcasters.last.leader = Product.copyProduct(jr.leader, true);
        newarmy.leadergroup.last.oofjrcasters.last.leader.fanum = calculateFA(newarmy, jr.leader);
        for (var c in jr.cohort) {
          newarmy.leadergroup.last.oofjrcasters.last.cohort
              .add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
          newarmy.leadergroup.last.oofjrcasters.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
        }
      }
      for (var s in g.oofsolos) {
        newarmy.leadergroup.last.oofsolos.add(Product.copyProduct(s, true));
        newarmy.leadergroup.last.oofsolos.last.fanum = calculateFA(newarmy, s);
      }
      for (var u in g.oofunits) {
        newarmy.leadergroup.last.oofunits.add(Unit(
          unit: blankproduct,
          minsize: u.minsize,
          hasMarshal: false,
          commandattachment: blankproduct,
          weaponattachments: [],
          cohort: [],
          weaponattachmentlimits: [],
        ));
        newarmy.leadergroup.last.oofunits.last.unit = Product.copyProduct(u.unit, true);
        newarmy.leadergroup.last.oofunits.last.unit.fanum = calculateFA(newarmy, u.unit);
        if (u.commandattachment.name != '') {
          newarmy.leadergroup.last.oofunits.last.commandattachment = Product.copyProduct(u.commandattachment, true);
          newarmy.leadergroup.last.oofunits.last.commandattachment.fanum = calculateFA(newarmy, u.commandattachment);
        }
        for (var wa in u.weaponattachments) {
          newarmy.leadergroup.last.oofunits.last.weaponattachments.add(Product.copyProduct(wa, true));
          newarmy.leadergroup.last.oofunits.last.weaponattachments.last.fanum = calculateFA(newarmy, wa);
        }
        newarmy.leadergroup.last.oofunits.last.hasMarshal = FactionNotifier().checkUnitForMashal(newarmy.leadergroup.last.oofunits.last);
        if (newarmy.leadergroup.last.oofunits.last.hasMarshal) {
          for (var c in u.cohort) {
            newarmy.leadergroup.last.oofunits.last.cohort
                .add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
            newarmy.leadergroup.last.oofunits.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
          }
        }
        newarmy.leadergroup.last.oofunits.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(u.unit.name);
      }
    }
    for (var jr in _armyList.jrcasters) {
      newarmy.jrcasters.add(JrCasterGroup(leader: blankproduct, cohort: []));
      newarmy.jrcasters.last.leader = Product.copyProduct(jr.leader, true);
      newarmy.jrcasters.last.leader.fanum = calculateFA(newarmy, jr.leader);
      for (var c in jr.cohort) {
        newarmy.jrcasters.last.cohort.add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
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
      newarmy.units.last.unit = Product.copyProduct(u.unit, true);
      newarmy.units.last.unit.fanum = calculateFA(newarmy, u.unit);
      if (u.commandattachment.name != '') {
        newarmy.units.last.commandattachment = Product.copyProduct(u.commandattachment, true);
        newarmy.units.last.commandattachment.fanum = calculateFA(newarmy, u.commandattachment);
      }
      for (var wa in u.weaponattachments) {
        newarmy.units.last.weaponattachments.add(Product.copyProduct(wa, true));
        newarmy.units.last.weaponattachments.last.fanum = calculateFA(newarmy, wa);
      }
      newarmy.units.last.hasMarshal = FactionNotifier().checkUnitForMashal(newarmy.units.last);
      if (newarmy.units.last.hasMarshal) {
        for (var c in u.cohort) {
          newarmy.units.last.cohort.add(Cohort(product: Product.copyProduct(c.product, true), selectedOptions: c.selectedOptions));
          newarmy.units.last.cohort.last.product.fanum = calculateFA(newarmy, c.product);
        }
      }
      newarmy.units.last.weaponattachmentlimits = FactionNotifier().getUnitWeaponAttachLimit(u.unit.name);
    }
    for (var s in _armyList.solos) {
      newarmy.solos.add(Product.copyProduct(s, true));
      newarmy.solos.last.fanum = calculateFA(newarmy, s);
    }

    for (var be in _armyList.battleengines) {
      newarmy.battleengines.add(Product.copyProduct(be, true));
      newarmy.battleengines.last.fanum = calculateFA(newarmy, be);
    }
    for (var st in _armyList.structures) {
      newarmy.structures.add(Product.copyProduct(st, true));
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
      if (g.spellrack!.isNotEmpty) {
        for (var sp in g.spellrack!) {
          list.add('-Spell Rack: ${sp.name}');
        }
      }
      if (g.leaderattachment.name != '') {
        list.add('-${g.leaderattachment.name}');
      }
      for (var c in g.cohort) {
        list.add('-${c.product.name}');
      }

      for (var jr in g.oofjrcasters) {
        list.add(jr.leader.name);
        for (var c in jr.cohort) {
          list.add('-${c.product.name}');
        }
      }
      for (var s in g.oofsolos) {
        list.add(s.name);
      }
      for (var u in g.oofunits) {
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

  addSpellToSpellRack(Spell spell) {
    //check if the spell is already in the list
    if (_armyList.leadergroup[_selectedcaster].spellrack!.indexWhere((element) => element.name == spell.name) == -1) {
      if (_armyList.leadergroup[_selectedcaster].spellrack!.length < _armyList.leadergroup[_selectedcaster].spellracklimit!) {
        _armyList.leadergroup[_selectedcaster].spellrack!.add(spell);
        for (var m in _armyList.leadergroup[_selectedcaster].leader.models) {
          for (var ab in m.characterabilities!) {
            if (ab.name.contains('Spell Rack')) {
              m.spells!.add(spell);
              m.spells!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
              break;
            }
          }
        }
      } else {
        for (var m in _armyList.leadergroup[_selectedcaster].leader.models) {
          for (var ab in m.characterabilities!) {
            if (ab.name.contains('Spell Rack')) {
              m.spells!.remove(_armyList.leadergroup[_selectedcaster].spellrack!.last);
              m.spells!.add(spell);
              m.spells!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
              break;
            }
          }
        }
        _armyList.leadergroup[_selectedcaster].spellrack!.last = spell;
      }
      _armyList.leadergroup[_selectedcaster].spellrack!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      updateEverything();
    }
  }

  removeSpellFromSpellRack(int leaderindex, String spellname) {
    _armyList.leadergroup[leaderindex].spellrack!.removeWhere((element) => element.name == spellname);
    for (var m in _armyList.leadergroup[leaderindex].leader.models) {
      for (var ab in m.characterabilities!) {
        if (ab.name.contains('Spell Rack')) {
          m.spells!.removeWhere((element) => element.name == spellname);
          break;
        }
      }
    }
    notifyListeners();
  }

  bool checkIfOptionSelected(Option option, int groupindex, int? leaderindex) {
    switch (_leadertype) {
      case 'warcaster':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
            return true;
          }
        }
        break;
      case 'oofcohort':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].oofcohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.leadergroup[_cohortleaderindex].oofcohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
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
      case 'oofjrcaster':
        if (_armyList.leadergroup[leaderindex!].oofjrcasters.isNotEmpty) {
          if (_armyList.leadergroup[leaderindex].oofjrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost ==
                  option.cost &&
              _armyList.leadergroup[leaderindex].oofjrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name ==
                  option.name) {
            return true;
          }
        }
        break;
      case 'oofunit':
        if (_armyList.leadergroup[leaderindex!].oofunits.isNotEmpty) {
          if (_armyList.leadergroup[leaderindex].oofunits[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].cost == option.cost &&
              _armyList.leadergroup[leaderindex].oofunits[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex].name == option.name) {
            return true;
          }
        }
        break;
      default:
        return false;
    }
    return false;
  }

  bool checkIfAnyOptionSelected(int groupindex, int? leaderindex) {
    switch (_leadertype) {
      case 'warcaster':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      case 'oofcohort':
        if (_armyList.leadergroup.isNotEmpty) {
          if (_armyList.leadergroup[_cohortleaderindex].oofcohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
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
      case 'oofjrcaster':
        if (_armyList.leadergroup[leaderindex!].oofjrcasters.isNotEmpty) {
          if (_armyList.leadergroup[leaderindex].oofjrcasters[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      case 'oofunit':
        if (_armyList.leadergroup[leaderindex!].oofunits.isNotEmpty) {
          if (_armyList.leadergroup[leaderindex].oofunits[_cohortleaderindex].cohort[_cohortindex].selectedOptions![groupindex] != blankOption) {
            return true;
          }
        }
        break;
      default:
        return false;
    }
    return false;
  }

  resetList() {
    _armyList = ArmyList(
      name: '',
      listfaction: _armyList.listfaction,
      pointtarget: encounterLevelSelected['armypoints'].toString(),
      totalpoints: '0',
      favorite: false,
      leadergroup: [
        LeaderGroup(
          leader: blankproduct,
          leaderattachment: blankproduct,
          cohort: [],
          spellrack: [],
          spellracklimit: 0,
          oofcohort: [],
          oofjrcasters: [],
          oofsolos: [],
          oofunits: [],
          heartofdarkness: false,
          heartofdarknessfaction: '',
          flamesinthedarkness: false,
        )
      ],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
      heartofdarkness: false,
      flamesinthedarkness: false,
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

  clearList() {
    _armyList = ArmyList(
      name: '',
      listfaction: '',
      pointtarget: '',
      totalpoints: '0',
      favorite: false,
      leadergroup: [],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
      heartofdarkness: false,
      flamesinthedarkness: false,
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
    bool first = true;

    for (var g in list.leadergroup) {
      if (!first) export = '$export\n';
      if (g.leader.name != '') {
        export = '$export\n${g.leader.name} - BGP: +${g.leader.points}';
      }
      if (g.spellrack!.isNotEmpty) {
        for (var sp in g.spellrack!) {
          export = '$export\n- Spell Rack: ${sp.name} - PC: ${sp.poolcost!}';
        }
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
      for (var c in g.oofcohort) {
        export = '$export\n- ${c.product.name} - PC: ${c.product.points}';
        if (c.selectedOptions!.isNotEmpty) {
          for (var op in c.selectedOptions!) {
            export = '$export \n + ${op.name} - PC: ${op.cost}';
          }
        }
      }
      if (g.oofjrcasters.isNotEmpty) {
        export = '$export\n';
        for (var jr in g.oofjrcasters) {
          export = '$export\n ${jr.leader.name} - PC: ${jr.leader.points}';
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
      if (g.oofunits.isNotEmpty) {
        export = '$export\n';
        for (var u in g.oofunits) {
          export =
              '$export\n ${u.unit.name} - ${u.unit.unitPoints![u.minsize ? 'minunit' : 'maxunit']} - PC: ${u.unit.unitPoints![u.minsize ? 'mincost' : 'maxcost']}';
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
      if (g.oofsolos.isNotEmpty) {
        export = '$export\n';
        for (var s in g.oofsolos) {
          export = '$export\n ${s.name} - PC: ${s.points}';
        }
      }
      first = false;
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
      leadergroup: [
        LeaderGroup(
          leader: blankproduct,
          leaderattachment: blankproduct,
          cohort: [],
          spellrack: [],
          spellracklimit: 0,
          oofcohort: [],
          oofjrcasters: [],
          oofsolos: [],
          oofunits: [],
          heartofdarkness: false,
          heartofdarknessfaction: '',
          flamesinthedarkness: false,
        )
      ],
      solos: [],
      units: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
      heartofdarkness: false,
      flamesinthedarkness: false,
    );
    _castercount = 0;

    int firstcasterindex = -1;
    String firstcastertype = '';
    late Product firstcaster;
    setFactionSelected(army.listfaction);
    setEncounterLevel(AppData().encounterlevels.firstWhere((element) => element['armypoints'].toString() == army.pointtarget));
    setlistname(army.name);
    _armyList.name = army.name;
    _addToIndex = 0;
    for (var g = 0; g < army.leadergroup.length; g++) {
      LeaderGroup group = army.leadergroup[g];
      addLeaderandSelect(group.leader);
      if (firstcasterindex == -1) {
        firstcasterindex = g;
        firstcastertype = 'warcaster';
        firstcaster = army.leadergroup[g].leader;
      }
      army.leadergroup[g].spellracklimit = FactionNotifier().casterHasSpellRack(army.leadergroup[g].leader);
      if (army.leadergroup[g].spellrack != null) {
        for (var sp in army.leadergroup[g].spellrack!) {
          addSpellToSpellRack(sp);
        }
      }
      if (group.leaderattachment.name != '') setLeaderAttachment(group.leaderattachment);
      for (var c in group.cohort) {
        addCohort(c, g, false, g);
      }
      for (var c in group.oofcohort) {
        _selectedcastertype = 'oofcohort';
        addCohort(c, g, false, g);
      }
    }
    for (var jr = 0; jr < army.jrcasters.length; jr++) {
      JrCasterGroup group = army.jrcasters[jr];
      addJrCaster(group.leader, false, null);
      if (firstcasterindex == -1) {
        firstcasterindex = jr;
        firstcastertype = 'jrcaster';
        firstcaster = group.leader;
      }
      for (var c in group.cohort) {
        addCohort(c, jr, false, null);
      }
    }
    for (var u = 0; u < army.units.length; u++) {
      _addToIndex += u;
      if (u == 0 && _addToIndex != 0) _addToIndex++;
      Unit group = army.units[u];
      addUnit(group, false, null);
      if (group.hasMarshal) {
        if (firstcasterindex == -1) {
          firstcasterindex = u;
          firstcastertype = 'unit';
          firstcaster = group.unit;
        }
      }
    }
    for (var s = 0; s < army.solos.length; s++) {
      addModelToList(army.solos[s], false, null);
    }
    for (var be = 0; be < army.battleengines.length; be++) {
      _addToIndex = be;
      addModelToList(army.battleengines[be], false, null);
    }
    for (var st = 0; st < army.structures.length; st++) {
      _addToIndex = st;
      addModelToList(army.structures[st], false, null);
    }

    for (var g = 0; g < army.leadergroup.length; g++) {
      LeaderGroup group = army.leadergroup[g];
      for (var jr = 0; jr < group.oofjrcasters.length; jr++) {
        JrCasterGroup jrgroup = group.oofjrcasters[jr];
        addJrCaster(jrgroup.leader, true, g);
        if (firstcasterindex == -1) {
          firstcasterindex = jr;
          firstcastertype = 'oofjrcaster';
          firstcaster = jrgroup.leader;
        }
        for (var c in jrgroup.cohort) {
          addCohort(c, jr, true, g);
        }
      }

      for (var s = 0; s < group.oofsolos.length; s++) {
        addModelToList(group.oofsolos[s], true, g);
      }

      for (var u = 0; u < group.oofunits.length; u++) {
        _addToIndex += u;
        if (u == 0 && _addToIndex != 0) _addToIndex++;
        Unit unit = group.oofunits[u];
        addUnit(unit, true, g);
        if (unit.hasMarshal) {
          if (firstcasterindex == -1) {
            firstcasterindex = u;
            firstcastertype = 'oofunit';
            firstcaster = group.oofunits[u].unit;
          }
        }
      }
    }
    updateSelectedCaster(firstcastertype, firstcaster);
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
    notifyListeners();
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

  cancelDeployment() {
    _deploying = false;
    clearList();
    resetList();
    resetDeployedLists();
    resetHPListTracking();
    notifyListeners();
  }

  bool spellAtLimit(String spellname) {
    for (var sp in _armyList.leadergroup[_selectedcaster].spellrack!) {
      if (sp.name == spellname) return true;
    }
    return false;
  }
}
