import 'dart:convert';

import 'package:armybuilder/pages/widgets/factiondropdown.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/savedata.dart';
import '../providers/appdata.dart';
import '../providers/armylist.dart';
import '../providers/faction.dart';

class SavedArmyLists extends StatefulWidget {
  const SavedArmyLists({super.key});

  @override
  State<SavedArmyLists> createState() => _SavedArmyListsState();
}

class _SavedArmyListsState extends State<SavedArmyLists> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ConstrainedBox(
          //   constraints: const BoxConstraints(maxWidth: 475),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Container(
          //         decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
          //         child: InkWell(
          //           onTap: () {
          //             army.pageController.jumpToPage(0);
          //           },
          //           child: const Icon(Icons.arrow_back),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Saved Lists',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize + 2, decoration: TextDecoration.underline),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      await sortSavedLists();
                      setState(() {});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: const Icon(Icons.sort_by_alpha)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 20,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FutureBuilder(
                  future: loadSavedLists(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<String> armies = snapshot.data!;
                    List<Map<String, dynamic>> armylists = [];
                    final String filterFaction = army.armylistFactionFilter;
                    for (String list in snapshot.data!) {
                      Map<String, dynamic> thislist = jsonDecode(list);
                      if (filterFaction == 'All' || thislist['faction'] == filterFaction) {
                        armylists.add(jsonDecode(list));
                      }
                    }

                    if (armylists.isEmpty) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('No lists found.'),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 8),
                            //   child: Text('Start a New List'),
                            // ),

                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.white,
                                    child: TextButton(
                                      onPressed: () async {
                                        army.pageController.jumpToPage(1);
                                      },
                                      child: const Text(
                                        'Start a New List',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('- OR -'),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 8.0),
                            //   child: Text('Import a List'),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.white,
                                    child: TextButton(
                                      onPressed: () async {
                                        army.pageController.jumpToPage(4);
                                      },
                                      child: const Text(
                                        'Import a List',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Filter:'),
                            FactionDropDownSelection(),
                          ]),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: armylists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                          child: ListTile(
                            // onTap: () async {
                            //   await army.setArmyList(await faction.convertJsonStringToArmyList(armies[index]), index);
                            //   faction.setSelectedCategory(0, null);
                            //   army.pageController.jumpToPage(2);
                            // },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            dense: true,
                            tileColor: Colors.white,
                            title: Text(
                              armylists[index]['name'],
                              style: TextStyle(fontSize: AppData().fontsize, color: Colors.black),
                            ),
                            subtitle: Text(
                              '${armylists[index]['faction']} Army List',
                              style: TextStyle(fontSize: AppData().fontsize - 6, color: Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${armylists[index]['totalpoints']}/${armylists[index]['pointtarget']}',
                                  style: TextStyle(fontSize: AppData().fontsize, color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await army.setArmyList(await faction.convertJsonStringToArmyList(armies[index]), index, 'edit');
                                        faction.setSelectedFactionIndex(
                                            AppData().factionList.indexWhere((element) => element['name'] == army.armyList.listfaction));
                                        faction.setSelectedCategory(0, null, null);
                                        army.pageController.jumpToPage(2);
                                        army.setDeploying(false);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: Colors.black),
                                          ),
                                          child: Icon(Icons.edit, color: Colors.grey.shade600)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        _showDeleteArmyDialog(context, army, index);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: Colors.black),
                                          ),
                                          child: Icon(Icons.delete, color: Colors.red[400])),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        army.resetDeployedLists();
                                        await army.deployList(await faction.convertJsonStringToArmyList(armies[index]));
                                        army.pageController.jumpToPage(5);
                                        army.setDeploying(true);
                                        FirebaseAnalytics.instance.logEvent(
                                          name: 'Deployed List',
                                          parameters: {
                                            'list':
                                                '${army.deployedLists[0].list.listfaction}:${army.deployedLists[0].list.pointtarget}:${army.deployedLists[0].list.name}:${army.deployedLists[0].list.leadergroup[0].leader.name}',
                                            'faction': army.deployedLists[0].list.listfaction,
                                            'points': army.deployedLists[0].list.pointtarget,
                                            'listname': army.deployedLists[0].list.name,
                                            'leader': army.deployedLists[0].list.leadergroup[0].leader.name,
                                          },
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: Colors.black),
                                          ),
                                          child: const Icon(Icons.double_arrow_outlined, color: Colors.green)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showDeleteArmyDialog(context, ArmyListNotifier army, int index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this list?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              deletearmylist(index);
              army.updateEverything();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showDeleteAllArmiesDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete ALL lists?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              clearAllSavedLists();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
