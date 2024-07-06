import 'package:flutter/material.dart';

import '../../providers/appdata.dart';
import '../../providers/armylist.dart';
import 'factionupdatedates.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.army,
    required this.buildlastupdated,
  });

  final ArmyListNotifier army;
  final String buildlastupdated;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('New List'),
          onTap: () {
            Navigator.of(context).pop();
            army.resetEncounterLevel();
            army.resetList();
            army.pageController.jumpToPage(1);
          },
        ),
        ListTile(
          title: const Text('Edit/Deploy Army'),
          onTap: () {
            Navigator.of(context).pop();
            army.pageController.jumpToPage(3);
          },
        ),
        ListTile(
          title: const Text('Import/Export'),
          onTap: () {
            Navigator.of(context).pop();
            army.pageController.jumpToPage(4);
          },
        ),
        ListTile(title: const Text('Core Rulebook (coming soon)'), onTap: () {} //html.window.open('https://www.legacymachine.online/rulebook/', 'new tab'),
            ),
        ListTile(
          title: Text(
            'Build Updated: $buildlastupdated',
            style: TextStyle(fontSize: AppData().fontsize - 4),
          ),
        ),
        const FactionDatesListTile(),
      ],
    );
  }
}
