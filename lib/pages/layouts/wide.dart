import 'package:armybuilder/pages/categorylist.dart';
import 'package:armybuilder/pages/widgets/listpoints.dart';
import 'package:armybuilder/pages/productstatpage.dart';
import 'package:armybuilder/pages/widgets/pointselect.dart';
import 'package:armybuilder/pages/selectedModelsList.dart';
import 'package:armybuilder/pages/categoryModelsList.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/faction.dart';
import '../listNameField.dart';
import '../modularItemsList.dart';

class ArmyBuildingWideLayout extends StatefulWidget {
  const ArmyBuildingWideLayout({super.key});

  @override
  State<ArmyBuildingWideLayout> createState() => _ArmyBuildingWideLayoutState();
}

class _ArmyBuildingWideLayoutState extends State<ArmyBuildingWideLayout> {
  @override
  void dispose() {
    // ignore: avoid_print
    print('disposed wide layout');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);

    army.setSwiping(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: PointSelect(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListNameField(),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 2000),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 1250),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: CategoryList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: !faction.showingoptions ? const CategoryModelsList() : const ModularOptionList(),
                ),
                const Expanded(
                  flex: 20,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CurrentListPoints(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ModelSelectedList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 25,
                  child: SingleChildScrollView(
                      child: ProductStatPage(
                    deployed: false,
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
