import 'package:armybuilder/pages/list_building_widgets/buttons/copytoclipboardbutton.dart';
import 'package:armybuilder/pages/deployed_list/deployedlist.dart';
import 'package:armybuilder/pages/product_stat_pages/singlemodelstatpage.dart';
import 'package:armybuilder/pages/import_export/importfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/armylist.dart';

class ArmyDeploymentGridView extends StatelessWidget {
  const ArmyDeploymentGridView({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    List<Widget> opponentlist = [];

    if (army.deployedLists.length > 1) {
      for (int d = 1; d < army.deployedLists.length; d++) {
        opponentlist.add(Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Text(
                                  'Opponent List',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(army.deployedLists[d].list.name),
                    Text('Faction: ${army.deployedLists[d].list.listfaction}'),
                    Text('Points: ${army.deployedLists[d].list.totalpoints} / ${army.deployedLists[d].list.pointtarget}'),
                  ],
                ),
              ),
              DeployedListWidget(listindex: d),
            ],
          ),
        ));
        opponentlist.add(Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Text(
                            'Opponent Model',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                  child: SingleModelStatPage(listindex: d),
                ),
              ),
            ],
          ),
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15.0),
                  //player lists column
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //list info and copy button
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(army.deployedLists.isNotEmpty ? army.deployedLists[0].list.name : ''),
                                Text('Faction: ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.listfaction : ''}'),
                                Text(
                                    'Points: ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.totalpoints : ''} / ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.pointtarget : ''}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: const CopyToClipboardButton(),
                          ),
                        ],
                      ),
                      const DeployedListWidget(
                        listindex: 0,
                      ),
                      const SingleModelStatPage(listindex: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                child: Column(
                  children: [
                    if (army.deployedLists.length == 1)
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
                    if (army.deployedLists.length > 1) ...opponentlist,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
