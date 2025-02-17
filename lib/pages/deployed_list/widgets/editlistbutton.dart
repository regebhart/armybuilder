import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/faction.dart';
import '../../../providers/navigation.dart';

class DeployedListEditButton extends StatelessWidget {
  const DeployedListEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GestureDetector(
          onTap: () async {
            await army.setArmyList(army.armyList, 0, 'edit');
            faction.setSelectedFactionIndex(AppData().factionList.indexWhere((element) => element['name'] == army.armyList.listfaction));
            faction.setSelectedCategory(0, null, null, null, false, null, false, army.armyList.listfaction, false);
            nav.pageController.jumpToPage(3);
            army.setStatus('saved');
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
    );
  }
}
