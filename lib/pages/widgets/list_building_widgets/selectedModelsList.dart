import 'package:armybuilder/selectedlistitems/listcohort.dart';
import 'package:armybuilder/selectedlistitems/listitem.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:armybuilder/selectedlistitems/listmodularoption.dart';
import 'package:armybuilder/selectedlistitems/listunit.dart';
import 'package:armybuilder/selectedlistitems/spellracklistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/armylist.dart';
import '../models/cohort.dart';
import '../models/unit.dart';
import '../providers/appdata.dart';
import '../providers/armylist.dart';

class ModelSelectedList extends StatefulWidget {
  const ModelSelectedList({super.key});

  @override
  State<ModelSelectedList> createState() => _ModelSelectedListState();
}

class _ModelSelectedListState extends State<ModelSelectedList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    const EdgeInsets buttonInsets = EdgeInsets.only(top: 4, bottom: 4, left: 50);
    const EdgeInsets itemInsets = EdgeInsets.only(left: 30);
    double buttonHeight = AppData().fontsize + 16;
    // int casternum = 0;

    army.calculatePoints();
    List<Widget> leaders = [];
    // List<Widget> cohort = [];
    List<Widget> solos = [];
    List<Widget> units = [];
    List<Widget> battleengines = [];
    List<Widget> structures = [];
    List<Widget> jrcasters = [];
    bool showclearbutton = false;

    for (var a = 0; a < army.armyList.leadergroup.length; a++) {
      if (army.armyList.leadergroup[a].leader.name != '') {
        leaders.add(ArmyListItem(
          product: army.armyList.leadergroup[a].leader,
          index: a,
          onTap: () => army.removeModelFromList(army.armyList.leadergroup[a].leader, a),
        ));
      } else {
        leaders.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select a Leader',
                style: TextStyle(fontSize: AppData().fontsize - 2),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
      }
      if (army.armyList.leadergroup[a].spellrack!.isNotEmpty) {
        int spellindex = 0;
        for (var sp in army.armyList.leadergroup[a].spellrack!) {
          if (sp.name != '') {
            leaders.add(SpellRackListItem(title: sp.name, cost: sp.cost, casterindex: a, spellindex: spellindex));
          } else {
            leaders.add(Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: buttonInsets,
                child: SizedBox(
                  height: buttonHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            //faction.setSelectedCategory(6, null);
                            // if (army.swiping) {
                            //   army.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            // }
                          },
                          child: Text(
                            'Select a Spell',
                            style: TextStyle(fontSize: AppData().fontsize - 4, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
          spellindex++;
        }
      }
      if (army.armyList.leadergroup[a].leaderattachment.name != '') {
        leaders.add(Padding(
          padding: itemInsets,
          child: ArmyListItem(
            product: army.armyList.leadergroup[a].leaderattachment,
            index: a,
            onTap: () => army.removeModelFromList(army.armyList.leadergroup[a].leaderattachment, a),
          ),
        ));
      } else {
        bool hasAttachment = false;
        if (army.armyList.leadergroup[a].leader.name != '') {
          if (army.armyList.leadergroup[a].leader.models.length > 1) {
            for (var m in army.armyList.leadergroup[a].leader.models) {
              for (var ab in m.characterabilities!) {
                if (ab.name.contains('Attach')) {
                  hasAttachment = true;
                  break;
                }
              }
            }
          }
          if (!hasAttachment && faction.allFactions[faction.selectedFactionIndex]['hascasterattachments'][army.castergroupindex[a]]) {
            leaders.add(Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: buttonInsets,
                child: SizedBox(
                  height: buttonHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            faction.setSelectedCategory(6, null, null, null);
                            if (army.swiping) {
                              army.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          },
                          child: Text(
                            'Select an Attachment',
                            style: TextStyle(fontSize: AppData().fontsize - 4, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
        }
      }

      int cohortindex = 0;
      for (var c in army.armyList.leadergroup[a].cohort) {
        leaders.add(
          CohortListItem(
            cohort: c,
            casterindex: a,
            cohortindex: cohortindex,
            type: 'warcaster',
          ),
        );

        if (c.product.models[0].modularoptions!.isNotEmpty) {
          for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
            if (c.selectedOptions![groupindex].name == '') {
              leaders.add(emptyModuleOption(a, cohortindex, groupindex, c, army, faction, 'warcaster', buttonHeight));
            } else {
              leaders.add(
                ModularOptionListItem(
                  title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                  cost: c.selectedOptions![groupindex].cost,
                  casterindex: a,
                  cohortindex: cohortindex,
                  groupindex: groupindex,
                  leadertype: 'warcaster',
                ),
              );
            }
          }
        }
        cohortindex++;
        showclearbutton = true;
      }
      if (army.armyList.leadergroup[a].leader.name != '') {
        // casternum += 1;
        showclearbutton = true;
      }
    }

    if (army.armyList.jrcasters.isNotEmpty) {
      for (var jr = 0; jr < army.armyList.jrcasters.length; jr++) {
        int index = army.armyList.leadergroup.length + jr;
        JrCasterGroup jrcastergroup = army.armyList.jrcasters[jr];
        jrcasters.add(ArmyListItem(
          product: jrcastergroup.leader,
          index: index,
          onTap: () => army.removeJrCaster(jr),
        ));
        int cohortindex = 0;
        for (var c in jrcastergroup.cohort) {
          jrcasters.add(
            CohortListItem(
              cohort: c,
              casterindex: jr,
              cohortindex: cohortindex,
              type: 'jrcaster',
            ),
          );

          if (c.product.models[0].modularoptions!.isNotEmpty) {
            for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
              if (c.selectedOptions![groupindex].name == '') {
                jrcasters.add(emptyModuleOption(jr, cohortindex, groupindex, c, army, faction, 'jrcaster', buttonHeight));
              } else {
                jrcasters.add(
                  ModularOptionListItem(
                    title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                    cost: c.selectedOptions![groupindex].cost,
                    casterindex: jr,
                    cohortindex: cohortindex,
                    groupindex: groupindex,
                    leadertype: 'jrcaster',
                  ),
                );
              }
            }
          }
          cohortindex++;
          showclearbutton = true;
        }
      }
    }

    for (var s in army.armyList.solos) {
      solos.add(ArmyListItem(
        product: s,
        index: 9999,
        onTap: () => army.removeModelFromList(s, 9999),
      ));
      showclearbutton = true;
    }

    if (army.armyList.units.isNotEmpty) {
      for (var u = 0; u < army.armyList.units.length; u++) {
        Unit thisunit = army.armyList.units[u];
        units.add(ArmyListUnitItem(
          product: army.armyList.units[u].unit,
          index: u,
          onTap: () => army.removeUnit(u),
          minsize: army.armyList.units[u].minsize,
          hasmarshal: faction.checkUnitForMashal(thisunit),
          casterindex: army.armyList.leadergroup.length + army.armyList.jrcasters.length + u,
        ));
        showclearbutton = true;
        if (faction.unitHasCommandAttachments(thisunit.unit.name)) {
          if (thisunit.commandattachment.name == '') {
            units.add(
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: buttonInsets,
                  child: SizedBox(
                    height: buttonHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              army.setAddtoIndex(u);
                              faction.setSelectedCategory(7, null, thisunit.unit.name, null);
                              if (army.swiping) {
                                army.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                              }
                            },
                            child: Text(
                              'Select a Command Attachment',
                              style: TextStyle(fontSize: AppData().fontsize - 4, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            units.add(Padding(
              padding: itemInsets,
              child: ArmyListItem(
                product: thisunit.commandattachment,
                index: u,
                onTap: () => army.removeUnitCommandAttachment(u),
              ),
            ));
          }
        }

        if (faction.unitHasWeaponAttachments(thisunit.unit.name)) {
          for (var wa in thisunit.weaponattachments) {
            units.add(Padding(
              padding: itemInsets,
              child: ArmyListItem(
                product: wa,
                index: u,
                onTap: () => army.removeUnitWeaponAttachment(wa, u),
              ),
            ));
          }
          int walimit = thisunit.minsize ? thisunit.weaponattachmentlimits[0] : thisunit.weaponattachmentlimits[1];
          if (thisunit.weaponattachments.length < walimit) {
            units.add(
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: buttonInsets,
                  child: SizedBox(
                    height: buttonHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              army.setAddtoIndex(u);
                              faction.setSelectedCategory(8, null, thisunit.unit.name, null);
                              if (army.swiping) {
                                army.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                              }
                            },
                            child: Text('Select a Weapon Attachment',
                                style: TextStyle(
                                  fontSize: AppData().fontsize - 4,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        int cohortindex = 0;
        for (var c in army.armyList.units[u].cohort) {
          units.add(
            CohortListItem(
              cohort: c,
              casterindex: u,
              cohortindex: cohortindex,
              type: 'unit',
            ),
          );

          if (c.product.models[0].modularoptions!.isNotEmpty) {
            for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
              if (c.selectedOptions![groupindex].name == '') {
                units.add(emptyModuleOption(u, cohortindex, groupindex, c, army, faction, 'unit', buttonHeight));
              } else {
                units.add(
                  ModularOptionListItem(
                    title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                    cost: c.selectedOptions![groupindex].cost,
                    casterindex: u,
                    cohortindex: cohortindex,
                    groupindex: groupindex,
                    leadertype: 'unit',
                  ),
                );
              }
            }
          }
          cohortindex++;
          showclearbutton = true;
        }
      }
    }

    for (var be in army.armyList.battleengines) {
      battleengines.add(ArmyListItem(
        product: be,
        index: 999,
        onTap: () => army.removeModelFromList(be, 999),
      ));
      showclearbutton = true;
    }

    for (var st in army.armyList.structures) {
      structures.add(ArmyListItem(
        product: st,
        index: 999,
        onTap: () => army.removeModelFromList(st, 999),
      ));
      showclearbutton = true;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ...leaders,
                ...jrcasters,
                ...solos,
                ...units,
                ...battleengines,
                ...structures,
              ],
            ),
          ),
        ),
        if (showclearbutton)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 50,
              ),
              child: FilledButton(
                  onPressed: () async {
                    _showResetDialog(context, army);
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: AppData().fontsize),
                  )),
            ),
          ),
      ],
    );
  }
}

Future<void> _showResetDialog(context, ArmyListNotifier army) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to reset the list? This will delete everything.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Reset'),
            onPressed: () {
              army.resetList();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget emptyModuleOption(
    int leaderindex, int cohortindex, int groupindex, Cohort c, ArmyListNotifier army, FactionNotifier faction, String type, double buttonHeight) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 80),
      child: SizedBox(
        height: buttonHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  army.setCohortVals(leaderindex, cohortindex, type);
                  faction.setShowModularGroupOptions(c.product);
                  if (army.swiping) {
                    army.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  }
                },
                child: Text(
                  'Select ${c.product.models[0].modularoptions![groupindex].groupname} Option',
                  style: TextStyle(
                    fontSize: AppData().fontsize - 4,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
