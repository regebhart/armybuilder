import 'package:armybuilder/providers/armylist.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/savedata.dart';
import '../../../appdata.dart';

class SaveListButton extends StatelessWidget {
  const SaveListButton({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);

    return InkWell(
      onTap: () async {
        bool error = false;
        if (army.armyList.leadergroup[0].leader.name == '') {
          await _showErrorDialog(context, 'You must assign at least one leader before saving.');
          error = true;
        }
        if (army.listnameController.text == '') {
          if (context.mounted) {
            await _showErrorDialog(context, 'You must set a name for the list before saving.');
            error = true;
          }
        }
        if (!error) {
          if (army.status == 'edit' || army.status == 'saved') {
            if (army.armyList.name != army.listnameController.text) {
              if (context.mounted) {
                await _showSaveDialog(context, army);
              }
            } else {
              updateExisitingList(army.armyList, army.armylistindex);
              army.setStatus('saved');
            }
          } else {
            army.setlistname(army.listnameController.text);
            saveNewList(army.armyList);
            army.setStatus('saved');
          }

          FirebaseAnalytics.instance.logEvent(
            name: 'Saved List',
            parameters: {
              'list': army.armyListToString(),
              'faction': army.armyList.listfaction,
              'points': army.armyList.pointtarget,
              'listname': army.armyList.name,
            },
          );
        }
        if (context.mounted) {
          CherryToast.success(
            backgroundColor: Colors.green.shade500,
            animationType: AnimationType.fromTop,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: const Duration(milliseconds: 600),
            toastDuration: const Duration(seconds: 3),
            toastPosition: Position.top,
            title: Text(
              'Army list saved!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
            ),
          ).show(context);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: const Icon(Icons.save)),
      ),
    );
  }
}

Future<void> _showSaveDialog(context, ArmyListNotifier army) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to save this list as a new list or update the existing list?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('New List'),
            onPressed: () {
              army.setlistname(army.listnameController.text);
              saveNewList(army.armyList);
              army.setStatus('saved');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update List'),
            onPressed: () {
              army.setlistname(army.listnameController.text);
              updateExisitingList(army.armyList, army.armylistindex);
              army.setStatus('saved');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
