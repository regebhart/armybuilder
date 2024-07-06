import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FactionDatesListTile extends StatefulWidget {
  const FactionDatesListTile({super.key});

  @override
  State<FactionDatesListTile> createState() => _FactionDatesListTileState();
}

class _FactionDatesListTileState extends State<FactionDatesListTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final faction = Provider.of<FactionNotifier>(context, listen: true);
    final textstyle = TextStyle(fontSize: AppData().fontsize - 4);
    String dates = '';
    if (faction.factionUpdateDates.isNotEmpty) {
      for (var f in AppData().factionList) {
        if (dates != '') dates = '$dates\n';
        dates = '$dates${f['name']}: ${faction.factionUpdateDates[f['name']]}';
      }
    }
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                !expanded ? 'Show Faction Updated Dates' : 'Hide Faction Updated Dates',
                style: textstyle,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Icon(
                  expanded ? Icons.remove_circle : Icons.add_circle,
                  size: AppData().fontsize + 10,
                ),
              ),
            ],
          ),
          expanded
              ? Text(
                  dates,
                  style: textstyle,
                )
              : Text(
                  '',
                  style: textstyle,
                ),
        ],
      ),
    );
  }
}
