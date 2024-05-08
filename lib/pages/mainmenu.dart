import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appdata.dart';
import '../providers/armylist.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
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
                    army.pageController.jumpToPage(1);
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
                    army.pageController.jumpToPage(3);
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
                    army.pageController.jumpToPage(4);
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
      ],
    );
  }
}
