import 'dart:convert';
import 'package:armybuilder/models/abilities.dart';
import 'package:armybuilder/models/modularoptions.dart';
import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/armylist.dart';
import '../models/cohort.dart';
import '../models/spells.dart';
import '../models/unit.dart';
import '../appdata.dart';

class FactionNotifier extends ChangeNotifier {
  late List<Map<String, dynamic>> _allFactions;
  late Map<String, String> _factionUpdateDates;
  late List<List<Product>> _filteredProducts; //used for category selected and filtering attachments to be displayed on categoryModelList
  late List<Option> _modularOptions;
  late int _selectedFactionIndex;
  late int _selectedCategory;
  late bool _showingoptions;
  late String _groupname;
  late List<ModularOption> _modeloptions;
  late List<Spell> _allSpells;
  late List<Spell> _filteredSpells;
  late String _spellsUpdateDate;

  List<Map<String, dynamic>> get allFactions => _allFactions;
  Map<String, String> get factionUpdateDates => _factionUpdateDates;
  int get selectedFactionIndex => _selectedFactionIndex;
  List<List<Product>> get filteredProducts => _filteredProducts;
  int get selectedCategory => _selectedCategory;
  String get groupname => _groupname;
  List<Option> get modularOptions => _modularOptions;
  bool get showingoptions => _showingoptions;
  List<ModularOption> get modeloptions => _modeloptions;
  List<Spell> get allSpells => _allSpells;
  List<Spell> get filteredSpells => _filteredSpells;
  String get spellsUpdateDate => _spellsUpdateDate;

  FactionNotifier() {
    _allFactions = [];
    _factionUpdateDates = {};
    _showingoptions = false;
    _selectedCategory = 0;
    _selectedFactionIndex = 0;
    _filteredProducts = [[], [], []]; //selected model type, 1 list of faction models, 1 list of allys, 1 of mercs
    _modularOptions = [];
    _groupname = '';
    _modeloptions = [];
    _allSpells = [];
    _filteredSpells = [];
    _spellsUpdateDate = '';
  }

  readAllFactions() async {
    int index = 0;
    List<String> groups = [
      'primary',
      'allies',
      'mercenaries',
    ];

    _allFactions.clear();

    for (Map<String, String> f in AppData().factionList) {
      List<List<Product>> factionProducts = [[], [], []];
      List<bool> factionHasCasterAttachments = [false, false, false];
      List<List<Map<String, List<Product>>>> ua = [
        [{}, {}],
        [{}, {}],
        [{}, {}]
      ];
      List<List<List<Product>>> products = [
        [[], [], [], [], [], [], [], []],
        [[], [], [], [], [], [], [], []],
        [[], [], [], [], [], [], [], []],
      ];
      String data = await rootBundle.loadString('json/${f['file'].toString().toLowerCase()}');
      var decodeddata = jsonDecode(data);
      if (decodeddata.containsKey('updated')) {
        _factionUpdateDates[f['name']!] = decodeddata['updated'];
      } else {
        _factionUpdateDates[f['name']!] = 'pending';
      }
      for (var g = 0; g < groups.length; g++) {
        for (var p in decodeddata['group'][g][groups[g]]['products']) {
          factionProducts[g].add(Product.fromJson(p));

          Product thisproduct = factionProducts[g].last;
          String attachname = '';
          index = AppData().productCategories.indexWhere((element) => element == thisproduct.category);

          if (index == -1 && thisproduct.models.isNotEmpty) {
            // print(thisproduct.name);
            for (var ab in thisproduct.models[0].characterabilities!) {
              if (ab.name == "Attached") {
                index = 6;
                factionHasCasterAttachments[g] = true;
                break;
              }
              if (ab.name.toLowerCase().contains('command attachment')) {
                index = 7;
                switch (p['name']) {
                  case 'Doctor Alejandro Mosby':
                    //small or medium based mercenary - Cygnar
                    attachname =
                        'Alexia Ciannor & the Risen,Captain Sam Machorne & the Devil Dogs,Croe\'s Cutthroats,Cylena Raefyll & Nyss Hunters,Dannon Blythe & Bull,Doom Reaver Swordsmen,Farrow Slaughterhousers,Gatorman Posse,Greygore Boomhowler & Co,Hammerfall High Shield Gun Corps,Herne & Jonne,Horgenhold Forge Guard,Idrian Skirmishers,Kayazy Assailers,Kayazy Assassins,Lady Aiyana & Master Holt,Ogrun Assault Corps,Press Gangers,Steelhead Cannon Crew,Steelhead Halberdiers,Steelhead Mortal Crew,Steelhead Riflemen,Steelhead Volley Gun Crew,Swamp Gobber Bellows Crew,Tactical Arcanist Corps,The Devil\'s Shadow Mutineers,Thorn Gun Mages';
                    break;
                  case 'Captain Jonas Murdoch':
                    //small or medium based mercenary - Crucible Guard
                    attachname =
                        'Alexia Ciannor & the Risen,Captain Sam Machorne & the Devil Dogs,Croe\'s Cutthroats,Cylena Raefyll & Nyss Hunters,Dannon Blythe & Bull,Doom Reaver Swordsmen,Farrow Slaughterhousers,Gatorman Posse,Greygore Boomhowler & Co,Hammerfall High Shield Gun Corps,Herne & Jonne,Horgenhold Forge Guard,Idrian Skirmishers,Kayazy Assailers,Kayazy Assassins,Lady Aiyana & Master Holt,Legion of Lost Souls,Ogrun Assault Corps,Order of Illumination Resolutes,Order of Illumination Vigilants,Precursor Knights,Press Gangers,Steelhead Cannon Crew,Steelhead Halberdiers,Steelhead Mortal Crew,Steelhead Riflemen,Steelhead Volley Gun Crew,Swamp Gobber Bellows Crew,Tactical Arcanist Corps,The Devil\'s Shadow Mutineers,Thorn Gun Mages';
                    break;
                  case 'Koldun Kapitan Valachev':
                    //small or medium based mercenary - Khador
                    attachname =
                        'Alexia Ciannor & the Risen,Captain Sam Machorne & the Devil Dogs,Croe\'s Cutthroats,Cylena Raefyll & Nyss Hunters,Dannon Blythe & Bull,Farrow Slaughterhousers,Gatorman Posse,Greygore Boomhowler & Co,Hammerfall High Shield Gun Corps,Herne & Jonne,Horgenhold Forge Guard,Idrian Skirmishers,Lady Aiyana & Master Holt,Legion of Lost Souls,Ogrun Assault Corps,Order of Illumination Resolutes,Order of Illumination Vigilants,Precursor Knights,Press Gangers,Steelhead Cannon Crew,Steelhead Halberdiers,Steelhead Mortal Crew,Steelhead Riflemen,Steelhead Volley Gun Crew,Swamp Gobber Bellows Crew,Tactical Arcanist Corps,The Devil\'s Shadow Mutineers,Thorn Gun Mages';
                    break;
                  case 'Cephalyx Dominator':
                    //small or medium based mercenary - Cephalyx
                    attachname =
                        'Alexia Ciannor & the Risen,Captain Sam Machorne & the Devil Dogs,Croe\'s Cutthroats,Cylena Raefyll & Nyss Hunters,Dannon Blythe & Bull,Doom Reaver Swordsmen,Farrow Slaughterhousers,Gatorman Posse,Greygore Boomhowler & Co,Hammerfall High Shield Gun Corps,Herne & Jonne,Horgenhold Forge Guard,Idrian Skirmishers,Kayazy Assailers,Kayazy Assassins,Lady Aiyana & Master Holt,Legion of Lost Souls,Ogrun Assault Corps,Order of Illumination Resolutes,Order of Illumination Vigilants,Precursor Knights,Press Gangers,Steelhead Cannon Crew,Steelhead Halberdiers,Steelhead Mortal Crew,Steelhead Riflemen,Steelhead Volley Gun Crew,Swamp Gobber Bellows Crew,Tactical Arcanist Corps,The Devil\'s Shadow Mutineers,Thorn Gun Mages';
                    break;
                  case 'Legionnaire Standard Bearer':
                    //small or medium based storm legion
                    attachname =
                        'Arcane Mechaniks,Storm Lance Legionnaires,Stormblade Legionnaires,Stormguard Legionnaires,Stormthrower Legionnaires';
                    break;
                  case 'Marauder Crew Bosun' || 'Marauder Crew Quartermaster' || 'Marauder Crew Tapper':
                    //medium based marauder crew
                    attachname = 'Marauder Crew';
                    break;
                  case 'Pyg Coxswain':
                    //small based pyg unit
                    attachname = 'Pyg Boarding Party,Pyg Burrowers,Pyg Bushwhackers,Pyg Galley Crew,Pyg Lookouts,Pyg Shockers';
                    break;
                  case 'Transverse Enumerator':
                    //non-character convergence
                    attachname = 'Clockwork Angels,Eradicators,Negation Angels,Obstructors,Optifex Directive,Perforators,Reciprocators,Reductors';
                    break;
                  case 'Tyrant Vorkesh':
                    //cataphract unit
                    attachname = 'Cataphract Arcuarii,Cataphract Cetrati,Cataphract Incindiarii';
                    break;
                  default:
                    attachname = ab.name.substring(ab.name.indexOf('['));
                    attachname = attachname.replaceAll('[', '').replaceAll(']', '');
                    break;
                }
              }
              if (ab.name.toLowerCase().contains('weapon attachment')) {
                index = 8;
                switch (p['name']) {
                  case 'Trollkin Sorcerer':
                    attachname =
                        'Dannon Blythe & Bull,Greygore Boomhowler & Co,Dhunian Knot,Kriel Warriors,KrielStone & Stone Scribes,Marauder Crew,Northkin Raiders,Scattergunners,Sons of Bragg,Trollkin Barrage Team,Trollkin Champions,Trollkin Fennblades,Trollkin Highwaymen,Trollkin Runeshapers,Trollkin Scouts,Strollkin Sluggers,Trollkin Warders';
                    break;
                  case 'Morrowan Battle Priest':
                    //small or medium based unit
                    attachname =
                        'Alexia Ciannor & the Risen,Captain Sam Machorne & the Devil Dogs,Croe\'s Cutthroats,Cylena Raefyll & Nyss Hunters,Dannon Blythe & Bull,Doom Reaver Swordsmen,Gatorman Posse,Greygore Boomhowler & Co,Hammerfall High Shield Gun Corps,Herne & Jonne,Horgenhold Forge Guard,Idrian Skirmishers,Kayazy Assassins,Lady Aiyana & Master Holt,Legion of Lost Souls,Order of Illumination Resolutes,Order of Illumination Vigilants,Precursor Knights,Press Gangers,Steelhead Cannon Crew,Steelhead Halberdiers,Steelhead Mortal Crew,Steelhead Riflemen,Steelhead Volley Gun Crew,Storm Vanes,Swamp Gobber Bellows Crew,Tactical Arcanist Corps,The Devil\'s Shadow Mutineers,Thorn Gun Mages,Arcane Mechaniks,Black 13th Strike Force,Field Mechaniks,Long Gunner Infantry,Order of the Arcane Tempest Gun Mage Pistoleers,Rangers,Silverline Stormguard,Storm Callers,Storm Lance Legionnaires,Stormblade Infantry,Stormblade Legionnaires,Stormguard Infantry,Stormguard Legionnaires,Stormsmith Grenadiers,Stormsmith Stormtower,Stormthrower Legionnaires,Sword Knights,Tempest Assailers,Tempest Thunderers,Trencher Cannon Crew,Trencher Chain Gun Crew,Trencher Combat Engineers,Trencher Commandos,Trencher Express Team,Trencher Infantry,Trencher Long Gunners';
                    break;
                  case 'Void Leech':
                    //blind water congregation unit
                    attachname =
                        'Bog Trog Ambushers,Boil Master & Spirit Cauldron,Croak Raiders,Croak Trappers,Fire Spitters,Gatorman Bokor & Bog Trog Swamp Shamblers,Gatorman Posse,Spirit Shamans,Swamp Gobber Bellows Crew';
                    break;
                  case 'Soulless Escort':
                    //any Ios unit
                    attachname =
                        'Dawnguard Destors,Dawnguard Invictors,Dawnguard Sentinels,Dreadguard Archers,Dreadguard Cavalry,Dreadguard Slayers,Heavy Rifle Team,House Ellowuyr Swordsman,House Ellowuyr Wardens,House Shyeel Arcanists,House Shyeel Battle Mages,House Vyre Electromancers,Houseguard Halberdiers,Houseguard Riflemen,Mage Hunter Assassins,Mage Hunter Infiltrators,Mage Hunter Rangers,Mage Hunter Strike Force,Ryssovass Defenders,Seeker Adepts,Soulless Blademasters,Soulless Guardians,Soulless Hunters,Spears of Scyrah,Stormfall Archers';
                    break;
                  case 'Cephalyx Domintor':
                    //small or medium based merc unit
                    break;
                  default:
                    attachname = ab.name.substring(ab.name.indexOf('['));
                    attachname = attachname.replaceAll('[', '').replaceAll(']', '');
                    break;
                }
              }
            }
          }

          if (index == -1) {
            print('error: ${thisproduct.name}');
          } else {
            if (index <= 6) {
              products[g][index].add(thisproduct);
              if (index == 6) {
                products[g][7].add(thisproduct);
              }
            } else {
              products[g][7].add(thisproduct);
              List<String> names = attachname.split(',');
              for (var n in names) {
                String name = n.trim();
                if (!ua[g][index - 7].containsKey(name)) {
                  ua[g][index - 7][name] = [thisproduct];
                } else {
                  ua[g][index - 7][name]!.add(thisproduct);
                }
              }
            }
          }
        }
      }
      _allFactions.add({
        'faction': '${f['name']}',
        'products': factionProducts,
        'hascasterattachments': factionHasCasterAttachments,
        'sortedproducts': products,
        'unitattachments': ua
      });
    }
  }

  resetLists() {
    _filteredProducts.clear();
    _filteredProducts = [[], [], []];
  }

  setSelectedFactionIndex(int value) {
    _selectedFactionIndex = value;
  }

  setBrowsingFaction(int index) {
    if (_selectedFactionIndex != index) {
      _selectedFactionIndex = index;
      setBrowsingCategory(_selectedCategory);
    }
  }

  setBrowsingCategory(int index) {
    _selectedCategory = index;
    _filteredProducts.clear();
    _filteredProducts = [[], [], []];

    _filteredProducts[0] = _allFactions[_selectedFactionIndex]['sortedproducts'][0][index];
    _filteredProducts[1] = _allFactions[_selectedFactionIndex]['sortedproducts'][1][index];
    _filteredProducts[2] = _allFactions[_selectedFactionIndex]['sortedproducts'][2][index];
    notifyListeners();
  }

  setSelectedCategory(int index, Product? selectedCaster, String? unitname, List<int>? casterFactionIndex, bool hod, int? oofFactionindex) {
    _selectedCategory = index;
    _filteredProducts.clear();
    _filteredProducts = [[], [], []];
    bool spellrack = false;
    List<int> factionindex = [];
    factionindex.add(_selectedFactionIndex); //to filter cohort lists

    String selectedfaction = AppData().factionList[_selectedFactionIndex]['name']!;
    bool infernalslist = AppData().factionList[_selectedFactionIndex]['name']! == 'Infernals';
    if (index <= 6 || index == 666 || index == 667 || index == 999) {
      switch (index) {
        case 1:
          //cohort
          // if (selectedCaster!.name != '' && AppData().limitedBattlegroup.contains(selectedCaster.name)) {
          //   setLimitedCohort(selectedCaster.name);
          // } else {
          if (casterFactionIndex != null) {
            factionindex.clear();
            factionindex.addAll(casterFactionIndex);
          }
          _filteredProducts[0].clear();
          ValidCohortList cohorts = selectedCaster!.validcohortmodels!.firstWhere((element) => element.factionchoice == selectedfaction);
          for (var p in cohorts.products) {
            for (var c in p['cohorts']) {
              Product product = findByName(c);
              _filteredProducts[0].add(product);
            }
          }
          switch (selectedCaster.name.toLowerCase()) {
            //special issue casters
            case 'midas':
              //add Boneswarm fron Blindwater Congregation
              //change it's faction to Thornfall Alliance
              //add keyword Farrow
              //change title to Thornfall Alliance Light Warbeast

              for (Product p in _filteredProducts[0]) {
                if (p.name == 'Boneswarm') {
                  Product product = changeModelFactionInTitles(p, 'Blindwater Congregation', selectedfaction);
                  product.models[0].keywords!.add('Farrow');
                  product.models[0].keywords!.sort(
                    (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                  );
                  // _filteredProducts[0].add(p);
                  _filteredProducts[0].remove(p);
                  _filteredProducts[0].add(product);
                  _filteredProducts[0].sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                  break;
                }
              }
              break;
            // case 'brigadier general gunnbjorn':
            //   //add Troll warbeasts if not a Troll list
            //   //change factions of both
            //   if (selectedfaction != 'Trollbloods') {
            //     //int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Trollbloods');
            //     for (Product p in selectedCaster!.validcohortmodels!) {
            //       Product product = changeModelFactionInTitles(p, 'Trollblood', selectedfaction);
            //       _filteredProducts[0].add(product);
            //     }
            //   }
            //   break;
            // case 'captain gunnbjorn':
            //   //   //add Troll warbeasts if not a troll list
            //   //   //change faction
            //   if (selectedfaction != 'Trollbloods') {
            //     // int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Trollbloods');
            //     for (Product p in selectedCaster!.validcohortmodels!) {
            //       Product product = changeModelFactionInTitles(p, 'Trollblood', selectedfaction);
            //       _filteredProducts[0].add(product);
            //     }
            //   }
            //   break;
            // case 'allister caine, leader of the hellslingers': //|| 'Captain Allister Caine' || 'Lieutenant Allister Caine'
            //   //   //add Ace if not a Cygnar list
            //   //   //change faction
            //   if (selectedfaction != 'Cygnar') {
            //     //int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Cygnar');
            //     for (Product p in selectedCaster!.validcohortmodels!) {
            //       if (p.name == 'Ace') {
            //         Product product = changeModelFactionInTitles(p, 'Cygnar', selectedfaction);
            //         _filteredProducts[0].add(product);
            //         break;
            //       }
            //     }
            //   }
            //   break;
            // case 'vladimir tzepesci, great prince of umbrey':
            //   //add Drago if not Khador list
            //   //change faction
            //   if (selectedfaction != 'Khador') {
            //     int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Khador');
            //     for (Product p in _allFactions[factionindex]['sortedproducts'][0][1]) {
            //       if (p.name == 'Drago') {
            //         Product product = changeModelFactionInTitles(p, 'Khador', selectedfaction);
            //         _filteredProducts[0].add(product);
            //         break;
            //       }
            //     }
            //   }
            //   break;
            default:
              // bool casteradept = selectedCaster.models[0].casteradeptfaction! != '';
              // bool heartofdarkness = selectedCaster.models[0].heartofdarknessfaction! != '';
              // if (casteradept && !infernalslist) {
              //   String adeptfaction = selectedCaster.models[0].casteradeptfaction!;
              //   //caster has caster adept and not an infernals list,
              //   //add all cohort from the designated faction
              //   if (!selectedfaction.toLowerCase().contains(adeptfaction)) {
              //     //if the selected faction does not contain the string found in the brackets of caster/warlock adept, add that faction
              //     int factionindex = _allFactions.indexWhere((element) => element['faction'].contains(adeptfaction));
              //     for (Product p in _allFactions[factionindex]['sortedproducts'][0][1]) {
              //       Product product = changeModelFactionInTitles(p, adeptfaction, selectedfaction);
              //       _filteredProducts[0].add(Product.copyProduct(product));
              //     }
              //   }
              // }
              bool heartofdarkness = selectedCaster.models[0].heartofdarknessfaction! != '';
              if (infernalslist && heartofdarkness) {
                //include only non-C cohort
                for (Product p in _filteredProducts[0]) {
                  if (p.fa != 'C' && p.models[0].title.toLowerCase().contains('warjack')) {
                    p.models[0].characterabilities!.add(Ability(
                      name: 'Accumulator [Soulless]',
                      description:
                          'When it begins its activation within 3" of one or more other friendly Soulless models, this model gains 1 focus point.',
                    ));
                  }
                  // if (p.models[0].title.toLowerCase().contains('horror')) {
                  //   p.models[0].characterabilities!.add(Ability(
                  //     name: 'Serenity',
                  //     description:
                  //         'At the beginning of your Control Phase, before leeching, you can remove 1 fury point from a friendly Faction warbeast within 1" of this model.',
                  //   ));
                  // }
                  p.models[0].characterabilities!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                }
              }
              break;
          }
          // }
          break;
        case 2:
          //solos
          copyFilteredProductsToCategory(index);
          switch (selectedCaster!.name.toLowerCase()) {
            case 'mortenebra, numen of necrogenesis':
              //add Necrotechs to solos
              if (selectedfaction != 'Cryx') {
                int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Cryx');
                for (Product p in _allFactions[factionindex]['sortedproducts'][0][2]) {
                  if (p.name == 'Necrotech') {
                    Product product = Product.copyProduct(p, false);
                    _filteredProducts[0].add(product);
                    break;
                  }
                }
              }
              break;
            case 'dr. egan arkadius':
              //add Necrotechs to solos
              int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Thornfall Alliance');
              for (Product p in _allFactions[factionindex]['sortedproducts'][0][2]) {
                if (p.name == 'Targ') {
                  Product product = Product.copyProduct(p, false);
                  _filteredProducts[0].add(product);
                  break;
                }
              }
              break;
            default:
              break;
          }
        case 3:
          //units
          copyFilteredProductsToCategory(index);
          switch (selectedCaster!.name.toLowerCase()) {
            case 'brigadier general gunnbjorn':
              //add Trollkin Barrage Team
              //change factions of both
              if (selectedfaction != 'Trollbloods') {
                int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Trollbloods');
                for (Product p in _allFactions[factionindex]['sortedproducts'][0][3]) {
                  if (p.name == 'Trollkin Barrage Team') {
                    Product product = Product.copyProduct(p, false);
                    _filteredProducts[0].add(product);
                    break;
                  }
                }
              }
              break;
            case 'cylena raefyll, guardian of nyssor':
              int factionindex = _allFactions.indexWhere((element) => element['faction'] == 'Ios');
              for (Product p in _allFactions[factionindex]['sortedproducts'][0][3]) {
                if (p.name == 'Cylena Raefyll & Nyss Hunters') {
                  Product product = Product.copyProduct(p, false);
                  product.models.removeAt(0); //remove Cylena
                  product.name = 'Nyss Hunters';
                  product.fa = '2';
                  product.factions = ['Khador'];
                  product.primaryFaction = ['Khador'];
                  product.unitPoints!['minunit'] = 'Leader and 5 Grunts';
                  product.unitPoints!['maxunit'] = 'Leader and 9 Grunts';
                  product.models[0].modelname = 'Leader and Grunts';
                  _filteredProducts[0].add(product);
                  break;
                }
              }
              break;
            case 'wurmwood, tree of fate and cassius':
              //change FA of Shifting Stones to +1
              for (Product p in _allFactions[selectedFactionIndex]['sortedproducts'][0][3]) {
                if (p.name == 'Shifting Stones') {
                  Product product = Product.copyProduct(p, false);
                  product.fa = '3'; //default is 2
                  _filteredProducts[0].add(product);
                  _filteredProducts.remove(p);
                  break;
                }
              }
              break;
            default:
              break;
          }
        case 666:
          //HoD solos
          for (Product p in _allFactions[oofFactionindex!]['sortedproducts'][0][2]) {
            if (validHeartofDarknessModel(p, oofFactionindex)) {
              Product product = Product.copyProduct(p, false);
              _filteredProducts[0].add(product);
            }
          }
          break;
        case 667:
          //HOD units
          for (Product p in _allFactions[oofFactionindex!]['sortedproducts'][0][3]) {
            if (validHeartofDarknessModel(p, oofFactionindex)) {
              Product product = Product.copyProduct(p, false);
              _filteredProducts[0].add(product);
            }
          }
          break;
        case 999:
          //spell rack
          spellrack = true;
          _filteredSpells.clear();
          for (var f in factionindex) {
            _filteredSpells.addAll(getFactionSpells(AppData().factionList[f]['name']!));
          }
          _filteredSpells.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        default:
          copyFilteredProductsToCategory(index);
      }

      if (!hod && !spellrack) {
        _filteredProducts[1] = _allFactions[_selectedFactionIndex]['sortedproducts'][1][index];
        _filteredProducts[2] = _allFactions[_selectedFactionIndex]['sortedproducts'][2][index];
      }
    } else if (unitname != null) {
      //unit attachments
      if (!hod) {
        if (_allFactions[_selectedFactionIndex]['unitattachments'][0][index - 7].containsKey(unitname)) {
          for (var p in _allFactions[_selectedFactionIndex]['unitattachments'][0][index - 7][unitname]!) {
            Product product = Product.copyProduct(p, true);
            _filteredProducts[0].add(product);
          }
        }
        if (_allFactions[_selectedFactionIndex]['unitattachments'][1][index - 7].containsKey(unitname)) {
          for (var p in _allFactions[_selectedFactionIndex]['unitattachments'][1][index - 7][unitname]!) {
            Product product = Product.copyProduct(p, true);
            _filteredProducts[1].add(product);
          }
        }
        if (_allFactions[_selectedFactionIndex]['unitattachments'][2][index - 7].containsKey(unitname)) {
          for (var p in _allFactions[_selectedFactionIndex]['unitattachments'][2][index - 7][unitname]!) {
            Product product = Product.copyProduct(p, true);
            _filteredProducts[2].add(product);
          }
        }
      } else {
        //index would be either 668 or 669 here
        if (_allFactions[oofFactionindex!]['unitattachments'][0][index - 668].containsKey(unitname)) {
          for (var p in _allFactions[oofFactionindex]['unitattachments'][0][index - 668][unitname]!) {
            if (validHeartofDarknessModel(p, oofFactionindex)) {
              Product product = Product.copyProduct(p, true);
              _filteredProducts[0].add(product);
            }
          }
        }
      }
    }
    if (!spellrack) {
      _showingoptions = false;
      _filteredProducts[0].sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _filteredProducts[1].sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _filteredProducts[2].sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    notifyListeners();
  }

  copyFilteredProductsToCategory(int categoryindex) {
    String currentfaction = AppData().factionList[_selectedFactionIndex]['name']!;
    for (var p in _allFactions[_selectedFactionIndex]['sortedproducts'][0][categoryindex]) {
      Product product = Product.copyProduct(p, false);
      if (product.primaryFaction.toString().contains(currentfaction)) {
        for (var m in product.models) {
          List<String> title = m.title.split(' ');
          String newtitle = '';
          if (title.last != 'Engine') {
            newtitle = '$currentfaction ${title.last}';
          } else {
            newtitle = '$currentfaction Battle Engine';
          }
          m.title = newtitle;
        }
      }
      _filteredProducts[0].add(Product.copyProduct(product, false));
    }
  }

  Product changeModelFactionInTitles(Product p, String baseFaction, String newFaction) {
    if (baseFaction == 'Trollbloods') baseFaction = 'Trollblood';
    Product product = Product.copyProduct(p, false);
    product.primaryFaction = [newFaction];
    product.factions = [newFaction];
    for (var m in product.models) {
      m.title = m.title.replaceAll(baseFaction, newFaction);
    }
    return product;
  }

  setShowModularGroupOptions(Product product) {
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
      if (m.characterabilities!.isNotEmpty) {
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
    return 0;
  }

  bool unitHasCommandAttachments(String unitname, bool oof, String? oofFaction) {
    if (!oof) {
      for (int g = 0; g < 3; g++) {
        if (_allFactions[_selectedFactionIndex]['unitattachments'][g][0].containsKey(unitname)) return true;
      }
    } else {
      int factionindex = _allFactions.indexWhere((element) => element['faction'].toString().toLowerCase() == oofFaction!.toLowerCase());
      if (_allFactions[factionindex]['unitattachments'][0][0].containsKey(unitname)) return true;
    }
    return false;
  }

  bool unitHasWeaponAttachments(String unitname, bool oof, String? oofFaction) {
    if (!oof) {
      for (int g = 0; g < 3; g++) {
        if (_allFactions[_selectedFactionIndex]['unitattachments'][g][1].containsKey(unitname)) return true;
      }
    } else {
      int factionindex = _allFactions.indexWhere((element) => element['faction'].toString().toLowerCase() == oofFaction!.toLowerCase());
      if (_allFactions[factionindex]['unitattachments'][0][1].containsKey(unitname)) return true;
    }
    return false;
  }

  List<int> getUnitWeaponAttachLimit(String unitname) {
    switch (unitname) {
      case 'Winter Korps Infantry':
        return [2, 4];
      default:
        return [3, 3];
    }
  }

  bool checkSoloForJourneyman(Product product) {
    for (var m in product.models) {
      if (m.characterabilities != null) {
        for (var ab in m.characterabilities!) {
          if (ab.name.toLowerCase().contains('journeyman warcaster') ||
              ab.name.toLowerCase().contains('journeyman warlock') ||
              ab.name.toLowerCase().contains('lesser warlock')) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool checkUnitForMashal(Unit unit) {
    for (var m in unit.unit.models) {
      if (m.hasMarshal!) return true;
    }
    if (unit.commandattachment.name != '') {
      for (var m in unit.commandattachment.models) {
        if (m.hasMarshal!) return true;
      }
      if (unit.weaponattachments.isNotEmpty) {
        for (var wa in unit.weaponattachments) {
          for (var m in wa.models) {
            if (m.hasMarshal!) return true;
          }
        }
      }
    }
    return false;
  }

  bool checkProductForMarshal(Product product) {
    for (var m in product.models) {
      if (m.hasMarshal!) return true;
    }
    return false;
  }

  bool checkProductForHeartofDarkness(Product product) {
    for (var m in product.models) {
      for (var ab in m.characterabilities!) {
        if (ab.name.toLowerCase().contains('heart of darkness')) {
          return true;
        }
      }
    }
    return false;
  }

  bool validHeartofDarknessModel(Product p, int oofFactionindex) {
    bool partisan = false;
    bool archon = p.name.toLowerCase().contains('archon');
    bool morrowan = false;
    for (var k in p.models[0].keywords!) {
      if (k.toLowerCase() == 'morrowan') morrowan = true;
    }
    for (var ab in p.models[0].characterabilities!) {
      if (ab.name.toLowerCase().contains('partisan') &&
          ab.name.toLowerCase().contains(AppData().factionList[oofFactionindex]['name']!.toLowerCase())) {
        partisan = true;
      }
    }
    return !partisan && !archon && !morrowan;
  }

  Product findByName(String name) {
    Product blankproduct = ArmyListNotifier().blankproduct;
    Product foundproduct = blankproduct;
    for (int f = 0; f < AppData().factionList.length; f++) {
      for (int g = 0; g < 3; g++) {
        foundproduct =
            Product.copyProduct(_allFactions[f]['products'][g].firstWhere((element) => element.name == name, orElse: () => blankproduct), false);
        if (foundproduct.name != '') {
          break;
        }
      }
      if (foundproduct.name != '') {
        break;
      }
    }
    return foundproduct;
  }

  Product trimTitleToSingleFaction(Product product, String faction) {
    Product p = Product.copyProduct(product, true);
    for (var m in p.models) {
      List<String> title = m.title.split(' ');
      if (title.last != 'Engine') {
        m.title = '$faction ${title.last}';
      } else {
        m.title = '$faction Battle Engine';
      }
    }

    return p;
  }

  Future<ArmyList> convertJsonStringToArmyList(String productlist) async {
    Map<String, dynamic> list = jsonDecode(productlist);
    ArmyList army = ArmyList(
      name: list['name'],
      listfaction: list['faction'],
      totalpoints: list['totalpoints'],
      pointtarget: list['pointtarget'],
      favorite: false,
      leadergroup: [],
      units: [],
      solos: [],
      battleengines: [],
      structures: [],
      jrcasters: [],
      heartofdarkness: false,
    );
    String listfaction = army.listfaction;
    bool infernalslist = listfaction == 'Infernals';

    if (list.containsKey('leadergroups')) {
      for (Map<String, dynamic> lg in list['leadergroups']) {
        LeaderGroup group = LeaderGroup(
          leader: ArmyListNotifier().blankproduct,
          leaderattachment: ArmyListNotifier().blankproduct,
          cohort: [],
          spellrack: [],
          oofjrcasters: [],
          oofsolos: [],
          oofunits: [],
          spellracklimit: 0                    
        );
        group.leader = trimTitleToSingleFaction(findByName(lg['leader']), list['faction']);

        bool casteradept = false;
        String adeptfaction = '';
        bool heartofdarkness = false; //should only be checked if true if it's an infernal list
        String heartofdarknessfaction = '';

        if (group.leader.models.isNotEmpty) {
          if (group.leader.models[0].characterabilities!.isNotEmpty) {
            for (var ab in group.leader.models[0].characterabilities!) {
              if (ab.name.toLowerCase().contains('caster adept') || ab.name.toLowerCase().contains('warlock adept')) {
                adeptfaction = ab.name.substring(ab.name.indexOf('[') + 1, ab.name.length - 1);
                casteradept = true;
              }
              if (ab.name.toLowerCase().contains('heart of darkness')) {
                heartofdarknessfaction = ab.name.substring(ab.name.indexOf('[') + 1, ab.name.length - 1);
                heartofdarkness = true;
                army.heartofdarkness = true;
              }
            }
          }
        }

        if (lg.containsKey('spellracklimit')) {
          group.spellracklimit = FactionNotifier().casterHasSpellRack(group.leader);
        }

        if (lg.containsKey('spellrack')) {
          for (var sp in lg['spellrack']) {
            group.spellrack!.add(_allSpells.firstWhere((element) => element.name == sp));
          }
        }

        if (lg.containsKey('leaderattachment')) {
          group.leaderattachment = trimTitleToSingleFaction(findByName(lg['leaderattachment']), list['faction']);
        }
        if (lg.containsKey('cohort')) {
          group.cohort.addAll(getCohortModelsFromJson(lg['cohort'], list['faction']));
          switch (group.leader.name.toLowerCase()) {
            case 'midas':
              //add keyword farrow to boneswarm
              //change faction to thornfall alliance
              for (var c in group.cohort) {
                if (c.product.name == 'Boneswarm') {
                  Product product = trimTitleToSingleFaction(c.product, army.listfaction);
                  if (!product.models[0].keywords!.contains('Farrow')) {
                    product.models[0].keywords!.add('Farrow');
                  }
                  product.models[0].keywords!.sort(
                    (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                  );
                  c.product = product;
                }
              }
              break;
          }
          if (casteradept && !infernalslist) {
            for (var c in group.cohort) {
              if (c.product.primaryFaction.toString().contains(adeptfaction) || c.product.primaryFaction.toString().contains(listfaction))
              //convert the caster adept cohort models to the list faction, shrink the faction cohort to the list faction
              {
                Product product = trimTitleToSingleFaction(c.product, listfaction);
                c.product = product;
              }
            }
          }
          if (infernalslist && heartofdarkness) {
            for (var c in group.cohort) {
              Product product = Product.copyProduct(c.product, false);
              if (c.product.primaryFaction.toString().contains(heartofdarknessfaction) || c.product.primaryFaction.toString().contains(listfaction)) {
                //convert the heart of darkness cohort models to the list faction, shrink the faction cohort to the list faction
                product = trimTitleToSingleFaction(c.product, listfaction);
              }
              if (c.product.fa != 'C') {
                //add accumulator soulless to non-c warjacks
                product.models[0].characterabilities!.add(Ability(
                  name: 'Accumulator [Soulless]',
                  description:
                      'When it begins its activation within 3" of one or more other friendly Soulless models, this model gains 1 focus point.',
                ));
                product.models[0].characterabilities!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                c.product = product;
              }
            }
          }
          if (lg.containsKey('oofjrcasters')) {
            for (Map<String, dynamic> jr in lg['oofjrcasters']) {
              JrCasterGroup jrgroup = JrCasterGroup(leader: ArmyListNotifier().blankproduct, cohort: []);
              jrgroup.leader = trimTitleToSingleFaction(findByName(jr['leader']), heartofdarknessfaction);
              if (jrgroup.leader.models.length > 1) {
                //has cohorts
                Product caster = Product.copyProduct(jrgroup.leader, false);
                Product additionalmodels = Product.copyProduct(jrgroup.leader, false);
                caster.models.removeRange(1, caster.models.length);
                jrgroup = JrCasterGroup(leader: caster, cohort: []);
                additionalmodels.models.removeAt(0);
                for (var m in additionalmodels.models) {
                  Product copy = ArmyListNotifier().blankproduct;
                  copy.fanum = 0;
                  copy.name = m.modelname;
                  copy.points = '0';
                  copy.fa = 'C';
                  copy.category = 'Warjacks/Warbeasts/Horrors';
                  copy.factions = [army.listfaction];
                  copy.primaryFaction = [army.listfaction];
                  copy.models.add(m);
                  Cohort thiscohort = Cohort(product: copy, selectedOptions: []);
                  jrgroup.cohort.add(thiscohort);
                }
              }
              if (jr.containsKey('cohort')) {
                jrgroup.cohort.addAll(getCohortModelsFromJson(jr['cohort'], list['faction']));
              }
              jrgroup.cohort.sort((a, b) => a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase()));
              group.oofjrcasters.add(jrgroup);
            }
          }
          if (lg.containsKey('oofsolos')) {
            for (String s in lg['oofsolos']) {
              Product product = trimTitleToSingleFaction(findByName(s), heartofdarknessfaction);
              group.oofsolos.add(product);
            }
          }
          if (lg.containsKey('oofunits')) {
            for (Map<String, dynamic> u in lg['oofunits']) {
              if (u['unit'] != 'Nyss Hunters') {
                Unit unit = Unit(
                  unit: trimTitleToSingleFaction(findByName(u['unit']), heartofdarknessfaction),
                  minsize: u['minsize'],
                  hasMarshal: false,
                  commandattachment: u.containsKey('commandattachment')
                      ? trimTitleToSingleFaction(findByName(u['commandattachment']), heartofdarknessfaction)
                      : ArmyListNotifier().blankproduct,
                  weaponattachments: [],
                  cohort: [],
                  weaponattachmentlimits: [],
                );
                if (u.containsKey('weaponattachments')) {
                  for (var wa in u['weaponattachments']) {
                    unit.weaponattachments.add(trimTitleToSingleFaction(findByName(wa), heartofdarknessfaction));
                  }
                }
                unit.hasMarshal = checkUnitForMashal(unit);
                if (unit.hasMarshal && u.containsKey('cohort')) {
                  unit.cohort.addAll(getCohortModelsFromJson(u['cohort'], heartofdarknessfaction));
                }
                unit.weaponattachmentlimits = getUnitWeaponAttachLimit(unit.unit.name);
                group.oofunits.add(unit);
              } else {
                Product product = Product.copyProduct(findByName('Cylena Raefyll & Nyss Hunters'), false);
                product.models.removeAt(0); //remove Cylena
                product.name = 'Nyss Hunters';
                product.fa = '2';
                product.factions = ['Khador'];
                product.primaryFaction = ['Khador'];
                product.unitPoints!['minunit'] = 'Leader and 5 Grunts';
                product.unitPoints!['maxunit'] = 'Leader and 9 Grunts';
                product.models[0].modelname = 'Leader and Grunts';
                Unit unit = Unit(
                  unit: product,
                  minsize: u['minsize'],
                  hasMarshal: false,
                  commandattachment: ArmyListNotifier().blankproduct,
                  weaponattachments: [],
                  cohort: [],
                  weaponattachmentlimits: [],
                );
                group.oofunits.add(unit);
              }
            }
          }
        }

        army.leadergroup.add(group);
      }
    }
    if (list.containsKey('jrcasters')) {
      for (Map<String, dynamic> jr in list['jrcasters']) {
        JrCasterGroup group = JrCasterGroup(leader: ArmyListNotifier().blankproduct, cohort: []);
        group.leader = trimTitleToSingleFaction(findByName(jr['leader']), list['faction']);
        if (group.leader.models.length > 1) {
          //has cohorts
          Product caster = Product.copyProduct(group.leader, false);
          Product additionalmodels = Product.copyProduct(group.leader, false);
          caster.models.removeRange(1, caster.models.length);
          group = JrCasterGroup(leader: caster, cohort: []);
          additionalmodels.models.removeAt(0);
          for (var m in additionalmodels.models) {
            Product copy = ArmyListNotifier().blankproduct;
            copy.fanum = 0;
            copy.name = m.modelname;
            copy.points = '0';
            copy.fa = 'C';
            copy.category = 'Warjacks/Warbeasts/Horrors';
            copy.factions = [army.listfaction];
            copy.primaryFaction = [army.listfaction];
            copy.models.add(m);
            Cohort thiscohort = Cohort(product: copy, selectedOptions: []);
            group.cohort.add(thiscohort);
          }
        }
        if (jr.containsKey('cohort')) {
          group.cohort.addAll(getCohortModelsFromJson(jr['cohort'], list['faction']));
        }
        group.cohort.sort((a, b) => a.product.name.toLowerCase().compareTo(b.product.name.toLowerCase()));
        army.jrcasters.add(group);
      }
    }
    if (list.containsKey('units')) {
      for (Map<String, dynamic> u in list['units']) {
        if (u['unit'] != 'Nyss Hunters') {
          Unit group = Unit(
            unit: trimTitleToSingleFaction(findByName(u['unit']), army.listfaction),
            minsize: u['minsize'],
            hasMarshal: false,
            commandattachment: u.containsKey('commandattachment')
                ? trimTitleToSingleFaction(findByName(u['commandattachment']), list['faction'])
                : ArmyListNotifier().blankproduct,
            weaponattachments: [],
            cohort: [],
            weaponattachmentlimits: [],
          );
          if (u.containsKey('weaponattachments')) {
            for (var wa in u['weaponattachments']) {
              group.weaponattachments.add(trimTitleToSingleFaction(findByName(wa), list['faction']));
            }
          }
          group.hasMarshal = checkUnitForMashal(group);
          if (group.hasMarshal && u.containsKey('cohort')) {
            group.cohort.addAll(getCohortModelsFromJson(u['cohort'], list['faction']));
          }
          group.weaponattachmentlimits = getUnitWeaponAttachLimit(group.unit.name);
          army.units.add(group);
        } else {
          Product product = Product.copyProduct(findByName('Cylena Raefyll & Nyss Hunters'), false);
          product.models.removeAt(0); //remove Cylena
          product.name = 'Nyss Hunters';
          product.fa = '2';
          product.factions = ['Khador'];
          product.primaryFaction = ['Khador'];
          product.unitPoints!['minunit'] = 'Leader and 5 Grunts';
          product.unitPoints!['maxunit'] = 'Leader and 9 Grunts';
          product.models[0].modelname = 'Leader and Grunts';
          Unit group = Unit(
            unit: product,
            minsize: u['minsize'],
            hasMarshal: false,
            commandattachment: ArmyListNotifier().blankproduct,
            weaponattachments: [],
            cohort: [],
            weaponattachmentlimits: [],
          );
          army.units.add(group);
        }
      }
    }
    if (list.containsKey('solos')) {
      for (String s in list['solos']) {
        Product product = trimTitleToSingleFaction(findByName(s), list['faction']);
        army.solos.add(product);
      }
    }
    if (list.containsKey('battleengines')) {
      for (String s in list['battleengines']) {
        army.battleengines.add(trimTitleToSingleFaction(findByName(s), list['faction']));
      }
    }
    if (list.containsKey('structures')) {
      for (String s in list['structures']) {
        army.structures.add(trimTitleToSingleFaction(findByName(s), list['faction']));
      }
    }
    return army;
  }

  List<Cohort> getCohortModelsFromJson(List<dynamic> json, String faction) {
    List<Cohort> cohorts = [];
    for (Map<String, dynamic> c in json) {
      Cohort cohort = Cohort(product: trimTitleToSingleFaction(findByName(c['product']), faction), selectedOptions: []);
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

  Future<bool> validateProductNames(int factionindex, List<String> products) async {
    Product blankproduct = ArmyListNotifier().blankproduct;
    Product foundproduct = blankproduct;
    if (_allFactions.isEmpty) {
      await readAllFactions();
    }
    // return true;
    for (var p in products) {
      if (p.contains(' - ')) {
        p = p.substring(0, p.indexOf(' - ')).trim();
      }
      if (!p.contains('+ ') || !p.contains('Spell Rack')) {
        //skip modular parts / spell rack
        for (int g = 0; g < 3; g++) {
          foundproduct = _allFactions[factionindex]['products'][g].firstWhere((element) => element.name == p, orElse: () => blankproduct);
          if (foundproduct.name != '') return true;
        }
        if (foundproduct.name == '') return false;
      }
    }
    return false;
  }

  Future<ArmyList> convertProductNameListToArmyList(ArmyList list, List<String> products) async {
    if (_allFactions.isEmpty) {
      await readAllFactions();
    }
    if (_allSpells.isEmpty) {
      await readAllSpells();
    }
    bool infernalslist = list.listfaction == 'Infernals';
    Product blankproduct = ArmyListNotifier().blankproduct;

    String lastleader = '';
    for (var p in products) {
      if (p.contains('+ ')) {
        //for modular parts
        String optionname = p.replaceFirst('+', '').trim();
        Cohort thiscohort;
        switch (lastleader) {
          case 'warcaster':
            thiscohort = list.leadergroup.last.cohort.last;
            break;
          case 'jrcaster':
            thiscohort = list.jrcasters.last.cohort.last;
            break;
          case 'unit':
            thiscohort = list.units.last.cohort.last;
            break;
          case 'oofjrcaster':
            thiscohort = list.leadergroup.last.oofjrcasters.last.cohort.last;
            break;
          case 'oofunit':
            thiscohort = list.leadergroup.last.oofunits.last.cohort.last;
            break;
          default:
            thiscohort = Cohort(product: blankproduct);
        }
        if (thiscohort.product.name != '') {
          thiscohort.selectedOptions ??= [];
          for (var g in thiscohort.product.models[0].modularoptions!) {
            bool found = false;
            for (var op in g.options!) {
              if (op.name == optionname) {
                thiscohort.selectedOptions!.add(Option.copy(op));
                found = true;
                break;
              }
            }
            if (found) break;
          }
        }
      } else {
        String unitsize = '';
        if (p.contains(' - ')) {
          //unit
          unitsize = p.substring(p.indexOf(' - ') + 2).trim();
          p = p.substring(0, p.indexOf(' - ')).trim();
        }
        if (p.contains('Spell Rack')) {
          String spellname = p.replaceAll('Spell Rack: ', '');
          // int i = spellname.indexOf(' - ');
          // spellname = spellname.substring(0, i).trim();
          Spell spell = _allSpells.firstWhere((element) => element.name == spellname);
          list.leadergroup.last.spellrack!.add(spell);
        } else {
          Product thisproduct = findByName(p); //factionProducts.firstWhere((element) => element.name == p, orElse: () => blankproduct);
          if (thisproduct.name != '') {
            bool infaction = thisproduct.primaryFaction.contains(list.listfaction);
            switch (thisproduct.category) {
              case 'Warcasters/Warlocks/Masters':
                bool heartofdarkness = false;
                String heartofdarknessfaction = '';
                for (var ab in thisproduct.models[0].characterabilities!) {
                  if (ab.name.toLowerCase().contains('heart of darkness')) {
                    heartofdarkness = true;
                    heartofdarknessfaction = ab.name.substring(ab.name.indexOf('[') + 1, ab.name.length - 1);
                  }
                }
                list.leadergroup.add(LeaderGroup(
                  leader: thisproduct,
                  leaderattachment: blankproduct,
                  cohort: [],
                  spellrack: [],
                  oofjrcasters: [],
                  oofsolos: [],
                  oofunits: [],
                  heartofdarkness: heartofdarkness,
                  heartofdarknessfaction: heartofdarknessfaction,
                ));
                lastleader = 'warcaster';
                break;
              case 'Warjacks/Warbeasts/Horrors':
                switch (lastleader) {
                  case 'warcaster':
                    list.leadergroup.last.cohort.add(Cohort(product: thisproduct, selectedOptions: []));
                    break;
                  case 'jrcaster':
                    list.jrcasters.last.cohort.add(Cohort(product: thisproduct, selectedOptions: []));
                    break;
                  case 'unit':
                    list.units.last.cohort.add(Cohort(product: thisproduct, selectedOptions: []));
                    break;
                  case 'oofjrcaster':
                    list.leadergroup.last.oofjrcasters.last.cohort.add(Cohort(product: thisproduct, selectedOptions: []));
                    break;
                  case 'oofunit':
                    list.leadergroup.last.oofunits.last.cohort.add(Cohort(product: thisproduct, selectedOptions: []));
                    break;
                }
                break;
              case 'Solos':
                if ((!infernalslist && !list.leadergroup.last.heartofdarkness!) || infaction) {
                  if (checkSoloForJourneyman(thisproduct) || checkProductForMarshal(thisproduct)) {
                    list.jrcasters.add(JrCasterGroup(leader: thisproduct, cohort: []));
                    lastleader = 'jrcaster';
                  } else {
                    list.solos.add(thisproduct);
                  }
                } else {
                  if (checkSoloForJourneyman(thisproduct) || checkProductForMarshal(thisproduct)) {
                    list.leadergroup.last.oofjrcasters.add(JrCasterGroup(leader: thisproduct, cohort: []));
                    lastleader = 'oofjrcaster';
                  } else {
                    list.leadergroup.last.oofsolos.add(thisproduct);
                  }
                }
                break;
              case 'Units':
                bool min = true;
                if ((!infernalslist && !list.leadergroup.last.heartofdarkness!) || infaction) {
                  if (thisproduct.unitPoints!['maxunit'] == unitsize) min = false;
                  list.units.add(Unit(
                    unit: thisproduct,
                    minsize: min,
                    hasMarshal: false,
                    commandattachment: blankproduct,
                    weaponattachments: [],
                    cohort: [],
                    weaponattachmentlimits: [],
                  ));
                  list.units.last.hasMarshal = checkUnitForMashal(list.units.last);
                  if (list.units.last.hasMarshal) {
                    lastleader = 'unit';
                  }
                  list.units.last.weaponattachmentlimits = getUnitWeaponAttachLimit(list.units.last.unit.name);
                  break;
                } else {
                  if (thisproduct.unitPoints!['maxunit'] == unitsize) min = false;
                  list.leadergroup.last.oofunits.add(Unit(
                    unit: thisproduct,
                    minsize: min,
                    hasMarshal: false,
                    commandattachment: blankproduct,
                    weaponattachments: [],
                    cohort: [],
                    weaponattachmentlimits: [],
                  ));
                  list.leadergroup.last.oofunits.last.hasMarshal = checkUnitForMashal(list.leadergroup.last.oofunits.last);
                  if (list.leadergroup.last.oofunits.last.hasMarshal) {
                    lastleader = 'oofunit';
                  }
                  list.leadergroup.last.oofunits.last.weaponattachmentlimits =
                      getUnitWeaponAttachLimit(list.leadergroup.last.oofunits.last.unit.name);
                  break;
                }
              case 'Attachments':
                for (var ab in thisproduct.models[0].characterabilities!) {
                  if (ab.name == "Attached") {
                    list.leadergroup.last.leaderattachment = thisproduct;
                    break;
                  }
                  if (ab.name.toLowerCase().contains('command') && ab.name.toLowerCase().contains('attachment')) {
                    if ((!infernalslist && !list.leadergroup.last.heartofdarkness!) || infaction) {
                      list.units.last.commandattachment = thisproduct;
                      break;
                    } else {
                      list.leadergroup.last.oofunits.last.commandattachment = thisproduct;
                      list.leadergroup.last.oofunits.last.hasMarshal = checkUnitForMashal(list.leadergroup.last.oofunits.last);
                      if (list.leadergroup.last.oofunits.last.hasMarshal) {
                        lastleader = 'oofunit';
                      }
                      break;
                    }
                  }
                  if (ab.name.toLowerCase().contains('weapon') && ab.name.toLowerCase().contains('attachment')) {
                    if ((!infernalslist && !list.leadergroup.last.heartofdarkness!) || infaction) {
                      list.units.last.weaponattachments.add(thisproduct);
                      break;
                    } else {
                      list.leadergroup.last.oofunits.last.weaponattachments.add(thisproduct);
                      break;
                    }
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
    if (_allFactions.isEmpty) {
      await readAllFactions();
    }
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
    if (name == 'Nyss Hunters') {
      return true;
    }
    for (int g = 0; g < 3; g++) {
      found.addAll(_allFactions[_selectedFactionIndex]['products'][g].where((element) => element.name == name));
    }
    return found.isNotEmpty;
  }

  readAllSpells() async {
    _allSpells.clear();

    String data = await rootBundle.loadString('json/spellrack.json');
    var decodeddata = jsonDecode(data);
    if (decodeddata.containsKey('updated')) {
      _spellsUpdateDate = decodeddata['updated'];
    } else {
      _spellsUpdateDate = 'pending';
    }

    for (var sp in decodeddata['spellrack']) {
      _allSpells.add(Spell.fromJson(sp));
    }
  }

  List<Spell> getFactionSpells(String faction) {
    List<Spell> spells = [];
    spells.addAll(_allSpells.where((element) => element.poolfactions!.contains(faction)));
    return spells;
  }
}
