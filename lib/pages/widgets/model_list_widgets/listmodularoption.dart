import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appdata.dart';
import '../../../providers/armylist.dart';

class ModularOptionListItem extends StatelessWidget {
  final String title;
  final String cost;
  final int casterindex;
  final int cohortindex;
  final int groupindex;
  final String leadertype;
  const ModularOptionListItem(
      {required this.title, required this.cost, required this.casterindex, required this.cohortindex, required this.groupindex, required this.leadertype, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(left: 100, top: AppData().listItemSpacing, bottom: AppData().listItemSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      army.removeCohortOption(casterindex, cohortindex, groupindex, leadertype);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.red)),
                        child: Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: AppData().fontsize + 10,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppData().listButtonSpacing),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: AppData().fontsize,
                        maxHeight: AppData().fontsize * 2 + 25,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: AppData().fontsize - 2),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              cost,
              style: TextStyle(fontSize: AppData().fontsize - 2),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
