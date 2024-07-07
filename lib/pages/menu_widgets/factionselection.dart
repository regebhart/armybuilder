import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation.dart';

class FactionSelection extends StatelessWidget {
  final bool swiping;
  const FactionSelection({required this.swiping, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    
    // double width = MediaQuery.of(context).size.width;
    // List<Widget> grid = buttonGrid(width, faction, army, context);
    List<Map<String, String>> factionlist = AppData().factionList;

    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 840,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Image.asset('assets/3_5_logo.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Select a Faction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                      factionlist.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 190,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.white,
                                  child: TextButton(
                                    onPressed: () async {
                                      army.setFactionSelected(factionlist[index]['name']!);
                                      faction.setSelectedFactionIndex(index);
                                      faction.setSelectedCategory(0, null, null, null);
                                      nav.pageController.jumpToPage(3);
                                      army.setDeploying(false);
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: 'Faction Selected',
                                        parameters: {
                                          'faction': factionlist[index]['name']!,
                                        },
                                      );
                                    },
                                    child: Text(
                                      factionlist[index]['name']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      'Please note:\nThis site and all of the models included within are a work in progress. There may be errors and some features may not work properly.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}