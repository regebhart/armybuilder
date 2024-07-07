import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FactionDropDown extends StatefulWidget {
  const FactionDropDown({super.key});

  @override
  State<FactionDropDown> createState() => _FactionDropDownState();
}

class _FactionDropDownState extends State<FactionDropDown> {
  late List<String> factionList = [];

  @override
  void initState() {
    for (var f in AppData().factionList) {
      factionList.add(f['name']!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);

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
              value: factionList[faction.selectedFactionIndex],
              dropdownColor: Colors.white,
              onChanged: (value) {
                faction.setBrowsingFaction(factionList.indexOf(value!));
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
