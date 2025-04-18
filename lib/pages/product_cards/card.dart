import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:math';

import 'package:curved_text/curved_text.dart';
import 'package:vector_math/vector_math.dart' show radians;

import 'package:armybuilder/appdata.dart';
import 'package:armybuilder/models/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/animi.dart';
import '../../models/base_stats.dart';
import '../../models/model.dart';
import '../../models/product.dart';
import '../../models/spells.dart';
import '../../providers/armylist.dart';
import '../../providers/faction.dart';

const double scalevalue = 2.0;
BoxDecoration debugborder = BoxDecoration(border: Border.all(color: Colors.red, width: 1));

const double backgroundheight = 1050;
const double backgroundwidth = 750;
const double titlewidth = 715;
const double titleheight = 98;
const double versionwidth = 71;
const double versionheight = 64;

const double modelstatbarheight = 124;

const double modelstatbarleftwidth = 32;
const double modelstatbarpartwidth = 45;

const double iconsize = 40; //square
const double sourceiconsize = 50; //square

const double meleeweaponbarwidth = 238;
const double meleeweaponbarheight = 125;

const double rangedweaponbarwidth = 299;
const double rangedweaponbarheight = 125;

const double mountweaponbarwidth = 199;
const double mountweaponbarheight = 125;

const double pccostwidth = 57;
const double pccostheight = 63;

const double unitpccostwidth = 304;
const double unitpccostheight = 81;

const double fawidth = 65;
const double faheight = 73;

const double tenhpbarwidth = 305;
const double tenhpbarheight = 59;

const double leaderhpbarwidth = 750;
const double leaderhpbarheight = 60;
const int leaderhprowmaxhp = 20;

const double battleenginehpbarwidth = 585;
const double battleenginehpbarheight = 91;

const double gridwidth = 272;
const double gridheight = 292;
const double gridsquaresize = 28;

const double gridwithshieldwidth = 351;
const double gridwithshieldheight = 293;

const double beastspiralwidth = 600;
const double beastspiralheight = 600;
const double spiralframedimension = 600;

const double webwidth = 450;
const double webheight = 450;

const double fieldoffireboxwidth = 299;
const double fieldoffireboxheight = 36;

double statbarwidth = 0;
const cUnitFirstModelLeft = 6 / scalevalue;

double fontsize = (18 / scalevalue);
Color fontcolor = Colors.black;

const List<String> sources = [
  '3.5',
  'company of iron',
  'grind',
  'high kommand',
  'ikrpg',
  'mk1',
  'mk2',
  'mk3',
  'mk4',
  'no quarter',
  'riot quest',
  'undercity',
  'widower\'s wood',
];

const List<String> weaponicons = [
  'assault',
  'blessed',
  'buckler',
  'chain weapon',
  'continuous corrosion',
  'continuous fire',
  'critical continuous corrosion',
  'critical continuous fire',
  'critical disruption',
  'damage type arcane',
  'damage type cold',
  'damage type corrosion',
  'damage type fire',
  'damage type electrical',
  'disruption',
  'open fist',
  'shield',
  'weapon master',
];

const List<String> icons = [
  '30',
  '40',
  '50',
  '80',
  '120',
  'advance deploy',
  'ambush',
  'amphibious',
  'arc node',
  'cavalry',
  'cma',
  'construct',
  'cra',
  'dual attack',
  'eyeless sight',
  'flight',
  'gladiator',
  'gunfighter',
  '\'jack marshal',
  'officer',
  'pathfinder',
  'grab attack',
  'power attack headbutt',
  'power attack slam',
  'power attack power strike',
  'power attack sweep',
  'power attack throw',
  'power attack trample',
  'resistance arcane',
  'resistance blast',
  'resistance cold',
  'resistance corrosion',
  'resistance electric',
  'resistance fire',
  'soulless',
  'spectre',
  'standard',
  'stealth',
  'tough',
  'undead',
  'unstoppable',
  'vaulter',
];

const List<String> modelsWithScaledText = [
  'Vessel of Judgement',
  'Sepulcher',
];

Map<String, String> abilities = {};

class ModelCard extends StatefulWidget {
  const ModelCard({super.key});

  @override
  State<ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true); //for testing card
    Product product = army.selectedProduct;
    String selectedfaction = AppData().factionList[faction.selectedFactionIndex]['name']!.toLowerCase();
    List<GlobalKey> imageKeys = [];

    List<Widget> frontcards = [];
    List<Widget> backcards = [];

    List<Widget> frontcardparts = [];
    List<Widget> backcardparts = [];
    List<Widget> abilitytexts = [];
    List<String> unitcosts = [];
    List<Widget> weaponiconbars = [];
    Widget sourceicon = const SizedBox();
    Widget pc = const SizedBox();

    if (product == army.blankproduct) {
      return const SizedBox();
    }

    double ypos = (titleheight / scalevalue) + (20 / scalevalue); //stat bar y
    int modelnum = 1;

    abilities.clear();
    fontsize = (18 / scalevalue);

    if (product.models.isNotEmpty) {
      //loop through each model

      for (var model in product.models) {
        statbarwidth = 0;
        Widget modeliconbar = const SizedBox();
        List<String> modelicons = [];
        bool frontprinted = false;
        //add card background
        if (frontcardparts.isEmpty) {
          if (product.primaryFaction.toString().toLowerCase().contains(selectedfaction)) {
            frontcardparts.add(Image.asset(
              cardbackground(selectedfaction, true),
              width: backgroundwidth / scalevalue,
              height: backgroundheight / scalevalue,
            ));
          } else {
            frontcardparts.add(Image.asset(
              cardbackground(product.primaryFaction[0], true),
              width: backgroundwidth / scalevalue,
              height: backgroundheight / scalevalue,
            ));
          }
          frontcardparts.add(cardHeader(product.name, product.models[0].title));
        }

        bool cUnitFirstModel = (product.fa == 'C' && product.models.length > 2 && modelnum == 1);

        //create statbar
        frontcardparts.add(
          modelstatbar(
            ypos,
            model.modelname,
            model.stats,
            cUnitFirstModel,
          ),
        );

        //model icon row
        for (var k in model.keywords!) {
          String keyword = k.replaceAll(':', '').toLowerCase();
          if (icons.contains(keyword)) {
            modelicons.add('assets/card_assets/icons/$keyword.png'.replaceAll(' ', '_'));
          }
          if (sources.contains(keyword)) {
            sourceicon = sourceIcon('assets/card_assets/icons/sources/$keyword.png'.replaceAll(' ', '_'));
          }
        }

        //base icon
        if (model.stats.base != '-') {
          modelicons.add('assets/card_assets/icons/${model.stats.base.toLowerCase().replaceAll('mm', '')}.png');
        }

        // iconbarwidth = modelicons.length * (iconsize + 1);

        //create icon bar
        if (modelicons.isNotEmpty) {
          modeliconbar = iconbar(!cUnitFirstModel ? (backgroundwidth - 15 - statbarwidth) / scalevalue : 0,
              ypos + (modelstatbarheight / scalevalue) - (iconsize / scalevalue / 2) - (6 / scalevalue), statbarwidth / scalevalue, modelicons);
        }

        ypos += (modelstatbarheight / scalevalue) - (5 / scalevalue);
        bool weapon = false;

        //count the number of weapons in each field, if any
        List<int> fieldcounts = [0, 0];
        List<int> maxfieldcounts = [0, 0];
        for (var w in model.weapons!) {
          if (w.fieldoffire! == 'left') {
            fieldcounts[0]++;
            maxfieldcounts[0]++;
          }
          if (w.fieldoffire! == 'right') {
            fieldcounts[1]++;
            maxfieldcounts[1]++;
          }
        }

        const fieldspacingradius = 20;
        const iconbarrightpadding = 15;

        const double mountleftpadding = (backgroundwidth - 10 - mountweaponbarwidth) / scalevalue;
        const double meleenofieldleftpadding = (backgroundwidth - 10 - meleeweaponbarwidth) / scalevalue;
        const double rangednofieldleftpadding = (backgroundwidth - 10 - rangedweaponbarwidth) / scalevalue;

        const double meleeleftfieldleftpadding =
            ((backgroundwidth / 2) - ((rangedweaponbarwidth - meleeweaponbarwidth) / 2) - meleeweaponbarwidth - fieldspacingradius) / scalevalue;
        const double meleerightfieldleftpadding =
            ((backgroundwidth / 2) + ((rangedweaponbarwidth - meleeweaponbarwidth) / 2) + fieldspacingradius) / scalevalue;

        const double rangedleftfieldleftpadding = ((backgroundwidth / 2) - rangedweaponbarwidth - fieldspacingradius) / scalevalue;
        const double rangedrightfieldleftpadding = ((backgroundwidth / 2) + fieldspacingradius) / scalevalue;

        const double fieldweaponbottompadding = 250;
        const double weaponspacingheight = 8;

        double gridleft = 25 / scalevalue;
        double gridtop = (backgroundheight - 100 - gridheight) / scalevalue;
        bool colossal = false;

        if (model.title.toLowerCase().contains('colossal')) {
          colossal = true;
        }

        String warbeastsize = 'normal';
        if (model.title.toLowerCase().contains('warbeast')) {
          if (model.title.toLowerCase().contains('light') || model.title.toLowerCase().contains('lesser')) warbeastsize = 'normal';
          if (model.title.toLowerCase().contains('heavy')) warbeastsize = 'large';
          if (model.title.toLowerCase().contains('gargantuan')) warbeastsize = 'huge';
        }
        double spiralwidth = spiralframedimension;
        double spiralheight = spiralframedimension;
        bool gargantuan = false;

        if (model.title.toLowerCase().contains('gargantuan')) {
          //slaughterhouse needs width
          //wold wrath needs width
          gargantuan = true;
          // spiralwidth = backgroundwidth;
          // spiralheight = 625;
        }

        double spiralleft = -20;
        double spiraltop = (backgroundheight - spiralheight - 20) / scalevalue;

        double webleft = 20 / scalevalue;
        double webtop = (backgroundheight - webheight - 10) / scalevalue;

        //loop through each weapon and generate their bars
        for (var w in model.weapons!) {
          // weaponrightpadding = (10 / scalevalue); //reset value
          double weaponiconbarx = 0;
          double weaponiconbary = 0;
          List<String> thisweaponicons = [];
          Widget weaponXicon = const SizedBox();
          Widget weaponsystem = const SizedBox();
          for (var ab in w.presetabilities!) {
            if (weaponicons.contains(ab)) {
              thisweaponicons.add('assets/card_assets/icons/$ab.png'.replaceAll(' ', '_'));
            }
          }

          double weaponiconbarwidth = thisweaponicons.length * (iconsize + 1);

          switch (w.type.toLowerCase()) {
            case 'ranged':
              if (weapon) ypos -= (weaponspacingheight / scalevalue);
              if ((int.tryParse(w.count!) ?? 0) > 1) {
                weaponXicon = weaponX('assets/card_assets/parts/x2_range.png');
              }
              if (w.system != '') {
                weaponsystem = weaponSystem(w.system!);
              }
              if (w.fieldoffire! == 'none') {
                frontcardparts.add(rangedweaponbar(
                    !cUnitFirstModel
                        ? rangednofieldleftpadding
                        : (statbarwidth + (cUnitFirstModelLeft * scalevalue) - rangedweaponbarwidth) / scalevalue,
                    ypos,
                    w.name,
                    [w.rng, w.rof!, w.aoe!, w.pow],
                    weaponXicon,
                    weaponsystem));
                ypos += (rangedweaponbarheight / scalevalue);
                weaponiconbary = ypos - (iconsize / scalevalue / 2) - (10 / scalevalue);
                if (thisweaponicons.isNotEmpty) {
                  weaponiconbarx = backgroundwidth - weaponiconbarwidth - iconbarrightpadding;
                }
              } else {
                if (w.fieldoffire == 'left') {
                  double y = (backgroundheight -
                      (((rangedweaponbarheight - weaponspacingheight) * fieldcounts[0]) + weaponspacingheight) -
                      (fieldweaponbottompadding / scalevalue));

                  if (fieldcounts[0] == maxfieldcounts[0]) {
                    //add topper
                    double topperx = rangedleftfieldleftpadding;
                    double toppery = (y - fieldoffireboxheight + weaponspacingheight) / scalevalue;
                    frontcardparts.add(fieldoffiretop(topperx, toppery, 'Left Field of Fire'));
                  }

                  frontcardparts.add(
                      rangedweaponbar(rangedleftfieldleftpadding, y / scalevalue, w.name, [w.rng, w.rof!, w.aoe!, w.pow], weaponXicon, weaponsystem));
                  if (thisweaponicons.isNotEmpty) {
                    weaponiconbarx = (rangedleftfieldleftpadding * scalevalue) + rangedweaponbarwidth - weaponiconbarwidth - iconbarrightpadding;
                    weaponiconbary = (y + (rangedweaponbarheight - (iconsize / 2))) / scalevalue;
                  }
                  fieldcounts[0]--;
                }
                if (w.fieldoffire == 'right') {
                  double y = (backgroundheight -
                      (((rangedweaponbarheight - weaponspacingheight) * fieldcounts[1]) + weaponspacingheight) -
                      (fieldweaponbottompadding / scalevalue));

                  if (fieldcounts[1] == maxfieldcounts[1]) {
                    //add topper
                    double topperx = rangedrightfieldleftpadding;
                    double toppery = (y - fieldoffireboxheight + weaponspacingheight) / scalevalue;
                    frontcardparts.add(fieldoffiretop(topperx, toppery, 'Right Field of Fire'));
                  }

                  frontcardparts.add(rangedweaponbar(
                      rangedrightfieldleftpadding, y / scalevalue, w.name, [w.rng, w.rof!, w.aoe!, w.pow], weaponXicon, weaponsystem));
                  if (thisweaponicons.isNotEmpty) {
                    weaponiconbarx = (rangedrightfieldleftpadding * scalevalue) + rangedweaponbarwidth - weaponiconbarwidth - iconbarrightpadding;
                    weaponiconbary = (y + (rangedweaponbarheight - (iconsize / 2))) / scalevalue;
                  }
                  fieldcounts[1]--;
                }
              }
              weapon = true;
              break;

            case 'melee':
              int str = int.tryParse(model.stats.str!) ?? 0;
              int pow = int.tryParse(w.pow) ?? 0;
              int ps = str + pow;
              if ((int.tryParse(w.count!) ?? 0) > 1) {
                weaponXicon = weaponX('assets/card_assets/parts/x2_melee.png');
              }
              if (weapon) ypos -= (weaponspacingheight / scalevalue);
              if (w.system != '') {
                weaponsystem = weaponSystem(w.system!);
              }
              if (w.fieldoffire! == 'none') {
                frontcardparts.add(meleeweaponbar(
                  !cUnitFirstModel ? meleenofieldleftpadding : (statbarwidth + (cUnitFirstModelLeft * scalevalue) - meleeweaponbarwidth) / scalevalue,
                  ypos,
                  w.name,
                  [w.rng, w.pow, ps == 0 ? '-' : ps.toString()],
                  weaponXicon,
                  weaponsystem,
                ));
                ypos += (meleeweaponbarheight / scalevalue);
                weaponiconbary = ypos - (iconsize / scalevalue / 2) - (10 / scalevalue);
                if (thisweaponicons.isNotEmpty) {
                  weaponiconbarx = backgroundwidth - weaponiconbarwidth - iconbarrightpadding;
                }
              } else {
                if (w.fieldoffire == 'left') {
                  double y = (backgroundheight -
                      (((meleeweaponbarheight - weaponspacingheight) * fieldcounts[0]) + weaponspacingheight) -
                      (fieldweaponbottompadding / scalevalue));

                  if (fieldcounts[0] == maxfieldcounts[0]) {
                    //add topper
                    double topperx = rangedleftfieldleftpadding;
                    double toppery = (y - fieldoffireboxheight + weaponspacingheight) / scalevalue;
                    frontcardparts.add(fieldoffiretop(topperx, toppery, 'Left Field of Fire'));
                  }

                  frontcardparts.add(meleeweaponbar(
                    meleeleftfieldleftpadding,
                    y / scalevalue,
                    w.name,
                    [w.rng, w.pow, ps == 0 ? '-' : ps.toString()],
                    weaponXicon,
                    weaponsystem,
                  ));
                  if (thisweaponicons.isNotEmpty) {
                    weaponiconbarx = (meleeleftfieldleftpadding * scalevalue) + meleeweaponbarwidth - weaponiconbarwidth - iconbarrightpadding;
                    weaponiconbary = (y + (meleeweaponbarheight - (iconsize / 2))) / scalevalue;
                  }
                  fieldcounts[0]--;
                }
                if (w.fieldoffire == 'right') {
                  double y = (backgroundheight -
                      (((meleeweaponbarheight - weaponspacingheight) * fieldcounts[1]) + weaponspacingheight) -
                      (fieldweaponbottompadding / scalevalue));

                  if (fieldcounts[1] == maxfieldcounts[1]) {
                    //add topper
                    double topperx = rangedrightfieldleftpadding;
                    double toppery = (y - fieldoffireboxheight + weaponspacingheight) / scalevalue;
                    frontcardparts.add(fieldoffiretop(topperx, toppery, 'Right Field of Fire'));
                  }

                  frontcardparts.add(meleeweaponbar(
                    meleerightfieldleftpadding,
                    y / scalevalue,
                    w.name,
                    [w.rng, w.pow, ps == 0 ? '-' : ps.toString()],
                    weaponXicon,
                    weaponsystem,
                  ));
                  if (thisweaponicons.isNotEmpty) {
                    weaponiconbarx = (meleerightfieldleftpadding * scalevalue) + meleeweaponbarwidth - weaponiconbarwidth - iconbarrightpadding;
                    weaponiconbary = (y + (meleeweaponbarheight - (iconsize / 2))) / scalevalue;
                  }
                  fieldcounts[1]--;
                }
              }
              weapon = true;
              break;

            case 'mount':
              if (weapon) ypos -= (weaponspacingheight / scalevalue);
              frontcardparts.add(mountweaponbar(
                mountleftpadding,
                ypos,
                w.name,
                [w.rng, w.pow],
              ));
              ypos += (mountweaponbarheight / scalevalue);
              weaponiconbary = ypos - (iconsize / scalevalue / 2) - (10 / scalevalue);
              if (thisweaponicons.isNotEmpty) weaponiconbarx = backgroundwidth - weaponiconbarwidth - iconbarrightpadding;
              weapon = true;
              break;

            default:
              break;
          }
          if (thisweaponicons.isNotEmpty) {
            weaponiconbars.add(iconbar(weaponiconbarx / scalevalue, weaponiconbary, weaponiconbarwidth / scalevalue, thisweaponicons));
          }
        }

        if (product.fa == 'C' && !product.category.toLowerCase().contains('warjack')) {
          //character model or unit
          bool hascaster = false;
          bool hascohort = false;
          for (var m in product.models) {
            if (m.title.toLowerCase().contains('warcaster') || m.title.toLowerCase().contains('warlock')) hascaster = true;
            if (m.title.toLowerCase().contains('warjack') || m.title.toLowerCase().contains('warbeast')) hascohort = true;
          }

          if (product.models.length > 1) {
            List<int> cgrouphp = [];
            List<String> names = [];
            for (var m in product.models) {
              cgrouphp.add(int.tryParse(m.stats.hp!) ?? 0);
              names.add(m.modelname);
            }

            if (!hascaster && !hascohort) {
              //character unit
              if (modelnum == 1) {
                frontcardparts.add(unithpbars(cgrouphp, names));
              }
            }

            if (hascaster && !hascohort) {
              //leader with a solo model
              if (modelnum == 1) {
                if (product.models[0].hpbars!.isNotEmpty) {
                  //group like the coven
                  List<int> hpvals = [];
                  names.clear();
                  for (var hp in model.hpbars!) {
                    hpvals.add(int.tryParse(hp.hp) ?? 0);
                    names.add(hp.name);
                  }
                  frontcardparts.add(unithpbars(hpvals, names));
                } else {
                  frontcardparts.add(leaderhpbar(cgrouphp[0]));
                }
              }
              if (modelnum == 2) {
                cgrouphp.removeAt(0);
                names.removeAt(0);
                if (cgrouphp[0] != 0) {
                  frontcardparts.add(unithpbars(cgrouphp, names));
                }
              }
            }
            if (hascaster && hascohort) {
              //caster with warjack/warbeast companion
              if (modelnum == 1) {
                frontcardparts.add(leaderhpbar(cgrouphp[0]));
              }
              if (modelnum == 2) {
                //add grid or spiral

                if (model.grid!.columns.isNotEmpty) {
                  if (model.grid!.columns.isNotEmpty) gridleft = rangedleftfieldleftpadding + ((rangedweaponbarwidth - gridwidth) / 2 / scalevalue);
                  frontcardparts.add(cardgrid(gridleft, gridtop, model.grid!, int.tryParse(model.shield!) ?? 0, 0));
                } else {
                  if (model.spiral!.values.isNotEmpty) {
                    List<int> branchvalues = [];
                    for (var b in model.spiral!.values) {
                      branchvalues.add(int.tryParse(b) ?? 0);
                    }

                    frontcardparts.add(cardspiral(spiralleft, spiraltop, branchvalues, warbeastsize));
                  } else {
                    if (model.web!.values.isNotEmpty) {
                      List<int> ringvalues = [];
                      for (var r in model.web!.values) {
                        ringvalues.add(int.tryParse(r) ?? 0);
                      }
                      frontcardparts.add(cardweb(webleft, webtop, ringvalues, colossal));
                    }
                  }
                }
              }
            }
          } else {
            if (product.category.toLowerCase().contains('warcaster')) {
              //solo warcaster
              int hp = int.tryParse(model.stats.hp!) ?? 0;
              if (hp <= leaderhprowmaxhp) {
                frontcardparts.add(leaderhpbar(hp));
              } else {
                frontcardparts.add(doubleleaderhpbar(hp));
              }
            } else {
              //solo model
              if (model.stats.hp! != '1') {
                frontcardparts.add(unithpbars([int.tryParse(model.stats.hp!) ?? 0], [model.modelname]));
              }
            }
          }
        } else {
          if (model.hpbars!.isNotEmpty) {
            List<int> hpvals = [];
            List<String> names = [];
            for (var hp in model.hpbars!) {
              hpvals.add(int.tryParse(hp.hp) ?? 2);
              names.add(hp.name);
            }
            frontcardparts.add(unithpbars(hpvals, names));
          } else {
            bool added = false;
            if (model.grid!.columns.isNotEmpty && !colossal) {
              //adjust grid left to be centered with left field of fire if present
              if (model.grid!.columns.isNotEmpty) gridleft = rangedleftfieldleftpadding + ((rangedweaponbarwidth - gridwidth) / 2 / scalevalue);
              frontcardparts.add(cardgrid(gridleft, gridtop, model.grid!, int.tryParse(model.shield!) ?? 0, 0));
              added = true;
            }
            if (model.spiral!.values.isNotEmpty && !gargantuan) {
              List<int> branchvalues = [];
              for (var b in model.spiral!.values) {
                branchvalues.add(int.tryParse(b) ?? 0);
              }
              frontcardparts.add(cardspiral(spiralleft, spiraltop, branchvalues, warbeastsize));
              added = true;
            }
            if (model.web!.values.isNotEmpty && !colossal) {
              List<int> ringvalues = [];
              for (var r in model.web!.values) {
                ringvalues.add(int.tryParse(r) ?? 0);
              }
              frontcardparts.add(cardweb(webleft, webtop, ringvalues, colossal));
              added = true;
            }
            if (model.title.toLowerCase().contains('battle engine')) {
              int hp = int.tryParse(model.stats.hp!) ?? 0;
              if (hp <= leaderhprowmaxhp) {
                frontcardparts.add(leaderhpbar(hp));
              } else {
                frontcardparts.add(doubleleaderhpbar(hp));
              }
              added = true;
            }
            if (!colossal && !gargantuan && !added) {
              if ((int.tryParse(model.stats.hp!) ?? 0) > 1) {
                frontcardparts.add(unithpbars([int.tryParse(model.stats.hp!) ?? 2], [model.modelname]));
              }
            }
          }
        }

        frontcardparts.add(modeliconbar);
        frontcardparts.addAll(weaponiconbars);
        weaponiconbars.clear();

        //add pc to first card only
        if (modelnum == 1) {
          if (product.points! != '') {
            pc = pointcost(product.points!, product.category == 'Warcasters/Warlocks/Masters');
          } else {
            if (product.unitPoints!.containsKey('minunit')) {
              unitcosts.add('${product.unitPoints!['minunit']}: ${product.unitPoints!['basemincost']}');
              if (product.unitPoints!['maxunit'] != '-') {
                unitcosts.add('${product.unitPoints!['maxunit']}: ${product.unitPoints!['basemaxcost']}');
              }
            }
          }
          frontcardparts.add(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              unitcosts.isEmpty ? pc : unitpointcost(unitcosts),
              Padding(
                padding: const EdgeInsets.only(left: (20 / scalevalue), right: (10 / scalevalue)),
                child: fieldallowance(product.basefa),
              ),
            ],
          ));
        }
        // removed (modelnum == 1 && product.models.length >= 3) ||
        if ((product.category.toLowerCase().contains('warcaster') && product.models.length > 1 && modelnum == 1) ||
            ((model.title.toLowerCase().contains('warcaster') || model.title.toLowerCase().contains('warlock')) &&
                product.models.length > 1 &&
                modelnum == 1) ||
            (product.models.length <= 2 && modelnum == product.models.length) ||
            (modelnum == product.models.length)) {
          //one/two models or more than 2 and this is the main character or last/only model
          frontprinted = true;
          imageKeys.add(GlobalKey());
          GlobalKey lastkey = imageKeys.last;
          frontcards.add(cardWidget(lastkey, [
            ...frontcardparts,
            sourceicon,
          ]));

          ypos = (titleheight / scalevalue) + (20 / scalevalue);
          frontcardparts.clear();
          //check for colossal/garg to add hp card

          if (colossal || gargantuan) {
            if (product.primaryFaction.toString().toLowerCase().contains(selectedfaction)) {
              frontcardparts.add(Image.asset(
                cardbackground(selectedfaction, true),
                width: backgroundwidth / scalevalue,
                height: backgroundheight / scalevalue,
              ));
            } else {
              frontcardparts.add(Image.asset(
                cardbackground(product.primaryFaction[0], true),
                width: backgroundwidth / scalevalue,
                height: backgroundheight / scalevalue,
              ));
            }
            frontcardparts.add(cardHeader(product.name, model.title));
            if (model.grid!.columns.isNotEmpty) {
              //adjust grid left to be centered with left field of fire if present
              gridleft = rangedleftfieldleftpadding + ((rangedweaponbarwidth - gridwidth) / 2 / scalevalue);
              frontcardparts.add(cardgrid(gridleft, gridtop, model.grid!, int.tryParse(model.shield!) ?? 0, 0));
              //adjust grid left to be centered with right field of fire if present
              gridleft = rangedrightfieldleftpadding + ((rangedweaponbarwidth - gridwidth) / 2 / scalevalue);
              frontcardparts.add(cardgrid(gridleft, gridtop, model.grid!, int.tryParse(model.shield!) ?? 0, 6));
            }
            if (model.spiral!.values.isNotEmpty) {
              List<int> branchvalues = [];
              for (var b in model.spiral!.values) {
                branchvalues.add(int.tryParse(b) ?? 0);
              }
              spiralleft = (backgroundwidth - spiralwidth) / 2 / scalevalue;
              spiraltop = (backgroundheight - spiralheight - 75) / scalevalue;
              frontcardparts.add(cardspiral(spiralleft, spiraltop, branchvalues, warbeastsize));
            }
            if (model.web!.values.isNotEmpty) {
              List<int> ringvalues = [];
              for (var r in model.web!.values) {
                ringvalues.add(int.tryParse(r) ?? 0);
              }
              webleft = (backgroundwidth - webwidth) / 2 / scalevalue;
              webtop = webtop - (75 / scalevalue);
              frontcardparts.add(cardweb(webleft, webtop, ringvalues, colossal));
            }
            //add colossal/gargantuan health card
            imageKeys.add(GlobalKey());
            GlobalKey lastkey = imageKeys.last;
            frontcards.add(cardWidget(lastkey, [
              ...frontcardparts,
            ]));

            ypos = (titleheight / scalevalue) + (20 / scalevalue);
            frontcardparts.clear();
          }
        }

        //feat card or trump card
        if (product.category.toLowerCase().contains('warcaster') && modelnum == 1) {
          imageKeys.add(GlobalKey());
          GlobalKey lastkey = imageKeys.last;
          frontcards.add(cardWidget(lastkey, [
            featCard(
              product,
              model,
              selectedfaction,
            )
          ]));
          //spell card

          if (model.spells!.isNotEmpty) {
            List<List<Spell>> spells = [[], []];

            for (var x = 0; x < model.spells!.length; x++) {
              if (x <= 5) {
                spells[0].add(model.spells![x]);
              } else {
                spells[1].add(model.spells![x]);
              }
            }

            imageKeys.add(GlobalKey());
            GlobalKey lastkey = imageKeys.last;
            frontcards.add(cardWidget(lastkey, [
              spellCard(
                product,
                model,
                selectedfaction,
                spells[0],
              )
            ]));

            if (spells[1].isNotEmpty) {
              imageKeys.add(GlobalKey());
              GlobalKey lastkey = imageKeys.last;
              frontcards.add(cardWidget(lastkey, [
                spellCard(
                  product,
                  model,
                  selectedfaction,
                  spells[1],
                )
              ]));
            }
          }
        }

        //start ability card if nothing present
        if (backcardparts.isEmpty) {
          if (product.primaryFaction.toString().toLowerCase().contains(selectedfaction)) {
            backcardparts.add(Image.asset(
              cardbackground(selectedfaction, false),
              width: backgroundwidth / scalevalue,
              height: backgroundheight / scalevalue,
            ));
          } else {
            backcardparts.add(Image.asset(
              cardbackground(product.primaryFaction[0], false),
              width: backgroundwidth / scalevalue,
              height: backgroundheight / scalevalue,
            ));
          }
          backcardparts.add(
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(top: 26 / scalevalue, left: 20 / scalevalue, right: 20 / scalevalue),
                child: Text(
                  product.name,
                  style: GoogleFonts.ptSerif(
                    color: fontcolor,
                    fontSize: 36 / scalevalue,
                  ),
                ),
              ),
            ),
          );
          abilitytexts.add(const SizedBox(
            height: 90 / scalevalue,
          ));
        }

        if (modelsWithScaledText.contains(product.name)) {
          fontsize = 16 / scalevalue;
        }

        List<String> keywords = [];
        //add non-icon, non-source keywords
        if (model.keywords!.isNotEmpty) {
          for (var k in model.keywords!) {
            String keyword = k.replaceAll(':', '').toLowerCase();
            if (!icons.contains(keyword) && !sources.contains(keyword)) {
              keywords.add(k);
            }
          }
        }

        if (model.animi!.isNotEmpty) {
          abilitytexts.add(const SizedBox(height: (10 / scalevalue)));
          abilitytexts.add(animusHeaders(backgroundwidth / scalevalue, fontsize, fontcolor));
          for (var sp in model.animi!) {
            abilitytexts.add(animusStats(sp, backgroundwidth / scalevalue, fontsize, fontcolor));
            abilitytexts.add(spellDescription(sp.description, backgroundwidth / scalevalue, fontsize, fontcolor));
          }
          abilitytexts.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: (35 / scalevalue), vertical: (3 / scalevalue)),
            child: Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
            ),
          ));
        }

        if (!product.category.toLowerCase().contains('warcaster')) {
          if (model.spells!.isNotEmpty) {
            abilitytexts.add(spellHeaders(backgroundwidth / scalevalue, fontsize, fontcolor));
            for (var sp in model.spells!) {
              abilitytexts.add(spellStats(sp, backgroundwidth / scalevalue, fontsize, fontcolor));
              abilitytexts.add(spellDescription(sp.description, backgroundwidth / scalevalue, fontsize, fontcolor));
            }
          }
        }

        //add model name
        abilitytexts.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: (1 / scalevalue), color: fontcolor),
                )),
                child: Text(
                  model.modelname,
                  style: GoogleFonts.ptSerif(
                    color: fontcolor,
                    fontSize: fontsize,
                  ),
                ),
              ),
              const SizedBox(width: 10 / scalevalue),
              Text(
                keywords.join(', '),
                style: GoogleFonts.ptSerif(
                  color: fontcolor,
                  fontSize: fontsize,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ));

        List<String> printedabilities = [];

        if (model.characterabilities!.isNotEmpty) {
          //add abilities
          bool listbuilding = false;
          int count = 0;
          for (var ab in model.characterabilities!) {
            String abname = ab.name.replaceAll(RegExp(r'\[(.*)\]'), '').replaceAll('(★Attack)', '').replaceAll('(★Action)', '').trim().toLowerCase();
            if (AppData().listbuildingabilities.contains(abname)) {
              listbuilding = true;
              count++;
              abilitytexts.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
                  child: Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                      text: ab.name,
                      style: GoogleFonts.ptSerif(
                        color: fontcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      ),
                      children: [
                        TextSpan(
                          text: ' - ${ab.description}',
                          style: GoogleFonts.ptSerif(
                            color: fontcolor,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }

          if (listbuilding && count < model.characterabilities!.length) {
            abilitytexts.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: (35 / scalevalue), vertical: (3 / scalevalue)),
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
              ),
            ));
          }

          for (var ab in model.characterabilities!) {
            String abname = ab.name.replaceAll(RegExp(r'\[(.*)\]'), '').replaceAll('(★Attack)', '').replaceAll('(★Action)', '').trim().toLowerCase();
            if (!AppData().listbuildingabilities.contains(abname)) {
              if (!printedabilities.contains(ab.name.toLowerCase()) && !abilities.containsKey(ab.name.toLowerCase())) {
                abilities.addAll({ab.name.toLowerCase(): model.modelname});
                printedabilities.add(ab.name.toLowerCase());
                abilitytexts.add(ability(ab.name, ab.description, false));
              } else {
                String description = 'See above.';
                if (abilities.containsKey(ab.name.toLowerCase())) {
                  description = 'See ${abilities[ab.name.toLowerCase()]}.';
                }
                abilitytexts.add(ability(ab.name, description, false));
              }
            }
          }

          for (var n in model.nestedabilities!) {
            if (n.topability.name != '' && n.subabilities.isNotEmpty) {
              if (!abilities.containsKey(n.topability.name.toLowerCase())) {
                abilities.addAll({n.topability.name.toLowerCase(): model.modelname});
                abilitytexts.add(ability(n.topability.name, n.topability.description, false));
              } else {
                String description = 'See above.';
                if (abilities.containsKey(n.topability.name.toLowerCase())) {
                  description = 'See ${abilities[n.topability.name.toLowerCase()]}.';
                }
                abilitytexts.add(ability(n.topability.name, description, false));
              }
            }

            for (var ab in n.subabilities) {
              if (!abilities.containsKey(ab.name.toLowerCase())) {
                abilities.addAll({ab.name.toLowerCase(): model.modelname});
                abilitytexts.add(ability(ab.name, ab.description, true));
              } else {
                String description = 'See above.';
                if (abilities.containsKey(ab.name.toLowerCase())) {
                  description = 'See ${abilities[ab.name.toLowerCase()]}.';
                }
                abilitytexts.add(ability(ab.name, description, true));
              }
            }
          }
        }

        List<String> printedweaponnames = [];
        List<String> printedweaponabilities = [];

        for (var w in model.weapons!) {
          if (!printedweaponnames.contains(w.name.toLowerCase())) {
            if (w.abilities!.isNotEmpty || w.nestedabilities!.isNotEmpty) {
              abilitytexts.add(const SizedBox(
                height: 3 / scalevalue,
              ));

              abilitytexts.add(Padding(
                padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: (1 / scalevalue), color: fontcolor),
                  )),
                  child: Text(
                    w.name,
                    style: GoogleFonts.ptSerif(
                      color: fontcolor,
                      fontSize: fontsize,
                    ),
                  ),
                ),
              ));
              printedweaponnames.add(w.name.toLowerCase());
            }

            for (var ab in w.abilities!) {
              //add weapon name
              if (!printedweaponabilities.contains(ab.name.toLowerCase())) {
                abilitytexts.add(ability(ab.name, ab.description, false));
                printedweaponabilities.add(ab.name.toLowerCase());
              } else {
                if (!printedweaponnames.contains(w.name)) {
                  abilitytexts.add(ability(ab.name, 'See above.', false));
                }
              }
            }

            for (var n in w.nestedabilities!) {
              if (n.topability.name != '' && n.subabilities.isNotEmpty) {
                if (!abilities.containsKey(n.topability.name.toLowerCase())) {
                  abilitytexts.add(ability(n.topability.name, n.topability.description, false));
                } else {
                  String description = 'See above.';
                  if (abilities.containsKey(n.topability.name.toLowerCase())) {
                    description = 'See ${abilities[n.topability.name.toLowerCase()]}.';
                  }
                  abilitytexts.add(ability(n.topability.name, description, false));
                }
              }

              for (var ab in n.subabilities) {
                if (!abilities.containsKey(ab.name.toLowerCase())) {
                  abilitytexts.add(ability(ab.name, ab.description, true));
                } else {
                  String description = 'See above.';
                  if (abilities.containsKey(ab.name.toLowerCase())) {
                    description = 'See ${abilities[ab.name.toLowerCase()]}.';
                  }
                  abilitytexts.add(ability(ab.name, description, true));
                }
              }
            }
          }
        }

        //remove (modelnum == 1 && product.models.length >= 3) ||
        if ((product.category.toLowerCase().contains('warcaster') && product.models.length > 1 && modelnum == 1) ||
            ((model.title.toLowerCase().contains('warcaster') || model.title.toLowerCase().contains('warlock')) &&
                product.models.length > 1 &&
                modelnum == 1) ||
            (product.models.length <= 2 && modelnum == product.models.length) ||
            (product.models.length >= 3) ||
            (modelnum == product.models.length) ||
            frontprinted) {
          imageKeys.add(GlobalKey());
          GlobalKey lastkey = imageKeys.last;
          Widget back = cardWidget(lastkey, [
            ...backcardparts,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...abilitytexts],
            ),
          ]);
          if (frontprinted && modelnum == 1) {
            frontcards.insert(1, back);
          } else {
            backcards.add(back);
          }
          backcardparts.clear();
          abilitytexts.clear();
        }

        //padding adjustments for multi-model cards:
        modelnum++;
        if (cUnitFirstModel) {
          ypos = (titleheight + 20) / scalevalue;
        } else {
          if (frontcardparts.isNotEmpty) {
            ypos += (10 / scalevalue);
            if (model.weapons!.isEmpty && product.models.length > 1) {
              ypos += (iconsize / scalevalue / 2);
            }
          }
        }
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...frontcards,
            ...backcards,
          ],
        ),
      ),
    );
  }
}

Future<void> capturePng(GlobalKey imageKey) async {
  RenderRepaintBoundary boundary = imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

  html.CanvasElement canvas = html.CanvasElement(
    width: boundary.size.width.toInt(),
    height: boundary.size.height.toInt(),
  );

  final image = await boundary.toImage(pixelRatio: 3.0);
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  final blob = html.Blob([pngBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final html.AnchorElement downloadLink = html.AnchorElement(href: url)..setAttribute('download', 'image.png');

  // download
  downloadLink.click();
}

String cardbackground(String faction, bool front) {
  String asset = 'assets/card_assets/${front ? 'front' : 'back'}/${faction.toLowerCase()}_${front ? 'front' : 'back'}.png'.replaceAll(' ', '_');
  return asset;
}

Widget cardWidget(GlobalKey key, List<Widget> children) {
  return Column(
    children: [
      RepaintBoundary(
        key: key,
        child: SizedBox(
          width: backgroundwidth / scalevalue,
          height: backgroundheight / scalevalue,
          child: Stack(
            children: children,
          ),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () async {
          capturePng(key);
        },
        child: const Text('save'),
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget cardHeader(String productname, String title) {
  const double textleftindent = (20 / scalevalue);
  return Padding(
    padding: const EdgeInsets.only(top: (20 / scalevalue)),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/model_title_box.png',
          width: titlewidth / scalevalue,
          height: titleheight / scalevalue,
        ),
        Padding(
          padding: const EdgeInsets.only(left: textleftindent, top: (14 / scalevalue)),
          child: SizedBox(
            width: (titlewidth / scalevalue) - (80 / scalevalue),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                productname,
                style: GoogleFonts.ptSerif(
                  color: Colors.black,
                  fontSize: 28 / scalevalue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: textleftindent, top: (46 / scalevalue), right: (versionwidth + 10) / scalevalue),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: GoogleFonts.ptSerif(
                color: Colors.black,
                fontSize: (24 / scalevalue),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: (16 / scalevalue)),
          child: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/card_assets/parts/version_box.png',
              width: versionwidth / scalevalue,
              height: versionheight / scalevalue,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: (32 / scalevalue)),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              'WIP',
              style: TextStyle(fontSize: (20 / scalevalue)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget modelstatbar(double y, String modelname, BaseStats stats, bool cUnitFirstModel) {
  // const double scalevalue = 1.5;
  final Widget statbarleft = Image.asset(
    'assets/card_assets/parts/statbar/left.png',
    width: modelstatbarleftwidth / scalevalue,
    height: modelstatbarheight / scalevalue,
  );
  List<Widget> statbarbacks = [];
  List<Widget> statnames = [];
  List<Widget> statvalues = [];

  statbarwidth = 0;

  double toppad = (14 / scalevalue);
  if (modelname.length > 15) toppad += (4 / scalevalue);

  if (stats.spd! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('SPD'));
    statvalues.add(modelstatvalue(stats.spd!));
  }
  if (stats.str! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('STR'));
    statvalues.add(modelstatvalue(stats.str!));
  }
  if (stats.aat! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('AAT'));
    statvalues.add(modelstatvalue(stats.aat!));
  }
  if (stats.mat! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('MAT'));
    statvalues.add(modelstatvalue(stats.mat!));
  }
  if (stats.rat! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('RAT'));
    statvalues.add(modelstatvalue(stats.rat!));
  }
  if (stats.def! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('DEF'));
    statvalues.add(modelstatvalue(stats.def!));
  }
  if (stats.arm! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('ARM'));
    statvalues.add(modelstatvalue(stats.arm!));
  }
  if (stats.cmd! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('CMD'));
    statvalues.add(modelstatvalue(stats.cmd!));
  }
  if (stats.fury! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('FURY'));
    statvalues.add(modelstatvalue(stats.fury!));
  }
  if (stats.thr! != '-') {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
    statnames.add(modelstatname('THR'));
    statvalues.add(modelstatvalue(stats.thr!));
  }

  for (var x = statbarbacks.length; x < 7; x++) {
    statbarbacks.add(Image.asset(
      'assets/card_assets/parts/statbar/mid.png',
      width: modelstatbarpartwidth / scalevalue,
      height: modelstatbarheight / scalevalue,
    ));
  }

  for (var x = statnames.length; x < statbarbacks.length; x++) {
    statnames.insert(0, const SizedBox(width: modelstatbarpartwidth / scalevalue));
    statvalues.insert(0, const SizedBox(width: modelstatbarpartwidth / scalevalue));
  }

  statbarwidth = (modelstatbarpartwidth * statnames.length) + modelstatbarleftwidth;

  statbarbacks.last = Image.asset(
    'assets/card_assets/parts/statbar/right.png',
    width: modelstatbarpartwidth / scalevalue,
    height: modelstatbarheight / scalevalue,
  );

  return Positioned(
    left: !cUnitFirstModel ? (backgroundwidth - statbarwidth - 6) / scalevalue : cUnitFirstModelLeft,
    top: y,
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [statbarleft, ...statbarbacks],
        ),
        Padding(
          padding: EdgeInsets.only(left: 18 / scalevalue, top: toppad),
          child: SizedBox(
            width: (statbarbacks.length - 1) * (modelstatbarpartwidth / scalevalue) + (modelstatbarleftwidth / scalevalue),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                modelname,
                style: GoogleFonts.ptSerif(
                  color: Colors.black,
                  fontSize: (24 / scalevalue),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30 / scalevalue, top: 46 / scalevalue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: statnames,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: (30 / scalevalue), top: (65 / scalevalue)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: statvalues,
          ),
        ),
      ],
    ),
  );
}

Widget modelstatname(String value) {
  double statwidth = modelstatbarpartwidth / scalevalue;
  return SizedBox(
    width: statwidth,
    child: Text(
      value,
      style: GoogleFonts.ptSerif(
        color: Colors.white,
        fontSize: (16 / scalevalue),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget modelstatvalue(String value) {
  double statwidth = modelstatbarpartwidth / scalevalue;
  return SizedBox(
    width: statwidth,
    child: Text(
      value,
      style: GoogleFonts.ptSerif(
        color: Colors.black,
        fontSize: (28 / scalevalue),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget iconbar(double x, double y, double width, List<String> presets) {
  List<Widget> icons = [];
  for (var p in presets) {
    icons.add(presetIcon(p));
  }
  return Padding(
    padding: EdgeInsets.only(left: x, top: y),
    child: SizedBox(
      width: width,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.end,
        children: icons,
      ),
    ),
  );
}

Widget presetIcon(String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: (0.4 / scalevalue)),
    child: Image.asset(
      value,
      width: iconsize / scalevalue,
      height: iconsize / scalevalue,
    ),
  );
}

Widget meleeweaponbar(double x, double y, String weaponname, List<String> stats, Widget xicon, Widget systemicon) {
  List<Widget> statboxes = [];
  for (var s in stats) {
    statboxes.add(meleestatbox(s));
  }
  return Padding(
    padding: EdgeInsets.only(left: x, top: y),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/weapons/melee_weapon_box.png',
          width: meleeweaponbarwidth / scalevalue,
          height: meleeweaponbarheight / scalevalue,
        ),
        weaponnamebox(meleeweaponbarwidth / scalevalue, weaponname, 'melee'),
        SizedBox(
          width: meleeweaponbarwidth / scalevalue,
          height: meleeweaponbarheight / scalevalue,
          child: Padding(
            padding: const EdgeInsets.only(left: (58 / scalevalue), top: (50 / scalevalue)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: statboxes,
            ),
          ),
        ),
        xicon,
        systemicon,
      ],
    ),
  );
}

Widget meleestatbox(String value) {
  const double statwidth = meleeweaponbarwidth / scalevalue / 4;
  return SizedBox(
    width: statwidth,
    child: Text(
      value,
      style: GoogleFonts.ptSerif(
        color: Colors.black,
        fontSize: (20 / scalevalue),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget rangedweaponbar(double x, double y, String weaponname, List<String> stats, Widget xicon, Widget systemicon) {
  List<Widget> statboxes = [];
  for (var s in stats) {
    statboxes.add(rangedstatbox(s));
  }
  return Padding(
    padding: EdgeInsets.only(left: x, top: y),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/weapons/range_weapon_box.png',
          width: rangedweaponbarwidth / scalevalue,
          height: rangedweaponbarheight / scalevalue,
        ),
        weaponnamebox(rangedweaponbarwidth / scalevalue, weaponname, 'ranged'),
        SizedBox(
          width: rangedweaponbarwidth / scalevalue,
          height: rangedweaponbarheight / scalevalue,
          child: Padding(
            padding: const EdgeInsets.only(left: 28, top: 24.5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: statboxes,
            ),
          ),
        ),
        xicon,
        systemicon,
      ],
    ),
  );
}

Widget rangedstatbox(String value) {
  const double statwidth = rangedweaponbarwidth / scalevalue / 5;
  return SizedBox(
    width: statwidth,
    child: Text(
      value,
      style: GoogleFonts.ptSerif(
        color: Colors.black,
        fontSize: (20 / scalevalue),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget mountweaponbar(double x, double y, String weaponname, List<String> stats) {
  List<Widget> statboxes = [];
  for (var s in stats) {
    statboxes.add(mountstatbox(s));
  }
  return Padding(
    padding: EdgeInsets.only(left: x, top: y, right: (10 / scalevalue)),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/weapons/mount_weapon_box.png',
          width: mountweaponbarwidth / (scalevalue),
          height: mountweaponbarheight / (scalevalue),
        ),
        weaponnamebox(mountweaponbarwidth / scalevalue, weaponname, 'mount'),
        SizedBox(
          width: mountweaponbarwidth / (scalevalue),
          height: mountweaponbarheight / (scalevalue),
          child: Padding(
            padding: const EdgeInsets.only(left: (56 / scalevalue), top: (51 / scalevalue)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: statboxes,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget mountstatbox(String value) {
  const double statwidth = mountweaponbarwidth / (scalevalue) / 3;
  return SizedBox(
    width: statwidth,
    child: Text(
      value,
      style: GoogleFonts.ptSerif(
        color: Colors.black,
        fontSize: (20 / scalevalue),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget weaponnamebox(double width, String name, String type) {
  double toppad = (18 / scalevalue);
  if (name.length > 15 && type == 'mount') toppad += (18 / scalevalue);
  if (name.length > 20 && type == 'melee') toppad += (6 / scalevalue);
  return SizedBox(
    width: width - (8 / scalevalue),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 6, top: toppad),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: GoogleFonts.ptSerif(
              color: Colors.black,
              fontSize: (26 / scalevalue),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget pointcost(String cost, bool bgp) {
  return Padding(
    padding: const EdgeInsets.only(top: ((backgroundheight / scalevalue) - (pccostheight / scalevalue) - (27 / scalevalue))),
    child: Stack(
      children: [
        Image.asset(
          bgp ? 'assets/card_assets/parts/bgp_box.png' : 'assets/card_assets/parts/pc_solo_box.png',
          width: pccostwidth / scalevalue,
          height: pccostheight / scalevalue,
        ),
        Padding(
          padding: const EdgeInsets.only(top: (24 / scalevalue)),
          child: SizedBox(
            width: pccostwidth / scalevalue,
            height: pccostheight / scalevalue - (30 / scalevalue),
            child: Center(
              child: Text(
                bgp ? '+$cost' : cost,
                style: GoogleFonts.ptSerif(
                  color: Colors.black,
                  fontSize: (24 / scalevalue),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget unitpointcost(List<String> costs) {
  const double scaledfontsize = 14 / scalevalue;
  int maxlines = 2;
  if (costs.length == 2) {
    maxlines = 1;
  }
  if (costs[0].length > 30) {
    maxlines = 3;
  }

  return Padding(
    padding: const EdgeInsets.only(top: ((backgroundheight / scalevalue) - (unitpccostheight / scalevalue) - (10 / scalevalue))),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/pc_unit_box.png',
          width: unitpccostwidth / scalevalue,
          height: unitpccostheight / scalevalue,
        ),
        SizedBox(
          width: unitpccostwidth / scalevalue - (10 / scalevalue),
          height: unitpccostheight / scalevalue,
          child: Padding(
            padding: const EdgeInsets.only(left: (70 / scalevalue)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                costs.length == 2
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          costs[0],
                          maxLines: costs.length == 2 ? 1 : 2,
                          style: GoogleFonts.ptSerif(
                            color: Colors.black,
                            fontSize: (20 / scalevalue),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text(
                        costs[0],
                        maxLines: maxlines,
                        style: GoogleFonts.ptSerif(
                          color: Colors.black,
                          fontSize: costs[0].length < 30 ? (20 / scalevalue) : scaledfontsize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                if (costs.length > 1)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      costs[1],
                      style: GoogleFonts.ptSerif(
                        color: Colors.black,
                        fontSize: (20 / scalevalue),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget fieldallowance(String value) {
  return Padding(
    padding: const EdgeInsets.only(top: ((backgroundheight / scalevalue) - (faheight / scalevalue) - (10 / scalevalue))),
    child: Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          Image.asset(
            'assets/card_assets/parts/fa_box.png',
            width: fawidth / scalevalue,
            height: faheight / scalevalue,
          ),
          SizedBox(
            width: fawidth / scalevalue,
            child: Padding(
              padding: const EdgeInsets.only(top: (28 / scalevalue)),
              child: Text(
                value,
                style: GoogleFonts.ptSerif(
                  color: Colors.white,
                  fontSize: (30 / scalevalue),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget leaderhpbar(int hp) {
  List<Widget> hpboxes = [];
  const double maxhp = 25 + 1;
  const double hpareawidth = 728;
  const double hpareaheight = 30;
  for (int x = 0; x < (maxhp - 1); x++) {
    if (x < hp) {
      if (x == 0) {
        hpboxes.insert(
            0,
            SizedBox(
              width: hpareawidth / scalevalue / maxhp,
              height: hpareaheight / scalevalue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey.shade700,
                      size: 18 / scalevalue,
                    ),
                  ),
                ),
              ),
            ));
      } else {
        hpboxes.insert(
            0,
            SizedBox(
              width: hpareawidth / scalevalue / maxhp,
              height: hpareaheight / scalevalue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                child: Container(
                  decoration: BoxDecoration(
                    color: (x) % 5 != 0 ? Colors.white : Colors.grey.shade400,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ));
      }
    } else {
      hpboxes.insert(
          0,
          SizedBox(
            width: (hpareawidth / scalevalue) / maxhp,
            height: hpareaheight / scalevalue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.grey.shade800),
                ),
              ),
            ),
          ));
    }
  }

  hpboxes.insert(0, const SizedBox(width: 25 / scalevalue));

  return Padding(
    padding: const EdgeInsets.only(
        top: ((backgroundheight / scalevalue) - (leaderhpbarheight / scalevalue) - (faheight / scalevalue) - (30 / scalevalue))),
    child: Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          Image.asset(
            'assets/card_assets/parts/leader_hp_box.png',
            width: leaderhpbarwidth / scalevalue,
            height: leaderhpbarheight / scalevalue,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.5 / scalevalue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: hpboxes,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget doubleleaderhpbar(int hp) {
  List<Widget> hpboxes = [];
  const double maxhp = leaderhprowmaxhp + 2;
  const double hpareawidth = 588;
  const double hpareaheight = 30;
  List<Widget> bottomrow = [];
  const spacerwidth = 30 / scalevalue;

  for (int x = 0; x < (hp - 2); x++) {
    if (x < hp) {
      if (x == (maxhp - 2)) {
        hpboxes.insert(0, const SizedBox(width: spacerwidth));
        bottomrow.addAll(hpboxes);
        hpboxes = [];
      }
      if (x == 0) {
        hpboxes.insert(
            0,
            SizedBox(
              width: hpareawidth / scalevalue / maxhp,
              height: hpareaheight / scalevalue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey.shade700,
                      size: 18 / scalevalue,
                    ),
                  ),
                ),
              ),
            ));
      } else {
        hpboxes.insert(
            0,
            SizedBox(
              width: hpareawidth / scalevalue / maxhp,
              height: hpareaheight / scalevalue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                child: Container(
                  decoration: BoxDecoration(
                    color: (x) % 5 != 0 ? Colors.white : Colors.grey.shade400,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ));
      }
    } else {
      hpboxes.insert(
          0,
          SizedBox(
            width: (hpareawidth / scalevalue) / maxhp,
            height: hpareaheight / scalevalue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.grey.shade800),
                ),
              ),
            ),
          ));
    }
  }

  for (var x = hpboxes.length; x < maxhp - 2; x++) {
    hpboxes.insert(
        0,
        SizedBox(
          width: (hpareawidth / scalevalue) / maxhp,
          height: hpareaheight / scalevalue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.grey.shade800),
              ),
            ),
          ),
        ));
  }

  hpboxes.insert(0, const SizedBox(width: spacerwidth));

  return Padding(
    padding: const EdgeInsets.only(
      top: (backgroundheight - battleenginehpbarheight - 10) / scalevalue,
    ),
    child: Stack(
      children: [
        Image.asset(
          'assets/card_assets/parts/battle_engine_hp_box.png',
          width: battleenginehpbarwidth / scalevalue,
          height: battleenginehpbarheight / scalevalue,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.5 / scalevalue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [...hpboxes],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 39 / scalevalue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [...bottomrow],
          ),
        ),
      ],
    ),
  );
}

Widget unithpbars(List<int> hps, List<String> names) {
  List<Widget> hpbars = [];
  const double maxhp = 11; //max of 10 plus an additional 1
  const double hpareawidth = 312;
  const double hpareaheight = 30.25;
  int barnum = 0;

  for (int h in hps) {
    List<Widget> hpboxes = [];

    if (h > 1) {
      for (int x = 0; x < (maxhp - 1); x++) {
        if (x < h) {
          if (x == 0) {
            hpboxes.insert(
                0,
                SizedBox(
                  width: hpareawidth / scalevalue / maxhp,
                  height: hpareaheight / scalevalue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.grey.shade700,
                          size: 18 / scalevalue,
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            hpboxes.insert(
                0,
                SizedBox(
                  width: hpareawidth / scalevalue / maxhp,
                  height: hpareaheight / scalevalue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (x) % 5 != 0 ? Colors.white : Colors.grey.shade400,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ));
          }
        } else {
          hpboxes.insert(
              0,
              SizedBox(
                width: hpareawidth / scalevalue / maxhp,
                height: hpareaheight / scalevalue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.5 / scalevalue),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ));
        }
      }

      hpboxes.insert(0, const SizedBox(width: 15 / scalevalue));

      hpbars.add(
        Stack(
          children: [
            Image.asset(
              'assets/card_assets/parts/10_hp_template.png',
              width: tenhpbarwidth / scalevalue,
              height: tenhpbarheight / scalevalue,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.25 / scalevalue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: hpboxes,
              ),
            ),
            SizedBox(
              width: tenhpbarwidth / scalevalue,
              height: tenhpbarheight / scalevalue,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: (5 / scalevalue)),
                  child: Text(
                    names[barnum],
                    style: GoogleFonts.ptSerif(
                      color: Colors.black,
                      fontSize: (16 / scalevalue),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    barnum++;
  }

  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: (30 / scalevalue), bottom: (100 / scalevalue)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: hpbars,
      ),
    ),
  );
}

Widget sourceIcon(String image) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: (6 / scalevalue), vertical: (4 / scalevalue)),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width: sourceiconsize / scalevalue,
        height: sourceiconsize / scalevalue,
        child: Image.asset(
          image,
          width: sourceiconsize / scalevalue,
          height: sourceiconsize / scalevalue,
        ),
      ),
    ),
  );
}

Widget weaponX(String image) {
  return Padding(
    padding: const EdgeInsets.only(left: (36 / scalevalue), top: (84 / scalevalue)),
    child: SizedBox(
      width: iconsize / scalevalue / 1.5,
      height: iconsize / scalevalue / 1.5,
      child: Image.asset(
        image,
        width: iconsize / scalevalue / 1.5,
        height: iconsize / scalevalue / 1.5,
      ),
    ),
  );
}

Widget weaponSystem(String system) {
  const double systemsize = 32 / scalevalue;
  return Padding(
    padding: const EdgeInsets.only(left: (36 / scalevalue), top: (50 / scalevalue)),
    child: CircleAvatar(
      maxRadius: systemsize / 2,
      backgroundColor: Colors.blueGrey,
      child: Text(
        system,
        style: GoogleFonts.ptSerif(
          color: Colors.black,
          fontSize: 22 / scalevalue,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget cardgrid(double x, double y, Grid gridvalues, int shieldvalue, int startcolumn) {
  double fontsize = 16.5 / scalevalue;
  // Color textcolor = Colors.grey[200]!;
  Color bordercolor = Colors.grey.shade600;
  List<Widget> grid = [];
  int col = startcolumn;
  int max = col + 5;

  // if (gridvalues.columns.length > 6) {
  //   max = 11;
  // }

  for (var c = startcolumn; c <= max; c++) {
    // col++;
    // if (col > 6) {
    //   col = 1;
    //   grid.add(const SizedBox(width: 5));
    // }
    List<Widget> column = [];
    // column.add(
    //   Padding(
    //     padding: EdgeInsets.only(top: shieldvalue > 0 ? fontsize + 5 : 0),
    //     child: Text(col.toString(),
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           color: textcolor,
    //           fontSize: fontsize,
    //         )),
    //   ),
    // );
    for (int rownum = 0; rownum < gridvalues.columns[c].boxes.length; rownum++) {
      GridBox r = gridvalues.columns[c].boxes[rownum];
      String system = r.system;
      Color boxborder = bordercolor;
      Color fillColor;
      // bool filled = false;
      // if (army.hptracking.isNotEmpty && army.deploying) {
      //   filled = army.hptracking[widget.listindex!][widget.listmodelindex!]['grid'][c][rownum];
      // }
      if (r.system == '-') {
        fillColor = Colors.black;
      } else {
        fillColor = Colors.white;
      }
      if (r.system == '-' || r.system == 'x') {
        system = '';
      }
      // if (widget.deployed && filled) {
      //   fillColor = Colors.red;
      //   // boxborder = fillColor;
      // }

      Widget gridBox =
          // GestureDetector(
          //   onTap: () {
          //     // if (r.system != '-' && widget.listindex != null) {
          //     //   army.adjustGridDamage(widget.listindex!, widget.listmodelindex!, c, rownum);
          //     // }
          //   },
          // child:
          Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5 / scalevalue, horizontal: 4 / scalevalue),
            child: SizedBox.square(
              dimension: gridsquaresize / scalevalue,
              child: Container(
                color: fillColor,
                child: Center(
                  child: Text(
                    system,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: fontsize,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5 / scalevalue, horizontal: 4 / scalevalue),
            child: SizedBox.square(
              dimension: gridsquaresize / scalevalue,
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: (3 / scalevalue), color: boxborder), color: Colors.transparent),
              ),
            ),
          ),
        ],
      );
      // );
      column.add(gridBox);
    }
    grid.add(Column(
      mainAxisSize: MainAxisSize.min,
      children: column,
    ));
  }

  String gridText = 'Damage';
  if (gridvalues.columns.length > 6 && startcolumn == 0) gridText = 'Left Damage';
  if (gridvalues.columns.length > 6 && startcolumn == 6) gridText = 'Right Damage';

  return Padding(
    // padding: const EdgeInsets.only(left: 25 / scalevalue, bottom: 120 / scalevalue),
    padding: EdgeInsets.only(left: x, top: y),
    child: SizedBox(
      width: gridwidth / scalevalue,
      height: gridheight / scalevalue,
      child: Stack(
        children: [
          Image.asset(
            'assets/card_assets/parts/jack_grid_box.png',
            width: gridwidth / scalevalue,
            height: gridheight / scalevalue,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8 / scalevalue),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  gridText,
                  style: GoogleFonts.ptSerif(
                    color: Colors.white,
                    fontSize: (20 / scalevalue),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 33),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: grid,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cardweb(double x, double y, List<int> values, bool huge) {
  int outer = values[0];
  int middle = values[1];
  int inner = values[2];

  final double smallscale = huge ? 1 : 0.9;

  double dotsize = 24 / scalevalue * smallscale;
  const double outerradius = 180;
  const double middleradius = 130;
  const double innerradius = 80;
  const double padding = 25;
  double framesize = (outerradius * 2 + padding * 2) / scalevalue * smallscale;
  double framecenter = outerradius / scalevalue * smallscale;

  double framexoffset = (webwidth - (outerradius * 2 + padding * 2) + 4) / 2 / scalevalue * smallscale;
  double frameyoffset = (webheight - (outerradius * 2 + padding * 2)) / 2 / scalevalue * smallscale;

  const double ringexpansion = 2;

  List<Widget> outerWidgets = List.generate(
      outer,
      (index) =>
          ring(outerradius / scalevalue * smallscale, (360 / outer * index) - 90, dotsize, framecenter, 0, index, padding / scalevalue * smallscale));
  List<Widget> middleWidgets = List.generate(
      middle,
      (index) => ring(
          middleradius / scalevalue * smallscale, (360 / middle * index) + 90, dotsize, framecenter, 1, index, padding / scalevalue * smallscale));
  List<Widget> innerWidgets = List.generate(
      inner,
      (index) =>
          ring(innerradius / scalevalue * smallscale, (360 / inner * index) - 90, dotsize, framecenter, 2, index, padding / scalevalue * smallscale));

  outerWidgets.insert(
      0,
      Positioned(
        left: framexoffset,
        top: frameyoffset,
        child: Container(
          height: (outerradius + ringexpansion) * 2 / scalevalue * smallscale,
          width: (outerradius + ringexpansion) * 2 / scalevalue * smallscale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 6 / scalevalue * smallscale, color: Colors.white),
          ),
        ),
      ));

  middleWidgets.insert(
      0,
      Positioned(
        left: framexoffset + framecenter - ((middleradius) / scalevalue * smallscale),
        top: frameyoffset + framecenter - ((middleradius) / scalevalue * smallscale),
        child: Container(
            height: (middleradius + ringexpansion) * 2 / scalevalue * smallscale,
            width: (middleradius + ringexpansion) * 2 / scalevalue * smallscale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 6 / scalevalue * smallscale, color: Colors.white),
            )),
      ));

  innerWidgets.insert(
      0,
      Positioned(
        left: framexoffset + framecenter - ((innerradius) / scalevalue * smallscale),
        top: frameyoffset + framecenter - ((innerradius) / scalevalue * smallscale),
        child: Container(
            height: (innerradius + ringexpansion) * 2 / scalevalue * smallscale,
            width: (innerradius + ringexpansion) * 2 / scalevalue * smallscale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 6 / scalevalue * smallscale, color: Colors.white),
            )),
      ));

  List<Widget> web = [];
  web.addAll(outerWidgets);
  web.addAll(middleWidgets);
  web.addAll(innerWidgets);

  return Positioned(
    left: x,
    top: y,
    child: Stack(children: [
      SizedBox(
        width: webwidth / scalevalue * smallscale,
        height: webheight / scalevalue * smallscale,
        child: Image.asset(
          'assets/card_assets/parts/infernal_circle.png',
          width: webwidth / scalevalue * smallscale,
          height: webheight / scalevalue * smallscale,
        ),
      ),
      Positioned(
        left: framexoffset,
        top: frameyoffset,
        child: SizedBox(
          height: framesize,
          width: framesize,
          child: Stack(children: [
            ...web,
          ]),
        ),
      ),
    ]),
  );
}

Widget ring(double radius, double angle, double dotsize, double center, int ringindex, int dotindex, double padding) {
  final double rad = radians(angle);
  Widget box = webBox(Colors.black, dotsize, ringindex, dotindex);
  return Positioned(
    top: center + (dotsize / 2) + (radius * sin(rad)) - (padding / 4),
    left: center + (dotsize / 2) + (radius * cos(rad)) - (padding / 4),
    child: box,
  );
}

Widget webBox(Color color, double dotsize, int ringindex, int dotindex) {
  Color dotcolor = Colors.white;

  return Container(
    decoration: BoxDecoration(border: Border.all(width: 1.5, color: color), shape: BoxShape.circle),
    child: Container(
      height: dotsize,
      width: dotsize,
      decoration: BoxDecoration(shape: BoxShape.circle, color: dotcolor),
    ),
  );
}

Widget fieldoffiretop(double x, double y, String value) {
  return Padding(
    padding: EdgeInsets.only(left: x, top: y),
    child: SizedBox(
      width: fieldoffireboxwidth / scalevalue,
      height: fieldoffireboxheight / scalevalue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/card_assets/parts/weapon_field_of_fire_box.png',
            width: fieldoffireboxwidth / scalevalue,
            height: fieldoffireboxheight / scalevalue,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              value,
              style: GoogleFonts.ptSerif(
                color: Colors.white,
                fontSize: (20 / scalevalue),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

//

Widget spiralBox(Color color, double dotsize, int branchnum, int dotnum) {
  double size = dotsize;

  if (branchnum.isEven) {
    if (dotnum == 0) size = dotsize - (2 / scalevalue);
    if (dotnum == 1) size = dotsize - (1 / scalevalue);
  }

  return GestureDetector(
    onTap: () {
      // if (listindex != null && modellistindex != null) {
      //   army.adjustSpiralDamage(listindex, modellistindex, branchnum, dotnum);
      // }
    },
    child: SizedBox(
      height: dotsize,
      width: dotsize,
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.5 / scalevalue, color: color),
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget spiralBackground(Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}

Widget spiralbranch(double angle, double dotsize, double centerx, double centery, int branchindex, int dotindex, double topoffset, double leftoffset,
    Color bordercolor) {
  final double rad = radians(angle);
  Widget box = spiralBox(bordercolor, dotsize, branchindex, dotindex - 2);

  return Positioned(
    top: centery + ((dotindex - 0.5) * dotsize * sin(rad) * 0.9) + topoffset,
    left: centerx + ((dotindex - 0.5) * dotsize * cos(rad) * 0.9) + leftoffset,
    child: box,
  );
}

Widget spellHeaders(double width, double fontsize, Color textcolor) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Text('SPELLS',
                textAlign: TextAlign.left,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("COST",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("RNG",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("AOE",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("POW",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("DUR",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("OFF",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget spellStats(Spell sp, double width, double fontsize, Color textcolor) {
  String cost = sp.cost;
  String rng = sp.rng;
  String aoe = sp.aoe ?? '-';
  String pow = sp.pow ?? '-';
  String dur = sp.dur ?? '-';
  String off = sp.off;
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(sp.name.toString().toUpperCase(),
                  style: GoogleFonts.ptSerif(
                    color: textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize,
                  )),
            ),
            Text(cost,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(rng,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(aoe,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(pow,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(dur.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(off,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget spellDescription(String description, double width, double fontsize, Color textcolor) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 3, right: 5),
      child: Text(
        description,
        style: GoogleFonts.ptSerif(
          color: textcolor,
          fontSize: fontsize,
        ),
      ),
    ),
  );
}

Widget animusHeaders(double width, double fontsize, Color textcolor) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.brown.shade300),
          children: [
            Text('ANIMUS',
                textAlign: TextAlign.left,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("COST",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("RNG",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("AOE",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("POW",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("DUR",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("OFF",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget animusStats(Animus sp, double width, double fontsize, Color textcolor) {
  String cost = sp.cost;
  String rng = sp.rng;
  String aoe = sp.aoe ?? '-';
  String pow = sp.pow ?? '-';
  String dur = sp.dur ?? '-';
  String off = sp.off;

  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: (30 / scalevalue)),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(sp.name.toString().toUpperCase(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.ptSerif(
                      color: textcolor,
                      fontSize: fontsize,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Text(cost,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(rng,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(aoe,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(pow,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(dur.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(off,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget featCard(Product p, Model m, String selectedfaction) {
  List<Widget> parts = [];
  List<Widget> texts = [];
  Product product = p;
  Model model = m;

  if (product.primaryFaction.toString().toLowerCase().contains(selectedfaction)) {
    parts.add(Image.asset(
      cardbackground(selectedfaction, false),
      width: backgroundwidth / scalevalue,
      height: backgroundheight / scalevalue,
    ));
  } else {
    parts.add(Image.asset(
      cardbackground(product.primaryFaction[0], false),
      width: backgroundwidth / scalevalue,
      height: backgroundheight / scalevalue,
    ));
  }

  parts.add(
    FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.only(top: 25 / scalevalue, left: 20 / scalevalue, right: 20 / scalevalue),
        child: Text(
          product.name,
          style: GoogleFonts.ptSerif(
            color: fontcolor,
            fontSize: 36 / scalevalue,
          ),
        ),
      ),
    ),
  );
  // backcardparts.add(cardHeader(product.name, model.title));
  texts.add(const SizedBox(
    height: 120 / scalevalue,
  ));

  String title = '';
  String description = '';

  if (model.feat!.name != '') {
    title = 'FEAT: ${model.feat!.name.toUpperCase()}';
    description = model.feat!.description;
  }

  if (model.arcana!.name != '') {
    title = 'ARCANA: ${model.arcana!.name.toUpperCase()}';
    description = model.arcana!.description;
  }

  texts.add(SizedBox(
    width: (backgroundwidth - 200) / scalevalue,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4 / scalevalue),
      color: Colors.brown.shade300,
      child: Text(
        title,
        style: GoogleFonts.ptSerif(
          color: fontcolor,
          fontSize: 22 / scalevalue,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ));

  texts.add(Padding(
    padding: const EdgeInsets.symmetric(vertical: 8 / scalevalue),
    child: SizedBox(
      width: (backgroundwidth - 200) / scalevalue,
      child: Text(
        description,
        style: GoogleFonts.ptSerif(
          color: fontcolor,
          fontSize: 20 / scalevalue,
        ),
      ),
    ),
  ));

  return SizedBox(
    width: backgroundwidth / scalevalue,
    height: backgroundheight / scalevalue,
    child: Stack(
      children: [
        ...parts,
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [...texts],
          ),
        ),
      ],
    ),
  );
}

Widget spellCard(Product p, Model m, String selectedfaction, List<Spell> spells) {
  List<Widget> parts = [];
  List<Widget> texts = [];
  Product product = p;
  Model model = m;

  if (product.primaryFaction.toString().toLowerCase().contains(selectedfaction)) {
    parts.add(Image.asset(
      cardbackground(selectedfaction, false),
      width: backgroundwidth / scalevalue,
      height: backgroundheight / scalevalue,
    ));
  } else {
    parts.add(Image.asset(
      cardbackground(product.primaryFaction[0], false),
      width: backgroundwidth / scalevalue,
      height: backgroundheight / scalevalue,
    ));
  }
  parts.add(
    FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.only(top: 25 / scalevalue, left: 20 / scalevalue, right: 20 / scalevalue),
        child: Text(
          product.name,
          style: GoogleFonts.ptSerif(
            color: fontcolor,
            fontSize: 36 / scalevalue,
          ),
        ),
      ),
    ),
  );

  texts.add(const SizedBox(
    height: 95 / scalevalue,
  ));

  texts.add(spellHeaders(backgroundwidth / scalevalue, fontsize, fontcolor));
  for (var sp in spells) {
    texts.add(spellStats(sp, backgroundwidth / scalevalue, fontsize, fontcolor));
    texts.add(spellDescription(sp.description, backgroundwidth / scalevalue, fontsize, fontcolor));
  }

  return SizedBox(
    width: backgroundwidth / scalevalue,
    height: backgroundheight / scalevalue,
    child: Stack(
      children: [
        ...parts,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [...texts],
        ),
      ],
    ),
  );
}

Widget ability(String name, String description, bool nested) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30 / scalevalue),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (nested)
          SizedBox(
            width: 15,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '• ',
                style: GoogleFonts.ptSerif(
                  color: fontcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                ),
              ),
            ),
          ),
        Expanded(
          child: Text.rich(
            textAlign: TextAlign.left,
            TextSpan(
              text: name,
              style: GoogleFonts.ptSerif(
                color: fontcolor,
                fontWeight: FontWeight.bold,
                fontSize: fontsize,
              ),
              children: [
                TextSpan(
                  text: ' - $description',
                  style: GoogleFonts.ptSerif(
                    color: fontcolor,
                    fontWeight: FontWeight.normal,
                    fontSize: fontsize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class SpiralBranchLinePainter extends CustomPainter {
  final List<Map<String, double>> points;
  final double halfdotsize;

  SpiralBranchLinePainter(this.points, this.halfdotsize);

  @override
  void paint(Canvas canvas, Size size) {
    final double midpoint = (spiralframedimension - (halfdotsize * scalevalue)) / scalevalue;
    final controlpoints = List.generate(
        points.length,
        (index) =>
            Offset((midpoint + points[index]['left']! + halfdotsize) / scalevalue, (midpoint + points[index]['top']! + halfdotsize) / scalevalue));

    final spline = CatmullRomSpline(controlpoints);

    final bezierPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..color = Colors.white.withAlpha(80);
    canvas.drawPoints(ui.PointMode.points, spline.generateSamples().map((e) => e.value).toList(), bezierPaint);
  }

  @override
  bool shouldRepaint(SpiralBranchLinePainter oldDelegate) => false;
}
// if (shieldvalue > 0) {
//   var shieldWidget = Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Text(
//         'Force\nField',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: fontsize,
//         ),
//       ),
//       Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: List.generate(
//               6,
//               (index) => shieldBox(
//                 index >= (6 - (shieldvalue / 2)),
//                 army,
//                 widget.listindex,
//                 widget.listmodelindex,
//                 0,
//                 index,
//               ),
//             ),
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: List.generate(
//               6,
//               (index) => shieldBox(
//                 index >= (6 - (shield / 2)),
//                 army,
//                 widget.listindex,
//                 widget.listmodelindex,
//                 1,
//                 index,
//               ),
//             ),
//           ),
//         ],
//       )
//     ],
//   );

Widget cardspiral(double x, double y, List<int> branchvalues, String size) {
  const double spacing = 62 / scalevalue;
  const double dotsize = 28 / scalevalue;
  double backsize = dotsize + (20 / scalevalue);

  List<Widget> arms = [];
  List<Widget> backs = [];
  List<Widget> spiral = [];
  List<Widget> lines = [];
  List<Widget> texts = [];
  List<List<Map<String, double>>> points = [];
  double left;
  double top;

  int maxdots = 0;

  for (var b in branchvalues) {
    if (b > maxdots) maxdots = b;
  }

  maxdots += 1;

  if (maxdots < 8) size = 'normal';

  for (var branch = 0; branch < 6; branch++) {
    double angle = radians(branch * (360 / 6) + 15);

    if (branch.isOdd) {
      angle = radians(branch * (360 / 6));
    }

    double r = 0;
    Map<String, double> point;
    points.add([]);
    for (var x = 0; x <= maxdots; x++) {
      int dot = x;

      if (branch.isOdd) {
        dot += 1;
        if (x == 0) {
          r = 1.005;
          angle += asin(1 / r);
        }
      }

      r = dot == 0 ? 1 : sqrt(dot) * 2;

      angle += asin(1 / r);

      left = (r * spacing * cos(angle));
      top = (r * spacing * sin(angle));

      point = {'left': left, 'top': top};
      points[branch].add(point);
    }
  }

  for (var branch = 0; branch < 6; branch++) {
    Color color = Colors.black;
    Color backcolor = Colors.black;
    switch (branch + 1) {
      case 1 || 2:
        color = Colors.blue;
        backcolor = Colors.blue.shade800;
        break;
      case 3 || 4:
        color = Colors.red;
        backcolor = Colors.red.shade800;
        break;
      default:
        color = Colors.green;
        backcolor = Colors.green.shade800;
    }

    double midpoint = (spiralframedimension - (spacing * scalevalue) / 2) / scalevalue;

    for (var dot = 0; dot < branchvalues[branch]; dot++) {
      arms.add(
        Positioned(
          left: (midpoint + points[branch][dot]['left']!) / scalevalue,
          top: (midpoint + points[branch][dot]['top']!) / scalevalue,
          child: spiralBox(color, dotsize, branch, dot),
        ),
      );
      backs.add(
        Positioned(
          left: ((midpoint + points[branch][dot]['left']!) / scalevalue) - ((backsize - dotsize) / 2),
          top: ((midpoint + points[branch][dot]['top']!) / scalevalue) - ((backsize - dotsize) / 2),
          child: spiralBackground(backcolor, backsize),
        ),
      );
    }

    if (branch.isOdd) {
      points[branch].insert(0, points[branch - 1][1]);
      points[branch].removeLast();
      points[branch].removeLast();
      switch (branch) {
        case 1:
          if (size != 'normal') {
            texts.add(Positioned(
              left: (midpoint + 55 + points[branch][4]['left']!) / scalevalue,
              top: (midpoint + points[branch][4]['top']!) / scalevalue,
              child: Transform.rotate(
                angle: radians(125),
                child: CurvedText(
                  curvature: -0.01,
                  text: 'MIND',
                  textStyle: GoogleFonts.ptSerif(
                    fontSize: 20 / scalevalue,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ));
          } else {
            texts.add(Positioned(
              left: (midpoint + 50 + points[branch][3]['left']!) / scalevalue,
              top: (midpoint + 10 + points[branch][3]['top']!) / scalevalue,
              child: Transform.rotate(
                angle: radians(95),
                child: CurvedText(
                  curvature: -0.01,
                  text: 'MIND',
                  textStyle: GoogleFonts.ptSerif(
                    fontSize: 18 / scalevalue,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ));
          }
          break;
        case 3:
          if (size != 'normal') {
            texts.add(Positioned(
                left: (midpoint + points[branch][4]['left']!) / scalevalue,
                top: (midpoint + 40 + points[branch][4]['top']!) / scalevalue,
                child: Transform.rotate(
                  angle: radians(55),
                  child: CurvedText(
                    curvature: 0.01,
                    text: 'BODY',
                    textStyle: GoogleFonts.ptSerif(
                      fontSize: 20 / scalevalue,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )));
          } else {
            texts.add(Positioned(
                left: (midpoint + points[branch][3]['left']!) / scalevalue,
                top: (midpoint + 40 + points[branch][3]['top']!) / scalevalue,
                child: Transform.rotate(
                  angle: radians(30),
                  child: CurvedText(
                    curvature: 0.01,
                    text: 'BODY',
                    textStyle: GoogleFonts.ptSerif(
                      fontSize: 18 / scalevalue,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )));
          }
          break;
        case 5:
          if (size != 'normal') {
            texts.add(Positioned(
                left: (midpoint + points[branch][4]['left']!) / scalevalue,
                top: (midpoint - 15 + points[branch][4]['top']!) / scalevalue,
                child: Transform.rotate(
                  angle: radians(-10),
                  child: CurvedText(
                    curvature: -0.01,
                    text: 'SPIRIT',
                    textStyle: GoogleFonts.ptSerif(
                      fontSize: 20 / scalevalue,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )));
          } else {
            texts.add(Positioned(
                left: (midpoint + points[branch][3]['left']!) / scalevalue,
                top: (midpoint - 15 + points[branch][3]['top']!) / scalevalue,
                child: Transform.rotate(
                  angle: radians(-30),
                  child: CurvedText(
                    curvature: -0.01,
                    text: 'SPIRIT',
                    textStyle: GoogleFonts.ptSerif(
                      fontSize: 18 / scalevalue,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )));
          }
          break;
      }
    }

    arms.add(
      Positioned(
        left: (midpoint + points[branch].last['left']!) / scalevalue,
        top: (midpoint + points[branch].last['top']!) / scalevalue,
        child: spiralArmNum(branch, dotsize + (6 / scalevalue), backcolor),
      ),
    );

    lines.add(Container(
      child: spiralLineWidget(points[branch], dotsize * scalevalue / 2),
    ));

    // arm.add(
    //   Positioned(
    //     left: points[h][points[h].length - 1]['left']! + leftmost,
    //     top: points[h][points[h].length - 1]['top']! + topmost,
    //     child: spiralArmNum(h, dotsize, color),
    //   ),
    // );
    // backs.add(back);
  }

  double blurradius = 20;
  double spreadradius = 0;
  if (size == 'large') blurradius = 70;
  if (size == 'huge') {
    blurradius = 50;
    spreadradius = 50;
  }

  spiral.add(
    Stack(children: [
      // ...backs,
      Center(
        child: Container(
          width: 350 / scalevalue,
          height: 350 / scalevalue,
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.black, width: 6 / scalevalue),
          //   shape: BoxShape.circle,
          //   color: Colors.white54,
          // ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                spreadRadius: spreadradius / scalevalue,
                blurRadius: blurradius / scalevalue,
                color: Colors.white54,
              )
            ],
          ),
        ),
      ),
      SizedBox(
          width: beastspiralwidth / scalevalue,
          height: beastspiralheight / scalevalue,
          child: Image.asset('assets/card_assets/parts/beast_spiral_$size.png')),
      ...lines,
      ...arms,
      ...texts,
    ]),
  );

  Widget beastspiral = Stack(
    children: [...spiral],
  );

  return Positioned(
    left: x,
    top: y,
    child: SizedBox(
      width: spiralframedimension / scalevalue,
      height: spiralframedimension / scalevalue,
      child: beastspiral,
    ),
  );
}

Widget spiralArmNum(int h, double dotsize, Color color) {
  return Container(
    height: dotsize,
    width: dotsize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      // border: Border.all(width: 1 / scalevalue, color: Colors.white),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.5),
          spreadRadius: 8 / scalevalue,
          blurRadius: 4 / scalevalue,
        )
      ],
    ),
    child: Text(
      (h + 1).toString(),
      style: GoogleFonts.ptSerif(
        fontSize: 22 / scalevalue,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget spiralLineWidget(List<Map<String, double>> points, double halfdotsize) {
  return CustomPaint(
    size: const Size(spiralframedimension, spiralframedimension),
    painter: SpiralBranchLinePainter(points, halfdotsize),
  );
}
