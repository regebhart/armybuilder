import 'package:armybuilder/models/model.dart';
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
  const DeployedListCohortItem({required this.listindex, required this.listmodelindex, required this.cohort, required this.modelindex, required this.minsize, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    final Color textcolor = Colors.grey.shade200;
    const Color bordercolor = Colors.grey;
    List<List<Widget>> statrow = [];
    late Widget stats;
    Product product = cohort.product;
    Model m = product.models[modelindex];
    String productname = cohort.product.name;

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
      spd: m.stats.rat,
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
    int? hptotal = 0;

    int unitmodelcount = 0;
    String modelname = m.modelname;

    if (int.tryParse(m.stats.hp!) != null) {
      if (int.parse(m.stats.hp!) > 1) {
        hptotal = (int.parse(m.stats.hp!) - army.hptracking[listindex][listmodelindex]['damage']) as int?;
        hp = hptotal.toString();
      }
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

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          army.setDeployedListSelectedCohort(listindex, cohort, modelindex, listmodelindex, unitmodelcount);
          // if (army.swiping) {
          // army.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          // }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.grey.shade800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      stats,
                    ],
                  ),
                ),
                if (hp != '')
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          hp.toString(),
                          style: TextStyle(fontSize: AppData().fontsize),
                        ),
                        const SizedBox(width: 5),
                        Icon(hptotal == 0 ? Icons.clear : Icons.favorite, color: Colors.red),
                      ],
                    ),
                  )
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
