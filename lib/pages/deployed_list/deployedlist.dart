import 'package:armybuilder/pages/deployed_list/widgets/deployedlistcohort.dart';
import 'package:armybuilder/pages/deployed_list/widgets/deployedlistitem.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/armylist.dart';
import '../../models/product.dart';
import '../../models/unit.dart';
import '../../providers/armylist.dart';

class DeployedListWidget extends StatefulWidget {
  final int listindex;
  const DeployedListWidget({required this.listindex, super.key});

  @override
  State<DeployedListWidget> createState() => _DeployedListWidgetState();
}

class _DeployedListWidgetState extends State<DeployedListWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    const EdgeInsets itemInsets = EdgeInsets.only(left: 30);
    int listindex = widget.listindex;
    bool add =
        false; //used to add the hp bars only on the first build, otherwise they would be added everytime the page is rebuilt/when the user interacts with the page
    int count = -1;
    List<Widget> leaders = [];
    // List<Widget> cohort = [];
    List<Widget> solos = [];
    List<Widget> units = [];
    List<Widget> battleengines = [];
    List<Widget> structures = [];
    List<Widget> jrcasters = [];

    if (army.deployedLists.isNotEmpty) {
      ArmyList list = army.deployedLists[widget.listindex].list;

      if (army.hptracking.length - 1 < listindex) {
        army.addNewListHPTracking();
        add = true;
      }

      for (var a = 0; a < list.leadergroup.length; a++) {
        Product leader = list.leadergroup[a].leader;

        if (leader.name != '') {
          for (var m = 0; m < leader.models.length; m++) {
            bool skip = false;
            for (var ab in leader.models[m].characterabilities!) {
              if (ab.name.contains('Attached')) {
                skip = true;
                break;
              }
            }
            if (list.leadergroup[a].spellrack!.isNotEmpty) {
              for (var ab in leader.models[m].characterabilities!) {
                if (ab.name.contains('Spell Rack')) {
                  for (var sp in list.leadergroup[a].spellrack!) {
                    if (!leader.models[m].spells!.contains(sp)) {
                      leader.models[m].spells!.add(sp);
                    }
                  }
                  leader.models[m].spells!.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                  break;
                }
              }
            }
            if (!skip) {
              {
                count++;
                if (add) {
                  if (leader.models[m].hpbars!.isEmpty) {
                    army.addSingleHPBarHPTracking(listindex);
                  } else {
                    army.addUnitHPBarsHPTracking(listindex, leader.models[m].hpbars!.length);
                  }
                }
                leaders.add(DeployedListItem(
                  listindex: listindex,
                  listmodelindex: count,
                  product: leader,
                  modelindex: m,
                  minsize: false,
                ));
              }
            }
          }
        }

        if (list.leadergroup[a].leaderattachment.name != '') {
          Product attachment = list.leadergroup[a].leaderattachment;
          for (var m = 0; m < attachment.models.length; m++) {
            count++;
            if (add) {
              if (attachment.models[m].hpbars!.isEmpty) {
                army.addSingleHPBarHPTracking(listindex);
              } else {
                army.addUnitHPBarsHPTracking(listindex, attachment.models[m].hpbars!.length);
              }
            }
            leaders.add(Padding(
              padding: itemInsets,
              child: DeployedListItem(
                listindex: listindex,
                listmodelindex: count,
                product: attachment,
                modelindex: m,
                minsize: false,
              ),
            ));
          }
        } else {
          if (list.leadergroup[a].leader.name != '') {
            if (list.leadergroup[a].leader.models.length > 1) {
              for (var m = 0; m < list.leadergroup[a].leader.models.length; m++) {
                for (var ab in list.leadergroup[a].leader.models[m].characterabilities!) {
                  if (ab.name.contains('Attach')) {
                    count++;
                    if (add) {
                      if (leader.models[m].hpbars!.isEmpty) {
                        army.addSingleHPBarHPTracking(listindex);
                      } else {
                        army.addUnitHPBarsHPTracking(listindex, list.leadergroup[a].leader.models[m].hpbars!.length);
                      }
                    }
                    leaders.add(
                      Padding(
                        padding: itemInsets,
                        child: DeployedListItem(
                          listindex: listindex,
                          listmodelindex: count,
                          product: list.leadergroup[a].leader,
                          modelindex: m,
                          minsize: false,
                        ),
                      ),
                    );
                  }
                }
              }
            }
          }
        }

        for (var c in list.leadergroup[a].cohort) {
          for (var m = 0; m < c.product.models.length; m++) {
            count++;
            if (add) {
              if (c.product.models[m].grid!.columns.isNotEmpty) {
                army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
              }
              if (c.product.models[m].shield != null) {
                army.addShieldTracking(listindex);
              }
              if (c.product.models[m].spiral!.values.isNotEmpty) {
                army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
              }
              if (c.product.models[m].web!.values.isNotEmpty) {
                army.addWebHPTracking(listindex, c.product.models[m].web!);
              }
            }
            leaders.add(
              Padding(
                padding: itemInsets,
                child: DeployedListCohortItem(
                  listindex: listindex,
                  listmodelindex: count,
                  cohort: c,
                  modelindex: m,
                  minsize: false,
                ),
              ),
            );
          }
        }

        for (var c in list.leadergroup[a].oofcohort) {
          for (var m = 0; m < c.product.models.length; m++) {
            count++;
            if (add) {
              if (c.product.models[m].grid!.columns.isNotEmpty) {
                army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
              }
              if (c.product.models[m].shield != null) {
                army.addShieldTracking(listindex);
              }
              if (c.product.models[m].spiral!.values.isNotEmpty) {
                army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
              }
              if (c.product.models[m].web!.values.isNotEmpty) {
                army.addWebHPTracking(listindex, c.product.models[m].web!);
              }
            }
            leaders.add(
              Padding(
                padding: itemInsets,
                child: DeployedListCohortItem(
                  listindex: listindex,
                  listmodelindex: count,
                  cohort: c,
                  modelindex: m,
                  minsize: false,
                ),
              ),
            );
          }
        }

        if (list.leadergroup[a].oofjrcasters.isNotEmpty) {
          for (var jr = 0; jr < list.leadergroup[a].oofjrcasters.length; jr++) {
            JrCasterGroup jrcastergroup = list.leadergroup[a].oofjrcasters[jr];
            for (var m = 0; m < jrcastergroup.leader.models.length; m++) {
              count++;
              if (add) {
                if (jrcastergroup.leader.models[m].hpbars!.isEmpty) {
                  army.addSingleHPBarHPTracking(listindex);
                } else {
                  army.addUnitHPBarsHPTracking(listindex, jrcastergroup.leader.models[m].hpbars!.length);
                }
              }
              jrcasters.add(DeployedListItem(
                listindex: listindex,
                listmodelindex: count,
                product: jrcastergroup.leader,
                modelindex: m,
                minsize: false,
              ));
            }
            for (var c in jrcastergroup.cohort) {
              for (var m = 0; m < c.product.models.length; m++) {
                count++;
                if (add) {
                  if (c.product.models[m].grid!.columns.isNotEmpty) {
                    army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
                  }
                  if (c.product.models[m].spiral!.values.isNotEmpty) {
                    army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
                  }
                  if (c.product.models[m].web!.values.isNotEmpty) {
                    army.addWebHPTracking(listindex, c.product.models[m].web!);
                  }
                }
                jrcasters.add(
                  Padding(
                    padding: itemInsets,
                    child: DeployedListCohortItem(
                      listindex: listindex,
                      listmodelindex: count,
                      cohort: c,
                      modelindex: m,
                      minsize: false,
                    ),
                  ),
                );
              }
            }
          }
        }

        for (var s in list.leadergroup[a].oofsolos) {
          count++;
          if (add) {
            if (s.models[0].grid!.columns.isNotEmpty) {
              army.addGridHPTracking(listindex, s.models[0].grid!.columns.length);
            } else {
              army.addSingleHPBarHPTracking(listindex);
            }
          }
          solos.add(DeployedListItem(
            listindex: listindex,
            listmodelindex: count,
            product: s,
            modelindex: 0,
            minsize: false,
          ));
          if (s.models.length > 1) {
            for (int m = 1; m < s.models.length; m++) {
              count++;
              army.addSingleHPBarHPTracking(listindex);
              solos.add(DeployedListItem(
                listindex: listindex,
                listmodelindex: count,
                product: s,
                modelindex: m,
                minsize: false,
              ));
            }
          }
        }

        if (list.leadergroup[a].oofunits.isNotEmpty) {
          for (var u = 0; u < list.leadergroup[a].oofunits.length; u++) {
            Unit thisunit = list.leadergroup[a].oofunits[u];
            for (var m = 0; m < thisunit.unit.models.length; m++) {
              count++;
              if (add) {
                if (thisunit.unit.models[m].hpbars!.isEmpty) {
                  army.addSingleHPBarHPTracking(listindex);
                } else {
                  army.addUnitHPBarsHPTracking(listindex, thisunit.unit.models[m].hpbars!.length);
                }
              }
              units.add(DeployedListItem(
                listindex: listindex,
                listmodelindex: count,
                product: thisunit.unit,
                modelindex: m,
                minsize: thisunit.minsize,
              ));
            }

            if (thisunit.commandattachment.name != '') {
              for (var m = 0; m < thisunit.commandattachment.models.length; m++) {
                count++;
                if (add) {
                  if (thisunit.commandattachment.models[m].hpbars!.isEmpty) {
                    army.addSingleHPBarHPTracking(listindex);
                  } else {
                    army.addUnitHPBarsHPTracking(listindex, thisunit.commandattachment.models[m].hpbars!.length);
                  }
                }
                units.add(Padding(
                  padding: itemInsets,
                  child: DeployedListItem(
                    listindex: listindex,
                    listmodelindex: count,
                    product: thisunit.commandattachment,
                    modelindex: m,
                    minsize: false,
                  ),
                ));
              }
            }

            for (var wa in thisunit.weaponattachments) {
              for (var m = 0; m < wa.models.length; m++) {
                count++;
                if (add) {
                  if (wa.models[m].hpbars!.isEmpty) {
                    army.addSingleHPBarHPTracking(listindex);
                  } else {
                    army.addUnitHPBarsHPTracking(listindex, wa.models[m].hpbars!.length);
                  }
                }
                units.add(Padding(
                  padding: itemInsets,
                  child: DeployedListItem(
                    listindex: listindex,
                    listmodelindex: count,
                    product: wa,
                    modelindex: m,
                    minsize: false,
                  ),
                ));
              }
            }

            if (thisunit.hasMarshal) {
              for (var c in thisunit.cohort) {
                for (var m = 0; m < c.product.models.length; m++) {
                  count++;
                  if (add) {
                    if (c.product.models[m].grid!.columns.isNotEmpty) {
                      army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
                    }
                    if (c.product.models[m].spiral!.values.isNotEmpty) {
                      army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
                    }
                    if (c.product.models[m].web!.values.isNotEmpty) {
                      army.addWebHPTracking(listindex, c.product.models[m].web!);
                    }
                  }
                  units.add(
                    Padding(
                      padding: itemInsets,
                      child: DeployedListCohortItem(
                        listindex: listindex,
                        listmodelindex: count,
                        cohort: c,
                        modelindex: m,
                        minsize: false,
                      ),
                    ),
                  );
                }
              }
            }
          }
        }
      }

      if (list.jrcasters.isNotEmpty) {
        for (var jr = 0; jr < list.jrcasters.length; jr++) {
          JrCasterGroup jrcastergroup = list.jrcasters[jr];
          for (var m = 0; m < jrcastergroup.leader.models.length; m++) {
            count++;
            if (add) {
              if (jrcastergroup.leader.models[m].hpbars!.isEmpty) {
                army.addSingleHPBarHPTracking(listindex);
              } else {
                army.addUnitHPBarsHPTracking(listindex, jrcastergroup.leader.models[m].hpbars!.length);
              }
            }
            jrcasters.add(DeployedListItem(
              listindex: listindex,
              listmodelindex: count,
              product: jrcastergroup.leader,
              modelindex: m,
              minsize: false,
            ));
          }
          for (var c in jrcastergroup.cohort) {
            for (var m = 0; m < c.product.models.length; m++) {
              count++;
              if (add) {
                if (c.product.models[m].grid!.columns.isNotEmpty) {
                  army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
                }
                if (c.product.models[m].spiral!.values.isNotEmpty) {
                  army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
                }
                if (c.product.models[m].web!.values.isNotEmpty) {
                  army.addWebHPTracking(listindex, c.product.models[m].web!);
                }
              }
              jrcasters.add(
                Padding(
                  padding: itemInsets,
                  child: DeployedListCohortItem(
                    listindex: listindex,
                    listmodelindex: count,
                    cohort: c,
                    modelindex: m,
                    minsize: false,
                  ),
                ),
              );
            }
          }
        }
      }

      for (var s in list.solos) {
        int xcount = 1;
        if (FactionNotifier().checkSoloForXCount(s)) {
          xcount = FactionNotifier().getXCount(s);          
        }
        for (int x = 1; x <= xcount; x++) {
          count++;
          if (add) {
            if (s.models[0].grid!.columns.isNotEmpty) {
              army.addGridHPTracking(listindex, s.models[0].grid!.columns.length);
            } else {
              army.addSingleHPBarHPTracking(listindex);
            }
          }
          solos.add(DeployedListItem(
            listindex: listindex,
            listmodelindex: count,
            product: s,
            modelindex: 0,
            minsize: false,
          ));
          if (s.models.length > 1) {
            for (int m = 1; m < s.models.length; m++) {
              count++;
              army.addSingleHPBarHPTracking(listindex);
              solos.add(DeployedListItem(
                listindex: listindex,
                listmodelindex: count,
                product: s,
                modelindex: m,
                minsize: false,
              ));
            }
          }
        }
      }

      if (list.units.isNotEmpty) {
        for (var u = 0; u < list.units.length; u++) {
          Unit thisunit = list.units[u];
          for (var m = 0; m < thisunit.unit.models.length; m++) {
            count++;
            if (add) {
              if (thisunit.unit.models[m].hpbars!.isEmpty) {
                army.addSingleHPBarHPTracking(listindex);
              } else {
                army.addUnitHPBarsHPTracking(listindex, thisunit.unit.models[m].hpbars!.length);
              }
            }
            units.add(DeployedListItem(
              listindex: listindex,
              listmodelindex: count,
              product: thisunit.unit,
              modelindex: m,
              minsize: thisunit.minsize,
            ));
          }

          if (thisunit.commandattachment.name != '') {
            for (var m = 0; m < thisunit.commandattachment.models.length; m++) {
              count++;
              if (add) {
                if (thisunit.commandattachment.models[m].hpbars!.isEmpty) {
                  army.addSingleHPBarHPTracking(listindex);
                } else {
                  army.addUnitHPBarsHPTracking(listindex, thisunit.commandattachment.models[m].hpbars!.length);
                }
              }
              units.add(Padding(
                padding: itemInsets,
                child: DeployedListItem(
                  listindex: listindex,
                  listmodelindex: count,
                  product: thisunit.commandattachment,
                  modelindex: m,
                  minsize: false,
                ),
              ));
            }
          }

          for (var wa in thisunit.weaponattachments) {
            for (var m = 0; m < wa.models.length; m++) {
              count++;
              if (add) {
                if (wa.models[m].hpbars!.isEmpty) {
                  army.addSingleHPBarHPTracking(listindex);
                } else {
                  army.addUnitHPBarsHPTracking(listindex, wa.models[m].hpbars!.length);
                }
              }
              units.add(Padding(
                padding: itemInsets,
                child: DeployedListItem(
                  listindex: listindex,
                  listmodelindex: count,
                  product: wa,
                  modelindex: m,
                  minsize: false,
                ),
              ));
            }
          }

          if (thisunit.hasMarshal) {
            for (var c in thisunit.cohort) {
              for (var m = 0; m < c.product.models.length; m++) {
                count++;
                if (add) {
                  if (c.product.models[m].grid!.columns.isNotEmpty) {
                    army.addGridHPTracking(listindex, c.product.models[m].grid!.columns.length);
                  }
                  if (c.product.models[m].spiral!.values.isNotEmpty) {
                    army.addSpiralHPTracking(listindex, c.product.models[m].spiral!);
                  }
                  if (c.product.models[m].web!.values.isNotEmpty) {
                    army.addWebHPTracking(listindex, c.product.models[m].web!);
                  }
                }
                units.add(
                  Padding(
                    padding: itemInsets,
                    child: DeployedListCohortItem(
                      listindex: listindex,
                      listmodelindex: count,
                      cohort: c,
                      modelindex: m,
                      minsize: false,
                    ),
                  ),
                );
              }
            }
          }
        }
      }

      for (var be in list.battleengines) {
        count++;
        if (add) {
          army.addSingleHPBarHPTracking(listindex);
        }
        battleengines.add(DeployedListItem(
          listindex: listindex,
          listmodelindex: count,
          product: be,
          modelindex: 0,
          minsize: false,
        ));
      }

      for (var st in list.structures) {
        count++;
        if (add) {
          army.addSingleHPBarHPTracking(listindex);
        }
        structures.add(DeployedListItem(
          listindex: listindex,
          listmodelindex: count,
          product: st,
          modelindex: 0,
          minsize: false,
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
  }
}
