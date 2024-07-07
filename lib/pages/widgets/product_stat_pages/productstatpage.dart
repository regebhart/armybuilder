import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cohort.dart';
import '../../../providers/armylist.dart';
import 'universalmodelstatpage.dart';

class ProductStatPage extends StatefulWidget {
  final bool deployed;
  const ProductStatPage({required this.deployed, super.key});

  @override
  State<ProductStatPage> createState() => _ProductStatPageState();
}

class _ProductStatPageState extends State<ProductStatPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    Color textcolor = Colors.grey[200]!;
    Product p = army.selectedProduct;
    Cohort c = army.selectedCohort;
    double fontsize = AppData().fontsize - 4;
    List<Widget> modelsWidget = [];
    String cost = 'PC: ${p.points!}';

    if (!army.viewingcohort[0]) {
      p = army.selectedProduct;
    } else {
      c = army.selectedCohort;
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

      for (int modelindex = 0; modelindex < p.models.length; modelindex++) {
        Widget modelStats = UniversalModelStatPage(
          deployed: false,
          modelindex: modelindex,
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
          docheader.add(const SizedBox(height: 3));

          modelsWidget.addAll(docheader);
        }
        modelsWidget.add(modelStats);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
