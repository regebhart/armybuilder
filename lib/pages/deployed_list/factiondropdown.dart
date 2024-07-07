import 'package:armybuilder/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/armylist.dart';

class FactionDropDownSelection extends StatefulWidget {
  const FactionDropDownSelection({super.key});

  @override
  State<FactionDropDownSelection> createState() => _FactionDropDownSelectionState();
}

class _FactionDropDownSelectionState extends State<FactionDropDownSelection> {
  late List<String> factionList = [];
  @override
  void initState() {
    factionList = ['All'];
    for (var f in AppData().factionList) {
      factionList.add(f['name']!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
              value: army.armylistFactionFilter,
              dropdownColor: Colors.white,
              onChanged: (value) {
                army.setDeployFactionFilter(value!);
              },
              style: TextStyle(fontSize: AppData().fontsize - 2),
              items: factionList.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppData().fontsize - 2,
                    ),
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}
