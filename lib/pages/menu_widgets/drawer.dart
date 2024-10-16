import 'dart:html' as html;

import 'package:armybuilder/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/armylist.dart';
import '../../providers/faction.dart';
import 'factionupdatedates.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.buildlastupdated,
  });
  final String buildlastupdated;

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    return ListView(
      children: [
        ListTile(
          title: const Text('Browse Models'),
          onTap: () {
            Navigator.of(context).pop();
            army.setFactionSelected(AppData().factionList.first['name']!);
            faction.setSelectedFactionIndex(0);
            faction.setBrowsingCategory(0);
            army.setSelectedProduct(army.blankproduct);
            nav.pageController.jumpToPage(1);
            army.cancelDeployment();
          },
        ),
        ListTile(
          title: const Text('New List'),
          onTap: () {
            Navigator.of(context).pop();
            army.resetEncounterLevel();
            army.setlistname('');
            nav.pageController.jumpToPage(2);
            army.cancelDeployment();
          },
        ),
        ListTile(
          title: const Text('Edit/Deploy Army'),
          onTap: () {
            Navigator.of(context).pop();
            nav.pageController.jumpToPage(4);
            army.cancelDeployment();
          },
        ),
        ListTile(
          title: const Text('Import/Export'),
          onTap: () {
            Navigator.of(context).pop();
            nav.pageController.jumpToPage(5);
          },
        ),
        ListTile(
          title: const Text('Core Rulebook'),
          onTap: () {
            html.window.open('https://www.legacymachine.online/rulebook/3.5%20Core%20Rulebook.pdf', 'new tab');
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ListTile(
          onTap: () {
            html.window.open('https://discord.gg/N6G974U248', 'new tab');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/discord-mark-blue.png',
              ),
            ),
          ),
          title: const Text('3.5 Discord'),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                html.window.open('https://ko-fi.com/murvkins', 'new tab');
              },
              child: Image.asset(
                'assets/kofi.png',
                height: 40,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
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
