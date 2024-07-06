import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/appdata.dart';
import '../../providers/armylist.dart';

class CurrentListPoints extends StatelessWidget {
  const CurrentListPoints({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);

    Widget points = RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        text: 'Points: ',
        style: TextStyle(
          color: Colors.white,
          fontSize: AppData().fontsize - 2,
        ),
        children: [
          TextSpan(
            text: army.currentpoints.toString(),
            style: TextStyle(
              color: army.currentpoints > army.encounterLevelSelected['armypoints'] ? Colors.red : Colors.white,
              fontSize: AppData().fontsize - 2,
            ),
          ),
          TextSpan(
            text: '/${army.encounterLevelSelected['armypoints']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppData().fontsize - 2,
            ),
          ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${army.factionSelected} Army List',
            style: TextStyle(fontSize: AppData().fontsize - 2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: points,
        ),
      ],
    );
  }
}
