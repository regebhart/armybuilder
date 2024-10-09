import 'package:armybuilder/pages/model_browsing/widgets/browsing_modelListTile.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../models/spells.dart';
import 'widgets/browsing_spellListTile.dart';

class BrowsingModelsList extends StatefulWidget {
  const BrowsingModelsList({super.key});

  @override
  State<BrowsingModelsList> createState() => _BrowsingModelsListState();
}

class _BrowsingModelsListState extends State<BrowsingModelsList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);

    List<List<Widget>> tiles = [[], [], []];

    if (faction.selectedCategory != 999) {
      List<String> groups = [
        '',
        'Allies',
        'Mercenaries',
      ];

      for (int g = 0; g < groups.length; g++) {
        //headers
        if (g != 0 && faction.filteredProducts[g].isNotEmpty) {
          tiles[g].add(
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(
                    groups[g],
                    style: TextStyle(fontSize: AppData().fontsize + 2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        //models
        for (int index = 0; index < faction.filteredProducts[g].length; index++) {
          tiles[g].add(ModelListTile(
            index: index,
            p: faction.filteredProducts[g][index],
            group: g,
          ));
        }
      }
    } else {
      List<Spell> spells = faction.getFactionSpells(AppData().factionList[faction.selectedFactionIndex]['name']!);
      for (var sp in spells) {
        tiles[0].add(BrowsingSpellListTile(spell: sp));
      }
    }

    List<Widget> alltiles = [];
    for (var g = 0; g < 3; g++) {
      if ((tiles[g].isNotEmpty && g == 0) || (tiles[g].length > 1 && g > 0)) {
        //if main faction models is not empty or if allies/mercs has more than just the header title then add them
        alltiles.addAll(tiles[g]);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: alltiles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return alltiles[index];
              }),
        ),
      ),
    );
  }
}
