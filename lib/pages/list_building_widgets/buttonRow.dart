import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

import '../../providers/armylist.dart';
import '../../providers/navigation.dart';
import 'buttons/copytoclipboardbutton.dart';
import 'buttons/savelistbutton.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          //copy button
          Padding(
            padding: EdgeInsets.only(right: nav.swiping ? 20.0 : 10.0),
            child: const CopyToClipboardButton(),
          ),

          //save button
          const SaveListButton(),

          //deploy button
          Padding(
            padding: EdgeInsets.only(left: nav.swiping ? 20.0 : 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: GestureDetector(
                onTap: () async {
                  if (army.status == 'saved') {
                    army.resetDeployedLists();
                    await army.deployList(army.armyList);
                    nav.pageController.jumpToPage(6);
                    army.setDeploying(true);
                    FirebaseAnalytics.instance.logEvent(
                      name: 'Deployed List',
                      parameters: {
                        'list': army.armyListToString(),
                        'faction': army.deployedLists[0].list.listfaction,
                        'points': army.deployedLists[0].list.pointtarget,
                        'listname': army.deployedLists[0].list.name,
                      },
                    );
                  } else {
                    _showErrorDialog(context, 'You must save the changes to the list in order to deploy it.');
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: Icon(Icons.double_arrow_outlined, color: army.status == 'saved' ? Colors.green : Colors.white38)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showErrorDialog(context, String error) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
