import 'package:armybuilder/pages/list_building_widgets/widgets/listcohort.dart';
import 'package:armybuilder/pages/list_building_widgets/widgets/listitem.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:armybuilder/pages/list_building_widgets/widgets/listmodularoption.dart';
import 'package:armybuilder/pages/list_building_widgets/widgets/listunit.dart';
import 'package:armybuilder/pages/widgets/model_list_widgets/spellracklistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/armylist.dart';
import '../../models/cohort.dart';
import '../../models/unit.dart';
import '../../appdata.dart';
import '../../providers/armylist.dart';
import '../../providers/navigation.dart';

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
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    EdgeInsets buttonInsets = EdgeInsets.only(top: 4, bottom: 4, left: AppData().selectedListLeftWidth);
    EdgeInsets itemInsets = EdgeInsets.only(left: AppData().selectedListLeftWidth - 25);
    double buttonHeight = AppData().fontsize + 16;

    army.calculatePoints();
    List<Widget> leaders = []; //out of faction solos from heart of darkness
    List<Widget> solos = []; //out of faction units from heart of darkness
    List<Widget> oofwidgets = [];
    List<Widget> units = [];
    List<Widget> battleengines = [];
    List<Widget> structures = [];
    List<Widget> jrcasters = [];
    bool showclearbutton = false;
    int castercount = -1;

    for (var a = 0; a < army.armyList.leadergroup.length; a++) {
      if (army.armyList.leadergroup[a].leader.name != '') {
        castercount++;
        leaders.add(ArmyListItem(
          product: army.armyList.leadergroup[a].leader,
          index: castercount,
          onTap: () => army.removeModelFromList(army.armyList.leadergroup[a].leader, a, false, null),
          hod: faction.checkProductForHeartofDarkness(army.armyList.leadergroup[a].leader) && army.armyList.listfaction == 'Infernals',
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
              onTap: () => army.removeModelFromList(army.armyList.leadergroup[a].leaderattachment, a, false, null),
              hod: false),
        ));
      } else {
        bool hasAttachment = false;
        if (army.armyList.leadergroup[a].leader.name != '') {
          if (army.armyList.leadergroup[a].leader.models.length > 1) {
            for (var m in army.armyList.leadergroup[a].leader.models) {
              //check if caster has a preset attached model
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
                            faction.setSelectedCategory(6, null, null, null, false, null);
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
              casterindex: castercount,
              groupindex: a,
              cohortindex: cohortindex,
              type: 'warcaster',
              oof: false,
              leader: army.armyList.leadergroup[a].leader),
        );

        if (c.product.models[0].modularoptions!.isNotEmpty) {
          for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
            if (c.selectedOptions![groupindex].name == '') {
              leaders.add(emptyModuleOption(a, cohortindex, groupindex, c, army, faction, nav, 'warcaster', buttonHeight));
            } else {
              leaders.add(
                ModularOptionListItem(
                  title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                  cost: c.selectedOptions![groupindex].cost,
                  // casterindex: a,
                  casterindex: castercount,
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
        JrCasterGroup jrcastergroup = army.armyList.jrcasters[jr];
        castercount++;
        jrcasters.add(ArmyListItem(
          product: jrcastergroup.leader,
          index: castercount,
          onTap: () => army.removeJrCaster(jr, false, null),
          hod: false,
        ));
        int cohortindex = 0;
        for (var c in jrcastergroup.cohort) {
          jrcasters.add(
            CohortListItem(
              cohort: c,
              casterindex: castercount,
              groupindex: jr,
              cohortindex: cohortindex,
              type: 'jrcaster',
              oof: false,
              leader: army.armyList.jrcasters[jr].leader,
            ),
          );

          if (c.product.models[0].modularoptions!.isNotEmpty) {
            for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
              if (c.selectedOptions![groupindex].name == '') {
                jrcasters.add(emptyModuleOption(jr, cohortindex, groupindex, c, army, faction, nav, 'jrcaster', buttonHeight));
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
        index: null,
        onTap: () => army.removeModelFromList(s, null, false, null),
        hod: false,
      ));
      showclearbutton = true;
    }

    if (army.armyList.units.isNotEmpty) {
      for (var u = 0; u < army.armyList.units.length; u++) {
        Unit thisunit = army.armyList.units[u];
        bool hasmarshal = faction.checkUnitForMashal(thisunit);
        if (hasmarshal) castercount++;

        units.add(ArmyListUnitItem(
          product: thisunit.unit,
          index: u,
          onTap: () => army.removeUnit(u, false, null),
          minsize: thisunit.minsize,
          hasmarshal: hasmarshal,
          casterindex: hasmarshal ? castercount : -1,
          oof: false,
        ));
        showclearbutton = true;
        if (faction.unitHasCommandAttachments(thisunit.unit.name, false, null)) {
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
                              faction.setSelectedCategory(7, null, thisunit.unit.name, null, false, null);
                              if (nav.swiping) {
                                nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
                onTap: () => army.removeUnitCommandAttachment(u, false, null),
                hod: false,
              ),
            ));
          }
        }

        if (faction.unitHasWeaponAttachments(thisunit.unit.name, false, null)) {
          for (var wa in thisunit.weaponattachments) {
            units.add(Padding(
              padding: itemInsets,
              child: ArmyListItem(
                product: wa,
                index: u,
                onTap: () => army.removeUnitWeaponAttachment(wa, u, false, null),
                hod: false,
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
                              faction.setSelectedCategory(8, null, thisunit.unit.name, null, false, null);
                              if (nav.swiping) {
                                nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
              casterindex: castercount,
              groupindex: u,
              cohortindex: cohortindex,
              type: 'unit',
              oof: false,
              leader: army.armyList.units[u].unit,
            ),
          );

          if (c.product.models[0].modularoptions!.isNotEmpty) {
            for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
              if (c.selectedOptions![groupindex].name == '') {
                units.add(emptyModuleOption(u, cohortindex, groupindex, c, army, faction, nav, 'unit', buttonHeight));
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

    if (army.armyList.listfaction == 'Infernals' && army.armyList.heartofdarkness) {
      for (var a = 0; a < army.armyList.leadergroup.length; a++) {
        if (army.armyList.leadergroup[a].heartofdarknessfaction != '') {
          oofwidgets.add(Text(
              'Heart of Darkness - ${AppData().factionList.firstWhere((element) => element['name']!.toLowerCase() == army.armyList.leadergroup[a].heartofdarknessfaction!)['name']} Options'));
          if (army.armyList.leadergroup[a].oofjrcasters.isNotEmpty) {
            for (var jr = 0; jr < army.armyList.leadergroup[a].oofjrcasters.length; jr++) {
              JrCasterGroup jrcastergroup = army.armyList.leadergroup[a].oofjrcasters[jr];
              castercount++;
              oofwidgets.add(ArmyListItem(
                product: jrcastergroup.leader,
                index: castercount,
                onTap: () => army.removeJrCaster(jr, true, a),
                hod: true,
                leaderindex: a,
              ));
              int cohortindex = 0;
              for (var c in jrcastergroup.cohort) {
                oofwidgets.add(
                  CohortListItem(
                    cohort: c,
                    casterindex: castercount,
                    groupindex: jr,
                    cohortindex: cohortindex,
                    type: 'oofjrcaster',
                    oof: true,
                    leaderindex: a,
                    leader: army.armyList.leadergroup[a].oofjrcasters[jr].leader,
                  ),
                );
                if (c.product.models[0].modularoptions!.isNotEmpty) {
                  for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
                    if (c.selectedOptions![groupindex].name == '') {
                      oofwidgets.add(emptyModuleOption(jr, cohortindex, groupindex, c, army, faction, nav, 'oofjrcaster', buttonHeight));
                    } else {
                      oofwidgets.add(
                        ModularOptionListItem(
                          title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                          cost: c.selectedOptions![groupindex].cost,
                          casterindex: jr,
                          cohortindex: cohortindex,
                          groupindex: groupindex,
                          leadertype: 'oofjrcaster',
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

          for (var s in army.armyList.leadergroup[a].oofsolos) {
            oofwidgets.add(ArmyListItem(
              product: s,
              index: null,
              onTap: () => army.removeModelFromList(s, null, true, a),
              hod: true,
              leaderindex: a,
            ));
            showclearbutton = true;
          }

          for (int s = army.armyList.leadergroup[a].oofjrcasters.length + army.armyList.leadergroup[a].oofsolos.length; s < 3; s++) {
            oofwidgets.add(Align(
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
                            army.setHoDLeaderIndex(a);
                            int factionindex = AppData()
                                .factionList
                                .indexWhere((element) => element['name']!.toLowerCase() == army.armyList.leadergroup[a].heartofdarknessfaction);
                            faction.setSelectedCategory(666, null, null, null, true, factionindex);
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          },
                          child: Text(
                            'Select a Solo',
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

          if (army.armyList.leadergroup[a].oofunits.isNotEmpty) {
            for (var u = 0; u < army.armyList.leadergroup[a].oofunits.length; u++) {
              Unit thisunit = army.armyList.leadergroup[a].oofunits[u];
              bool hasmarshal = faction.checkUnitForMashal(thisunit);
              if (hasmarshal) castercount++;

              oofwidgets.add(ArmyListUnitItem(
                product: thisunit.unit,
                index: u,
                onTap: () => army.removeUnit(u, true, a),
                minsize: thisunit.minsize,
                hasmarshal: faction.checkUnitForMashal(thisunit),
                casterindex: hasmarshal ? castercount : -1,
                oof: true,
                leaderindex: a,
              ));
              showclearbutton = true;
              if (faction.unitHasCommandAttachments(thisunit.unit.name, true, army.armyList.leadergroup[a].heartofdarknessfaction)) {
                if (thisunit.commandattachment.name == '') {
                  oofwidgets.add(
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
                                    int factionindex = AppData().factionList.indexWhere(
                                        (element) => element['name']!.toLowerCase() == army.armyList.leadergroup[a].heartofdarknessfaction);
                                    army.setAddtoIndex(u);
                                    faction.setSelectedCategory(668, null, thisunit.unit.name, null, true, factionindex);
                                    if (nav.swiping) {
                                      nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
                  oofwidgets.add(Padding(
                    padding: itemInsets,
                    child: ArmyListItem(
                      product: thisunit.commandattachment,
                      index: u,
                      onTap: () => army.removeUnitCommandAttachment(u, true, a),
                      hod: true,
                      leaderindex: a,
                    ),
                  ));
                }
              }

              if (faction.unitHasWeaponAttachments(thisunit.unit.name, true, army.armyList.leadergroup[a].heartofdarknessfaction)) {
                for (var wa in thisunit.weaponattachments) {
                  oofwidgets.add(Padding(
                    padding: itemInsets,
                    child: ArmyListItem(
                      product: wa,
                      index: u,
                      onTap: () => army.removeUnitWeaponAttachment(wa, u, true, a),
                      hod: true,
                    ),
                  ));
                }
                int walimit = thisunit.minsize ? thisunit.weaponattachmentlimits[0] : thisunit.weaponattachmentlimits[1];
                if (thisunit.weaponattachments.length < walimit) {
                  oofwidgets.add(
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
                                    int factionindex = AppData().factionList.indexWhere(
                                        (element) => element['name']!.toLowerCase() == army.armyList.leadergroup[a].heartofdarknessfaction);
                                    army.setAddtoIndex(u);
                                    faction.setSelectedCategory(669, null, thisunit.unit.name, null, true, factionindex);
                                    if (nav.swiping) {
                                      nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
              for (var c in army.armyList.leadergroup[a].oofunits[u].cohort) {
                oofwidgets.add(
                  CohortListItem(
                    cohort: c,
                    casterindex: castercount,
                    groupindex: u,
                    cohortindex: cohortindex,
                    type: 'oofunit',
                    oof: true,
                    leaderindex: a,
                    leader: army.armyList.leadergroup[a].oofunits[u].unit,
                  ),
                );

                if (c.product.models[0].modularoptions!.isNotEmpty) {
                  for (int groupindex = 0; groupindex < c.product.models[0].modularoptions!.length; groupindex++) {
                    if (c.selectedOptions![groupindex].name == '') {
                      oofwidgets.add(emptyModuleOption(u, cohortindex, groupindex, c, army, faction, nav, 'oofunit', buttonHeight));
                    } else {
                      oofwidgets.add(
                        ModularOptionListItem(
                          title: '${c.product.models[0].modularoptions![groupindex].groupname} - ${c.selectedOptions![groupindex].name}',
                          cost: c.selectedOptions![groupindex].cost,
                          casterindex: u,
                          cohortindex: cohortindex,
                          groupindex: groupindex,
                          leadertype: 'oofunit',
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

          for (var u = army.armyList.leadergroup[a].oofunits.length; u < 2; u++) {
            oofwidgets.add(Align(
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
                            army.setHoDLeaderIndex(a);
                            int factionindex = AppData()
                                .factionList
                                .indexWhere((element) => element['name']!.toLowerCase() == army.armyList.leadergroup[a].heartofdarknessfaction);
                            faction.setSelectedCategory(667, null, null, null, true, factionindex);
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          },
                          child: Text(
                            'Select a Unit',
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
    }

    for (var be in army.armyList.battleengines) {
      battleengines.add(ArmyListItem(
        product: be,
        index: 999,
        onTap: () => army.removeModelFromList(be, 999, false, null),
        hod: false,
      ));
      showclearbutton = true;
    }

    for (var st in army.armyList.structures) {
      structures.add(ArmyListItem(
        product: st,
        index: 999,
        onTap: () => army.removeModelFromList(st, 999, false, null),
        hod: false,
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
                ...oofwidgets,
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
                    _showResetDialog(context, faction, army);
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

Future<void> _showResetDialog(context, FactionNotifier faction, ArmyListNotifier army) async {
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
              faction.setSelectedCategory(0, null, null, null, false, null);
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
  int leaderindex,
  int cohortindex,
  int groupindex,
  Cohort c,
  ArmyListNotifier army,
  FactionNotifier faction,
  NavigationNotifier nav,
  String type,
  double buttonHeight,
) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: AppData().selectedListLeftWidth + 20),
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
                  if (nav.swiping) {
                    nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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

Widget oofUnitOption(int buttonindex, ArmyListNotifier army, FactionNotifier faction, NavigationNotifier nav, double buttonHeight) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: AppData().selectedListLeftWidth + 20),
      child: SizedBox(
        height: buttonHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  // army.setCohortVals(leaderindex, cohortindex, type);
                  // faction.setShowModularGroupOptions(c.product);
                  // if (nav.swiping) {
                  //   nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  // }
                },
                child: Text(
                  'Select  Option',
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
