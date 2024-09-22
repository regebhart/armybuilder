import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cohort.dart';
import '../../models/product.dart';
import '../../models/unit.dart';
import '../../appdata.dart';
import '../widgets/model_list_widgets/modelListTile.dart';

class CategoryModelsList extends StatefulWidget {
  const CategoryModelsList({super.key});

  @override
  State<CategoryModelsList> createState() => _CategoryModelsListState();
}

class _CategoryModelsListState extends State<CategoryModelsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);
    List<String> groups = [
      '',
      'Allies',
      'Mercenaries',
    ];

    List<List<Widget>> tiles = [[], [], []];

    for (int g = 0; g < groups.length; g++) {
      if (g != 0 && faction.filteredProducts[g].isNotEmpty) {
        tiles[g].add(
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  groups[g],
                  style: TextStyle(fontSize: AppData().fontsize + 2),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
      for (int index = 0; index < faction.filteredProducts[g].length; index++) {
        late void Function() onTap;
        Product p = faction.filteredProducts[g][index];
        String cost = '${p.points}';
        bool atlimit = army.atFALimit(army.armyList, p);

        var toast = CherryToast.success(
          backgroundColor: Colors.green.shade500,
          animationType: AnimationType.fromTop,
          animationCurve: Curves.fastLinearToSlowEaseIn,
          animationDuration: const Duration(milliseconds: 600),
          toastDuration: const Duration(milliseconds: 1500),
          toastPosition: Position.top,
          title: Text(
            '${p.name} added to list.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
          ),
        );

        switch (faction.selectedCategory) {
          case 6:
            onTap = () {
              army.setLeaderAttachment(p);
              toast.show(context);
            };
            break;
          case 7:
            onTap = () {
              army.setUnitCommandAttachment(p, false, null);
              toast.show(context);
            };
            break;
          case 8:
            onTap = () {
              army.addUnitWeaponAttachment(p, false, null);
              toast.show(context);
            };
            break;
          case 666:
            //HoD solos
            onTap = () {
              army.addModelToList(p, true, army.hodleaderindex);
              toast.show(context);
            };
          case 667:
            //HoD units
            onTap = () {
              army.addUnit(
                Unit(
                  unit: p,
                  cohort: [],
                  commandattachment: army.blankproduct,
                  hasMarshal: faction.checkProductForMarshal(p),
                  minsize: true,
                  weaponattachmentlimits: faction.getUnitWeaponAttachLimit(p.name),
                  weaponattachments: [],
                ),
                true,
                army.hodleaderindex,
              );
              toast.show(context);
            };
            cost = 'Min: ${p.unitPoints!['mincost']}';
              onTap = () {
                army.addUnit(
                  Unit(
                      unit: Product.copyProduct(p, false),
                      minsize: true,
                      hasMarshal: false,
                      commandattachment: army.blankproduct,
                      weaponattachments: [],
                      cohort: [],
                      weaponattachmentlimits: faction.getUnitWeaponAttachLimit(p.name)),
                  false,
                  null,
                );
                toast.show(context);
              };
              if (p.unitPoints!['maxcost'] != '-') {
                cost = '$cost\nMax: ${p.unitPoints!['maxcost']}';
              }
          case 668:
            onTap = () {
              army.setUnitCommandAttachment(p, true, army.hodleaderindex);
              toast.show(context);
            };
            break;
          case 669:
            onTap = () {
              army.addUnitWeaponAttachment(p, true, army.hodleaderindex);
              toast.show(context);
            };
            break;
          case 9:
            break;
          default:
            onTap = () {
              if (p.category == 'Warjacks/Warbeasts/Horrors') {
                if ((army.armyList.leadergroup[0].leader.name == '' && army.armyList.jrcasters.isEmpty) || army.selectedcaster < 0) {
                  CherryToast.error(
                    backgroundColor: Colors.red.shade500,
                    animationType: AnimationType.fromTop,
                    animationCurve: Curves.fastLinearToSlowEaseIn,
                    animationDuration: const Duration(milliseconds: 600),
                    toastDuration: const Duration(seconds: 3),
                    toastPosition: Position.top,
                    title: Text(
                      'A Leader must be selected first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                    ),
                  ).show(context);
                } else {
                  int leaderindex = army.getSelectedCasterIndex(army.selectedcasterProduct);
                  if (army.hodleaderindex == -1) {
                    army.addCohort(Cohort(product: p, selectedOptions: []), leaderindex, false, null);
                  } else {
                    army.addCohort(Cohort(product: p, selectedOptions: []), leaderindex, true, army.hodleaderindex);
                  }
                  if (p.models[0].modularoptions!.isNotEmpty) {
                    switch (army.selectedcastertype) {
                      case 'warcaster':
                        army.setCohortVals(leaderindex, army.armyList.leadergroup[leaderindex].cohort.length - 1, army.selectedcastertype);
                        break;
                      case 'jrcaster':
                        army.setCohortVals(leaderindex, army.armyList.jrcasters[leaderindex].cohort.length - 1, army.selectedcastertype);
                        break;
                      case 'unit':
                        int unitindex = army.getUnitIndex(army.selectedcasterProduct);
                        army.setCohortVals(leaderindex, army.armyList.units[unitindex].cohort.length - 1, army.selectedcastertype);
                        break;
                      case 'oofjrcaster':
                        int jrindex = army.getJrIndex(army.selectedcasterProduct);
                        army.setCohortVals(
                            jrindex, army.armyList.leadergroup[army.hodleaderindex].oofjrcasters[jrindex].cohort.length - 1, army.selectedcastertype);
                        break;
                      case 'oofunit':
                        int unitindex = army.getUnitIndex(army.selectedcasterProduct);
                        army.setCohortVals(
                            unitindex, army.armyList.leadergroup[army.hodleaderindex].oofunits[unitindex].cohort.length - 1, army.selectedcastertype);
                        break;
                      default:
                        break;
                    }
                    faction.setShowModularGroupOptions(p);
                  }
                  toast.show(context);
                }
              } else {
                // army.setCasterGroupIndex(army.selectedcaster, g);
                army.addModelToList(p, false, null);
                toast.show(context);
              }
            };
            if (p.points == '') {
              cost = 'Min: ${p.unitPoints!['mincost']}';
              onTap = () {
                army.addUnit(
                  Unit(
                      unit: Product.copyProduct(p, false),
                      minsize: true,
                      hasMarshal: false,
                      commandattachment: army.blankproduct,
                      weaponattachments: [],
                      cohort: [],
                      weaponattachmentlimits: faction.getUnitWeaponAttachLimit(p.name)),
                  false,
                  null,
                );
                toast.show(context);
              };
              if (p.unitPoints!['maxcost'] != '-') {
                cost = '$cost\nMax: ${p.unitPoints!['maxcost']}';
              }
            } else if (faction.selectedCategory == 0) {
              cost = '+${p.points}';
            }
        }
        tiles[g].add(CategoryModelListTile(
          atlimit: atlimit,
          cost: cost,
          index: index,
          p: p,
          onTap: onTap,
          group: g,
        ));
      }
    }

    List<Widget> alltiles = [];
    for (var g = 0; g < 3; g++) {
      if ((tiles[g].isNotEmpty && g == 0) || (tiles[g].length > 1 && g > 0)) {
        //if main faction models is not empty or if allies/mercs has more than just the header title then add them
        alltiles.addAll(tiles[g]);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListView.builder(
            itemCount: alltiles.length,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return alltiles[index];
            }),
      ),
    );
  }
}
