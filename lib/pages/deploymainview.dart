import 'package:armybuilder/pages/deployedlist.dart';
import 'package:armybuilder/pages/singlemodelstatpage.dart';
import 'package:armybuilder/pages/widgets/importfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/armylist.dart';

class ArmyDeployment extends StatelessWidget {
  const ArmyDeployment({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    List<Widget> additionallists = [];

    if (army.deployedLists.length > 1) {
      for (int d = 1; d < army.deployedLists.length; d++) {
        additionallists.add(Flexible(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600, minWidth: 450), child: SingleModelStatPage(listindex: d)),
            ),
          ),
        ));
        additionallists.add(Flexible(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(army.deployedLists[d].list.name),
                  Text('Faction: ${army.deployedLists[d].list.listfaction}'),
                  Text('Points: ${army.deployedLists[d].list.totalpoints} / ${army.deployedLists[d].list.pointtarget}'),
                  ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600, minWidth: 450), child: DeployedListWidget(listindex: d))
                ])),
          ),
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(army.deployedLists[0].list.name),
                  Text('Faction: ${army.deployedLists[0].list.listfaction}'),
                  Text('Points: ${army.deployedLists[0].list.totalpoints} / ${army.deployedLists[0].list.pointtarget}'),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                    child: const DeployedListWidget(
                      listindex: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                child: const SingleModelStatPage(listindex: 0),
              ),
            ),
          ),
        ),
        if (additionallists.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 50, right: 15),
            child: Column(
              children: [
                Text('Import Opponents List'),
                SizedBox(
                  height: 10,
                ),
                ImportPastedList(opponent: true),
              ],
            ),
          ),
        if (additionallists.isNotEmpty) ...additionallists,
      ],
    );
  }
}
