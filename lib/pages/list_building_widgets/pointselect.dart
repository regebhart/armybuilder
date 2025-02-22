import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/armylist.dart';

class PointSelect extends StatefulWidget {
  const PointSelect({super.key});

  @override
  State<PointSelect> createState() => _PointSelectState();
}

class _PointSelectState extends State<PointSelect> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                'Encounter Level:',
                style: TextStyle(fontSize: AppData().fontsize),
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    isDense: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    value: army.encounterlevel,
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      army.setEncounterLevel(AppData().encounterlevels.firstWhere((element) => element['level'] == value));
                      bool cathmore = false;
                      for (var l in army.armyList.leadergroup) {
                        if (l.leader.name == 'Colonel Drake Cathmore') cathmore = true;
                      }
                      faction.scaleFA(army.armyList.leadergroup.length, cathmore, army.armyList.leadergroup.indexWhere((element) => (element.leader.name.contains('Deneghra') && element.leader.points! == '0')) > -1);
                      army.recalulateFA();
                    },
                    style: TextStyle(fontSize: AppData().fontsize),
                    items: AppData().encounterlevels.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e['level'],
                        child: Text(
                          '${e['armypoints']} Points / ${e['castercount']} Leader${e['castercount'] > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppData().fontsize,
                          ),
                        ),
                      );
                    }).toList()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
