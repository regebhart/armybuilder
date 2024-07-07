import 'dart:convert';

import 'package:armybuilder/models/armylist.dart';
import 'package:armybuilder/pages/deployed_list/factiondropdown.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/savedata.dart';
import '../../appdata.dart';
import '../../providers/armylist.dart';
import '../../providers/faction.dart';
import '../../providers/navigation.dart';

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
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Faction Filter:'),
                  FactionDropDownSelection(),
                ]),
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
                      List<Map<String, dynamic>> favoritelists = [];
                      List<Map<String, dynamic>> armylists = [];
                      final String filterFaction = army.armylistFactionFilter;
                      for (String list in snapshot.data!) {
                        Map<String, dynamic> thislist = jsonDecode(list);
                        if (filterFaction == 'All' || thislist['faction'] == filterFaction) {
                          if (thislist['favorite']) {
                            favoritelists.add(jsonDecode(list));
                          } else {
                            armylists.add(jsonDecode(list));
                          }
                        }
                      }

                      if (armylists.isEmpty && favoritelists.isEmpty && snapshot.data!.isEmpty) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('No lists found.'),
                              ),
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
                                          nav.pageController.jumpToPage(1);
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
                                          nav.pageController.jumpToPage(4);
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
                        if (armylists.isEmpty && favoritelists.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('No lists found.'),
                          );
                        } else {
                          return Column(
                            children: [
                              if (favoritelists.isNotEmpty)
                                const Text(
                                  'Favorite Lists',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: favoritelists.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return SavedArmyListTile(armylist: favoritelists[index], armyjson: armies[index], index: index);
                                },
                              ),
                              if (favoritelists.isNotEmpty)
                                const Text(
                                  'Other Lists',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: armylists.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return SavedArmyListTile(armylist: armylists[index], armyjson: armies[index], index: favoritelists.length + index);
                                },
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedArmyListTile extends StatelessWidget {
  final Map<String, dynamic> armylist;
  final String armyjson;
  final int index;

  const SavedArmyListTile({
    super.key,
    required this.index,
    required this.armylist,
    required this.armyjson,
  });

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dense: true,
        tileColor: Colors.white,
        title: Text(
          armylist['name'],
          style: TextStyle(fontSize: AppData().fontsize, color: Colors.black),
        ),
        subtitle: Text(
          '${armylist['faction']} Army List',
          style: TextStyle(fontSize: AppData().fontsize - 6, color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () async {
            // armylist['favorite'] = !armylist['favorite'];
            ArmyList updatedlist = await faction.convertJsonStringToArmyList(armyjson);
            updatedlist.favorite = !armylist['favorite'];
            updateExisitingList(updatedlist, index);
            army.notify();
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Icon(
              armylist['favorite'] ? Icons.favorite_outlined : Icons.favorite_outline_rounded,
              color: Colors.red[400],
              size: 30,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${armylist['totalpoints']}/${armylist['pointtarget']}',
              style: TextStyle(fontSize: AppData().fontsize, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: () async {
                    await army.setArmyList(await faction.convertJsonStringToArmyList(armyjson), index, 'edit');
                    faction.setSelectedFactionIndex(AppData().factionList.indexWhere((element) => element['name'] == army.armyList.listfaction));
                    faction.setSelectedCategory(0, null, null, null);
                    nav.pageController.jumpToPage(3);
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
                    await army.deployList(await faction.convertJsonStringToArmyList(armyjson));
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
