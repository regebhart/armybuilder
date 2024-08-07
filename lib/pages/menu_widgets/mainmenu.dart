import 'package:armybuilder/providers/faction.dart';
import 'package:armybuilder/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/armylist.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Image.asset('assets/3_5_logo.png'),
          ),
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
                  onPressed: () {
                    army.setFactionSelected(AppData().factionList.first['name']!);
                    faction.setSelectedFactionIndex(0);
                    faction.setBrowsingCategory(0);
                    army.setSelectedProduct(army.blankproduct);
                    nav.pageController.jumpToPage(1);
                  },
                  child: Text(
                    'Browse Models',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
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
                  onPressed: () {
                    army.resetEncounterLevel();
                    army.resetList();
                    nav.pageController.jumpToPage(2);
                  },
                  child: Text(
                    'New Army',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
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
                  onPressed: () {
                    nav.pageController.jumpToPage(4);
                  },
                  child: Text(
                    'Edit/Deploy Army',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
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
                  onPressed: () {
                    army.setDeployFactionFilter('All');
                    nav.pageController.jumpToPage(5);
                  },
                  child: Text(
                    'Import/Export',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
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
    );
  }
}
