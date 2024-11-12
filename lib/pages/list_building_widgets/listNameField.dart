import 'package:armybuilder/pages/list_building_widgets/buttons/savelistbutton.dart';
import 'package:armybuilder/providers/navigation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:armybuilder/pages/list_building_widgets/buttons/copytoclipboardbutton.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../models/savedata.dart';
import '../../providers/armylist.dart';

class ListNameField extends StatefulWidget {
  const ListNameField({super.key});

  @override
  State<ListNameField> createState() => _ListNameFieldState();
}

class _ListNameFieldState extends State<ListNameField> {
  TextEditingController con = TextEditingController();

  @override
  void dispose() {
    con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    army.setlistnameController(con);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text('List Name:'),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                controller: con,
                style: TextStyle(color: Colors.black, fontSize: AppData().fontsize - 2),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 234, 201, 201), width: 1.5),
                  ),
                  focusColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              //copy button
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CopyToClipboardButton(),
              ),

              //save button
              const SaveListButton(),

              //deploy button
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
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
        ),
      ],
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
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update List'),
            onPressed: () {
              army.setlistname(army.listnameController.text);
              updateExisitingList(army.armyList, army.armylistindex);
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
