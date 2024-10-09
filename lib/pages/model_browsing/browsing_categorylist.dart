import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/faction.dart';

class BrowsingCategoryList extends StatefulWidget {
  const BrowsingCategoryList({super.key});

  @override
  State<BrowsingCategoryList> createState() => _BrowsingCategoryListState();
}

class _BrowsingCategoryListState extends State<BrowsingCategoryList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);

    Map<String, String> f = AppData().factionList[faction.selectedFactionIndex];
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
          'assets/attachment_icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
          'assets/spells.png',
        ];
      case 'hordes':
        list = AppData().hordes.toList();
        icons = [
          'assets/Warlock_Icon.png',
          'assets/Warbeast_Icon.png',
          'assets/Solo_Icon.png',
          'assets/Unit_Icon.png',
          'assets/attachment_icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
          'assets/spells.png',
        ];
      default:
        list = AppData().warmachine.toList();
        icons = [
          'assets/Warcaster_Icon.png',
          'assets/Warjack_Icon.png',
          'assets/Solo_Icon.png',
          'assets/Unit_Icon.png',
          'assets/attachment_icon.png',
          'assets/Battle_Engine_Icon.png',
          'assets/Structure_Icon.png',
          'assets/spells.png',
        ];
    }
    list.insert(4, 'Attachments');
    list.add('Spells');

    List<Widget> children = [];
    List<int> indexes = [0, 1, 2, 3, 7, 4, 5, 999];
    children = List.generate(
      list.length,
      (index) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              faction.setBrowsingCategory(indexes[index]);
            },
            borderRadius: BorderRadius.circular(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
                padding: const EdgeInsets.all(5),
                color: faction.selectedCategory == indexes[index] ? Colors.deepPurple[700] : Colors.grey.shade100,
                child: Image.asset(icons[index], color: faction.selectedCategory == indexes[index] ? Colors.grey.shade200 : Colors.black),
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
