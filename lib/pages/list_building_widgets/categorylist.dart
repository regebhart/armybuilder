import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/armylist.dart';
import '../../providers/faction.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);

    Map<String, String> f = AppData().factionList.firstWhere((element) => element['name'] == army.factionSelected);
    List<String> list = [];
    List<String> icons = [];
    switch (f['list']!) {
      case 'warmachine':
        list = AppData().warmachine.toList();
        icons = [
          'assets/Warcaster_Icon.png',
          'assets/Warjack_Icon.png',
          'assets/Solo_Icon.png',
          'assets/Unit_Icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
        ];
      case 'hordes':
        list = AppData().hordes.toList();
        icons = [
          'assets/Warlock_Icon.png',
          'assets/Warbeast_Icon.png',
          'assets/Solo_Icon.png',
          'assets/Unit_Icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
        ];
      default:
        list = AppData().warmachine.toList();
        icons = [
          'assets/Warcaster_Icon.png',
          'assets/Warjack_Icon.png',
          'assets/Solo_Icon.png',
          'assets/Unit_Icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
        ];
    }
    List<Widget> children = [];

    children = List.generate(
      list.length,
      (index) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              if ((index == 1 && army.selectedcasterFactionIndexes.isNotEmpty) || index != 1) {
                if (army.selectedcastertype == 'oofcohort') {
                  army.updateSelectedCaster('warcaster', army.selectedcasterProduct);
                }
                faction.setSelectedCategory(
                  index,
                  army.selectedcasterProduct,
                  null,
                  index == 1 ? army.selectedcasterFactionIndexes : null,
                  army.armyList.heartofdarkness,
                  null,
                  false,
                  army.armyList.listfaction,
                  army.armyList.solos.indexWhere((element) => element.name == 'Julius Raelthorne') >= 0,
                );
                if (index != 1) {
                  bool cathmore = false;
                  for (var l in army.armyList.leadergroup) {
                    if (l.leader.name == 'Colonel Drake Cathmore') cathmore = true;
                  }
                  faction.scaleFA(
                      army.armyList.leadergroup.length,
                      cathmore,
                      army.armyList.leadergroup.indexWhere((element) => (element.leader.name.contains('Deneghra') && element.leader.points! == '0')) >
                          -1);
                }
              }
            },
            borderRadius: BorderRadius.circular(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
                padding: const EdgeInsets.all(5),
                color: faction.selectedCategory == index ? Colors.deepPurple[700] : Colors.grey.shade100,
                child: Image.asset(icons[index], color: faction.selectedCategory == index ? Colors.grey.shade200 : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }
}
