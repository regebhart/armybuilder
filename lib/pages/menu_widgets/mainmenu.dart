import 'dart:html' as html;

import 'package:armybuilder/pages/product_cards/card.dart';
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

    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0, top: 15),
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
                            army.clearList();
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
                            html.window.open('https://www.legacymachine.online/rulebook/3.5%20Core%20Rulebook.pdf', 'new tab');
                          },
                          child: Text(
                            'Core Rulebook',
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
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      'Disclaimer & Fair Use\n\nThis is a community-driven, fan-made, non-commercial supplement of Warmachine. The intention of this project is to promote Warmachine by offering an alternative to Mark 4. Warmachine is owned by Steamforged Games; please support Steamforged Games and Warmachine by also supporting the official release.\n\nThe Mark 3.5 Commission is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Steamforged Games. Mark 3.5 was created in a personal capacity; the contents expressed are the Mark 3.5 Commission\'s own and do not reflect the views of Steamforged Games or any of its affiliates.\n\nThe Mark 3.5 Commission does not claim nor implies any ownership rights to Warmachine or any of Steamforged Games\' copyrights or trademarks. Furthermore, any content found in Mark 3.5 is for not-for-profit use only under the fair use exception in US law.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
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
