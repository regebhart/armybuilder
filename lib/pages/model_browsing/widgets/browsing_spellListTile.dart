import 'package:armybuilder/models/spells.dart';
import 'package:flutter/material.dart';

import '../../../../appdata.dart';

class BrowsingSpellListTile extends StatelessWidget {
  final Spell spell;
  const BrowsingSpellListTile({required this.spell, super.key});

  @override
  Widget build(BuildContext context) {

    Color normaltextcolor = Colors.grey.shade100;
    Color tilecolor = Colors.deepPurple.shade700;
    Color hovercolor = Colors.purple;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        child: ClipRRect(
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              spell.name,
              style: TextStyle(
                fontSize: AppData().fontsize - 2,
                color: normaltextcolor,
              ),
            ),
            trailing: Text(
              spell.poolcost!,
              style: TextStyle(
                fontSize: AppData().fontsize - 2,
                color: normaltextcolor,
              ),
              textAlign: TextAlign.right,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Table(
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("COST",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("RNG",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("AOE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("POW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("DUR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("OFF",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(spell.cost,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                            )),
                        Text(spell.rng,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                            )),
                        Text(spell.aoe ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                            )),
                        Text(spell.pow ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                            )),
                        Text(spell.dur ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: normaltextcolor,
                            )),
                        Text(
                          spell.off,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: normaltextcolor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  spell.description,
                  style: TextStyle(
                    color: normaltextcolor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            dense: true,
            tileColor: tilecolor,
            hoverColor: hovercolor,
            // onTap: () {
            //   army.addSpellToSpellRack(spell);
            //   toast.show(context);
            //   if (nav.swiping) {
            //     nav.builderPageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
            //   }
            // },
          ),
        ),
      ),
    );
  }
}
