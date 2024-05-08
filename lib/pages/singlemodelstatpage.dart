import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/pages/universalmodelstatpage.dart';
import 'package:armybuilder/providers/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/armylist.dart';
import '../providers/armylist.dart';

class SingleModelStatPage extends StatefulWidget {
  final int listindex;
  const SingleModelStatPage({required this.listindex, super.key});

  @override
  State<SingleModelStatPage> createState() => _SingleModelStatPageState();
}

class _SingleModelStatPageState extends State<SingleModelStatPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    Color textcolor = Colors.grey[200]!;
    Product p = army.deployedLists[widget.listindex].selectedProduct;
    Cohort c = army.deployedLists[widget.listindex].selectedCohort;
    int index = army.deployedLists[widget.listindex].selectedModelIndex;
    int listmodelindex = army.deployedLists[widget.listindex].selectedListModelIndex;
    double fontsize = AppData().fontsize - 4;
    List<Widget> modelsWidget = [];
    String cost = 'PC: ${p.points!}';

    if (!army.viewingcohort) {
      p = army.deployedLists[widget.listindex].selectedProduct;
    } else {
      c = army.deployedLists[widget.listindex].selectedCohort;
      p = c.product;
    }

    if (p.name == '') {
      modelsWidget.add(
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              "Select a model to view its stats",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      if (p.points == '') {
        cost = '${p.unitPoints!['minunit']} PC: ${p.unitPoints!['mincost']}';
        if (p.unitPoints!['maxcost'] != '-') {
          cost = '$cost\n${p.unitPoints!['maxunit']} PC: ${p.unitPoints!['maxcost']}';
        }
      } else if (p.category.contains('Warcaster')) {
        cost = 'BGP: +${p.points}';
      }

      String factions = 'Factions: ${p.factions.toString().replaceAll('[', '').replaceAll(']', '')}';

      // Model m = p.models[index];
      Widget modelStats = UniversalModelStatPage(
        deployed: true,
        modelindex: index,
        listindex: widget.listindex,
        listmodelindex: listmodelindex,
      );

      List<Widget> docheader = [];

      if (modelsWidget.isEmpty) {
        docheader.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              p.name,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.bold,
                fontSize: fontsize + 4,
              ),
            )));
        docheader.add(
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(factions,
                  style: TextStyle(
                    color: textcolor,
                    fontSize: fontsize,
                  ))),
        );
        docheader.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              cost,
              style: TextStyle(
                color: textcolor,
                fontSize: fontsize,
              ),
            ),
          ),
        );

        docheader.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text('Field Allowance: ${p.fa}',
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ),
        );
        modelsWidget.addAll(docheader);
      }
      modelsWidget.add(modelStats);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: modelsWidget,
          ),
        ),
      ),
    );
  }
}
