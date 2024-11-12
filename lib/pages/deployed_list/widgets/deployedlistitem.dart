import 'package:armybuilder/models/model.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:armybuilder/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../appdata.dart';
import '../../../providers/armylist.dart';

class DeployedListItem extends StatelessWidget {
  final int listindex;
  final int listmodelindex;
  final Product product;
  final int modelindex;
  final bool minsize;
  const DeployedListItem(
      {required this.listindex, required this.listmodelindex, required this.product, required this.modelindex, required this.minsize, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    final Color textcolor = Colors.grey.shade200;
    const Color bordercolor = Colors.grey;
    List<List<Widget>> statrow = [];
    List<List<Widget>> altstatrow = [];
    late Widget stats;
    late Widget altstats;
    late Widget statstable;
    Model m = product.models[modelindex];
    String productname = product.name;
    String modelname = '';

    String hp = '';
    int? hptotal = 0;

    int unitmodelcount = 0;

    switch (product.category) {
      case ('Units'):
        String unit = product.unitPoints![minsize ? 'minunit' : 'maxunit'];
        modelname = '${product.name} - $unit';
        if (unit.contains(',')) {
          //units with multiple named characters
          modelname = m.modelname;
          // unit = unit.replaceAll('&', ',').replaceAll(' ', '').replaceAll(',,', ',');
          // unitmodelcount = unit.split(',').length;
          // print('parsed unit length (comma): $unitmodelcount');
        } else {
          unit = unit.replaceAll(RegExp(r'[^0-9]'), ''); //getting the # of models in the unit
          if (int.tryParse(unit) != null) {
            unitmodelcount = int.parse(unit) + 1;
          }
          if (product.models.length > 1) {
            modelname = m.modelname;
          }
        }
        break;
      case ('Solos'):
        productname = product.name;
        modelname = m.modelname;
        if (FactionNotifier().checkSoloForXCount(product)) {
          productname = product.name.substring(0, product.name.length - 3).trim();
        }
        break;
      default:
        modelname = m.modelname;
    }

    // String productname = product.name == product.models[index].modelname ? product.name : '${product.name} - ${product.models[index].modelname}';
    if (m.hpbars!.isNotEmpty && unitmodelcount > 0) {
      for (int h = 0; h < unitmodelcount; h++) {
        if (int.tryParse(m.hpbars![h].hp) != null) {
          hp = '$hp ${int.parse(m.hpbars![h].hp) - army.hptracking[listindex][listmodelindex]['hpbarsdamage'][h]}';
          hptotal = (hptotal! + int.parse(m.hpbars![h].hp) - army.hptracking[listindex][listmodelindex]['hpbarsdamage'][h]) as int?;
        } else {}
      }
    } else {
      if (int.tryParse(m.stats.hp!) != null) {
        if (int.parse(m.stats.hp!) > 1) {
          hptotal = (int.parse(m.stats.hp!) - army.hptracking[listindex][listmodelindex]['damage']) as int?;
          hp = hptotal.toString();
        }
      }
    }

    if (m.stats.spd != '-') statrow.add(statBlock('SPD', m.stats.spd!, bordercolor, textcolor));
    if (m.stats.str != '-') statrow.add(statBlock('STR', m.stats.str!, bordercolor, textcolor));
    if (m.stats.aat != '-') statrow.add(statBlock('AAT', m.stats.aat!, bordercolor, textcolor));
    if (m.stats.mat != '-') statrow.add(statBlock('MAT', m.stats.mat!, bordercolor, textcolor));
    if (m.stats.rat != '-') statrow.add(statBlock('RAT', m.stats.rat!, bordercolor, textcolor));
    if (m.stats.def != '-') statrow.add(statBlock('DEF', m.stats.def!, bordercolor, textcolor));
    if (m.stats.arm != '-') statrow.add(statBlock('ARM', m.stats.arm!, bordercolor, textcolor));
    if (m.stats.cmd != '-') altstatrow.add(statBlock('CMD', m.stats.cmd!, bordercolor, textcolor));
    if (m.stats.ctrl != '-') altstatrow.add(statBlock('CTRL', m.stats.ctrl!, bordercolor, textcolor));
    if (m.stats.arc != '-') altstatrow.add(statBlock('ARC', m.stats.arc!, bordercolor, textcolor));
    if (m.stats.fury != '-') altstatrow.add(statBlock('FURY', m.stats.fury!, bordercolor, textcolor));
    if (m.stats.thr != '-') altstatrow.add(statBlock('THR', m.stats.thr!, bordercolor, textcolor));
    if (m.stats.ess != '-') altstatrow.add(statBlock('ESS', m.stats.ess!, bordercolor, textcolor));

    TableRow toprow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][0]));
    TableRow bottomrow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][1]));
    TableRow alttoprow = TableRow(children: List.generate(altstatrow.length, (index) => altstatrow[index][0]));
    TableRow altbottomrow = TableRow(children: List.generate(altstatrow.length, (index) => altstatrow[index][1]));
    stats = Table(
      border: TableBorder.all(width: 1, color: bordercolor),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [toprow, bottomrow],
    );

    altstats = const SizedBox();
    if (alttoprow.children.isNotEmpty) {
      altstats = Table(
        border: TableBorder.all(width: 1, color: bordercolor),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [alttoprow, altbottomrow],
      );
    }

    statstable = Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [stats, altstats],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          army.setDeployedListSelectedProduct(listindex, product, modelindex, listmodelindex, unitmodelcount);
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
                      child: statstable,
                    ),
                    if (hp != '')
                      Expanded(
                        flex: 7,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              hp.toString(),
                              style: TextStyle(fontSize: AppData().fontsize),
                            ),
                            const SizedBox(width: 1),
                            Icon(hptotal == 0 ? Icons.clear : Icons.favorite, color: Colors.red),
                          ],
                        ),
                      ),
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
