import 'package:armybuilder/models/grid.dart';
import 'package:armybuilder/models/model.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:armybuilder/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/base_stats.dart';
import '../../../models/cohort.dart';
import '../../../models/modularoptions.dart';
import '../../../models/product.dart';
import '../../../appdata.dart';
import '../../../providers/armylist.dart';

class DeployedListCohortItem extends StatelessWidget {
  final int listindex;
  final int listmodelindex;
  final Cohort cohort;
  final int modelindex;
  final bool minsize;
  const DeployedListCohortItem(
      {required this.listindex, required this.listmodelindex, required this.cohort, required this.modelindex, required this.minsize, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    final Color textcolor = Colors.grey.shade200;
    const Color bordercolor = Colors.grey;
    List<List<Widget>> statrow = [];
    late Widget stats;
    late Widget systems;
    Product product = cohort.product;
    Model m = product.models[modelindex];
    String productname = cohort.product.name;
    List<String> gridsystems = FactionNotifier().getWarjackSystems(cohort.product);
    List<String> warbeastbranches = ['M', 'B', 'S'];
    List<String> horrorsystems = ['O', 'M', 'I'];

    BaseStats moddedStats = BaseStats(
      base: m.stats.base,
      aat: m.stats.aat,
      arc: m.stats.arc,
      arm: m.stats.arm,
      cmd: m.stats.cmd,
      ctrl: m.stats.ctrl,
      def: m.stats.def,
      ess: m.stats.ess,
      fury: m.stats.fury,
      hp: m.stats.hp,
      mat: m.stats.mat,
      rat: m.stats.rat,
      spd: m.stats.spd,
      str: m.stats.str,
      thr: m.stats.thr,
    );

    if (cohort.selectedOptions != null) {
      if (cohort.selectedOptions!.isNotEmpty) {
        for (Option op in cohort.selectedOptions!) {
          if (moddedStats.aat! != '-' && op.statmods!.aat! != '0') {
            moddedStats.aat = (int.parse(moddedStats.aat!) + int.parse(op.statmods!.aat!)).toString();
          }
          if (moddedStats.arc! != '-' && op.statmods!.arc! != '0') {
            moddedStats.arc = (int.parse(moddedStats.arc!) + int.parse(op.statmods!.arc!)).toString();
          }
          if (moddedStats.arm! != '-' && op.statmods!.arm! != '0') {
            moddedStats.arm = (int.parse(moddedStats.arm!) + int.parse(op.statmods!.arm!)).toString();
          }
          if (moddedStats.cmd! != '-' && op.statmods!.cmd! != '0') {
            moddedStats.cmd = (int.parse(moddedStats.cmd!) + int.parse(op.statmods!.cmd!)).toString();
          }
          if (moddedStats.ctrl! != '-' && op.statmods!.ctrl! != '0') {
            moddedStats.ctrl = (int.parse(moddedStats.ctrl!) + int.parse(op.statmods!.ctrl!)).toString();
          }
          if (moddedStats.def! != '-' && op.statmods!.def! != '0') {
            moddedStats.def = (int.parse(moddedStats.def!) + int.parse(op.statmods!.def!)).toString();
          }
          if (moddedStats.ess! != '-' && op.statmods!.ess! != '0') {
            moddedStats.ess = (int.parse(moddedStats.ess!) + int.parse(op.statmods!.ess!)).toString();
          }
          if (moddedStats.fury! != '-' && op.statmods!.fury! != '0') {
            moddedStats.fury = (int.parse(moddedStats.fury!) + int.parse(op.statmods!.fury!)).toString();
          }
          if (moddedStats.mat! != '-' && op.statmods!.mat! != '0') {
            moddedStats.mat = (int.parse(moddedStats.mat!) + int.parse(op.statmods!.mat!)).toString();
          }
          if (moddedStats.rat! != '-' && op.statmods!.rat! != '0') {
            moddedStats.rat = (int.parse(moddedStats.rat!) + int.parse(op.statmods!.rat!)).toString();
          }
          if (moddedStats.spd! != '-' && op.statmods!.spd! != '0') {
            moddedStats.spd = (int.parse(moddedStats.spd!) + int.parse(op.statmods!.spd!)).toString();
          }
          if (moddedStats.str! != '-' && op.statmods!.str! != '0') {
            moddedStats.str = (int.parse(moddedStats.str!) + int.parse(op.statmods!.str!)).toString();
          }
        }
      }
    }
    String hp = '';
    int hptotal = 0;

    int unitmodelcount = 0;
    String modelname = m.modelname;

    if (int.tryParse(m.stats.hp!) != null) {
      if (int.parse(m.stats.hp!) > 1) {
        hptotal = (int.parse(m.stats.hp!) - army.hptracking[listindex][listmodelindex]['damage']) as int;
        hp = hptotal.toString();
      }
    }

    String shieldhp = '';
    int shieldtotal = 0;
    if (m.shield!.isNotEmpty) {
      shieldtotal = (int.parse(m.shield!) - army.hptracking[listindex][listmodelindex]['shielddamage']) as int;
      shieldhp = shieldtotal.toString();
    }

    if (moddedStats.spd != '-') statrow.add(statBlock('SPD', moddedStats.spd!, bordercolor, textcolor));
    if (moddedStats.str != '-') statrow.add(statBlock('STR', moddedStats.str!, bordercolor, textcolor));
    if (moddedStats.aat != '-') statrow.add(statBlock('AAT', moddedStats.aat!, bordercolor, textcolor));
    if (moddedStats.mat != '-') statrow.add(statBlock('MAT', moddedStats.mat!, bordercolor, textcolor));
    if (moddedStats.rat != '-') statrow.add(statBlock('RAT', moddedStats.rat!, bordercolor, textcolor));
    if (moddedStats.def != '-') statrow.add(statBlock('DEF', moddedStats.def!, bordercolor, textcolor));
    if (moddedStats.arm != '-') statrow.add(statBlock('ARM', moddedStats.arm!, bordercolor, textcolor));
    if (moddedStats.arc != '-') statrow.add(statBlock('ARC', moddedStats.arc!, bordercolor, textcolor));
    if (moddedStats.cmd != '-') statrow.add(statBlock('CMD', moddedStats.cmd!, bordercolor, textcolor));
    if (moddedStats.ctrl != '-') statrow.add(statBlock('CTRL', moddedStats.ctrl!, bordercolor, textcolor));
    if (moddedStats.fury != '-') statrow.add(statBlock('FURY', moddedStats.fury!, bordercolor, textcolor));
    if (moddedStats.thr != '-') statrow.add(statBlock('THR', moddedStats.thr!, bordercolor, textcolor));
    if (moddedStats.ess != '-') statrow.add(statBlock('ESS', moddedStats.ess!, bordercolor, textcolor));

    TableRow toprow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][0]));
    TableRow bottomrow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][1]));
    stats = Table(
      border: TableBorder.all(width: 1, color: bordercolor),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [toprow, bottomrow],
    );

    if (m.title.toLowerCase().contains('warjack') || m.title.toLowerCase().contains('colossal')) {
      systems = Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: List.generate(gridsystems.length, (index) {
            GridBox r = GridBox(system: gridsystems[index], active: army.getSystemDisabled(m.grid!, listindex, listmodelindex, gridsystems[index]));
            return Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 3, color: Colors.grey)),
                child: SizedBox.square(
                  dimension: 17,
                  child: Container(
                    color: r.active ? Colors.red : Colors.white,
                    child: Center(
                        child: Text(
                      r.system,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: AppData().fontsize - 4,
                      ),
                    )),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    if (m.title.toLowerCase().contains('warbeast') || m.title.toLowerCase().contains('gargantuan')) {
      systems = Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: List.generate(warbeastbranches.length, (index) {
            bool disabled = army.getBranchDisabled(listindex, listmodelindex, warbeastbranches[index]);
            return disabled
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: index == 0
                                ? Colors.blue
                                : index == 1
                                    ? Colors.red
                                    : Colors.green,
                          ),
                          shape: BoxShape.circle),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Center(
                          child: Text(
                            warbeastbranches[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: AppData().fontsize - 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ),
      );
    }

    if (m.title.toLowerCase().contains('horror')) {
      systems = Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: List.generate(horrorsystems.length, (index) {
            bool disabled = army.getRingDisabled(listindex, listmodelindex, horrorsystems[index]);
            return disabled
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: index == 0
                                ? Colors.red[200]!
                                : index == 1
                                    ? Colors.red[600]!
                                    : Colors.red[900]!,
                          ),
                          shape: BoxShape.circle),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Center(
                          child: Text(
                            horrorsystems[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: AppData().fontsize - 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          army.setDeployedListSelectedCohort(listindex, cohort, modelindex, listmodelindex, unitmodelcount);
          if (nav.swiping) {
            nav.builderPageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.grey.shade800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (productname != modelname)
                  Text(
                    productname,
                    style: TextStyle(fontSize: AppData().fontsize - 5, color: Colors.grey.shade200),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                Text(
                  modelname,
                  style: TextStyle(fontSize: AppData().fontsize - 3, color: Colors.grey.shade200),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: stats,
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (hp != '')
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (shieldhp != '') ...[
                                    Text(
                                      shieldhp,
                                      style: TextStyle(fontSize: AppData().fontsize),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(shieldtotal == 0 ? Icons.clear : Icons.shield, color: Colors.blue),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    hp,
                                    style: TextStyle(fontSize: AppData().fontsize),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(hptotal == 0 ? Icons.clear : Icons.favorite, color: Colors.red)
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: systems,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> statBlock(String stat, String value, Color bordercolor, Color textcolor) {
  // double width = 40;
  // if (stat == 'Base') width = 60;
  return [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Text(
        stat, //STAT HEADER
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: textcolor,
          fontWeight: FontWeight.bold,
          fontSize: AppData().fontsize - 6,
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: Text(
        value,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textcolor,
          fontSize: AppData().fontsize - 4,
        ),
      ),
    )
  ];
}
