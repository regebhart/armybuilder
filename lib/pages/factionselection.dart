import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FactionSelection extends StatelessWidget {
  final bool swiping;
  const FactionSelection({required this.swiping, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    // double width = MediaQuery.of(context).size.width;
    // List<Widget> grid = buttonGrid(width, faction, army, context);
    List<Map<String, String>> factionlist = AppData().factionList;

    return Center(
      child: SingleChildScrollView(
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
                                    // await faction.readFactionProducts(factionlist[index]['file']!);
                                    army.setFactionSelected(factionlist[index]['name']!);
                                    faction.setSelectedFactionIndex(index);
                                    // await faction.sortFactionProducts();
                                    faction.setSelectedCategory(0, null, null);
                                    army.pageController.jumpToPage(2);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> buttonGrid(double width, FactionNotifier faction, ArmyListNotifier army, BuildContext context) {
  int itemsPerRow = 2;
  List<Map<String, String>> factionlist = AppData().factionList;
  int rows = (factionlist.length / itemsPerRow).ceil();

  List<Widget> children = [];

  for (var r = 0; r < rows; r++) {
    children.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemsPerRow,
          (index) => ((r * itemsPerRow) + index) < factionlist.length
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 175,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.white,
                        child: TextButton(
                          onPressed: () async {
                            // await faction.readFactionProducts(factionlist[(r * itemsPerRow) + index]['file']!);
                            army.setFactionSelected(factionlist[(r * itemsPerRow) + index]['name']!);
                            faction.setSelectedFactionIndex(index);
                            // await faction.sortFactionProducts();
                            faction.setSelectedCategory(0, null, null);
                            army.pageController.jumpToPage(2);
                          },
                          child: Text(
                            factionlist[(r * itemsPerRow) + index]['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  return children;
}
