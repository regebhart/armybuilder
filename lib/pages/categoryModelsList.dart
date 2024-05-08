import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/armylist.dart';
import '../models/product.dart';
import '../providers/appdata.dart';
import 'widgets/modelListTile.dart';

class CategoryModelsList extends StatefulWidget {
  const CategoryModelsList({super.key});

  @override
  State<CategoryModelsList> createState() => _CategoryModelsListState();
}

class _CategoryModelsListState extends State<CategoryModelsList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);
    List<String> groups = [
      '',
      'Allies',
      'Mercenaries',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListView.builder(
            itemCount: faction.filteredProducts.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, g) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (faction.filteredProducts[g].isNotEmpty && g > 0)
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
                    ListView.builder(
                      itemCount: faction.filteredProducts[g].length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
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
                              army.setUnitCommandAttachment(p);
                              toast.show(context);
                            };
                            break;
                          case 8:
                            onTap = () {
                              army.addUnitWeaponAttachment(p);
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
                                  int leaderindex = army.getSelectedCasterIndex();
                                  army.addCohort(Cohort(product: p, selectedOptions: []), leaderindex);
                                  if (p.models[0].modularoptions!.isNotEmpty) {
                                    army.setCohortVals(
                                        leaderindex, army.armyList.leadergroup[leaderindex].cohort.length - 1, army.selectedcastertype);
                                    faction.setShowModularGroupOptions(p);
                                  }
                                  toast.show(context);
                                }
                              } else {
                                // army.setCasterGroupIndex(army.selectedcaster, g);
                                army.addModelToList(p);
                                toast.show(context);
                              }
                            };
                            if (p.points == '') {
                              cost = 'Min: ${p.unitPoints!['mincost']}';
                              onTap = () {
                                army.addUnit(Unit(
                                  unit: Product.copyProduct(p),
                                  minsize: true,
                                  hasMarshal: false,
                                  commandattachment: army.blankproduct,
                                  weaponattachments: [],
                                  cohort: [],
                                ));
                                toast.show(context);
                              };
                              if (p.unitPoints!['maxcost'] != '-') {
                                cost = '$cost\nMax: ${p.unitPoints!['maxcost']}';
                              }
                            } else if (faction.selectedCategory == 0) {
                              cost = '+${p.points}';
                            }
                        }
                        return CategoryModelListTile(
                          atlimit: atlimit,
                          cost: cost,
                          index: index,
                          p: p,
                          onTap: onTap,
                          group: g,
                        );
                      },
                    ),
                  ]);
            }),
      ),
    );
  }
}
