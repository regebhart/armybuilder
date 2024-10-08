import 'package:armybuilder/models/spells.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/navigation.dart';

class SpellListTile extends StatelessWidget {
  final int index;
  final Spell spell;
  final bool atlimit;
  const SpellListTile({required this.index, required this.spell, required this.atlimit, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    Color normaltextcolor = Colors.grey.shade100;
    Color limittextcolor = Colors.grey.shade400;
    Color tilecolor = Colors.deepPurple.shade700;
    Color limittilecolor = Colors.grey.shade800;
    Color hovercolor = Colors.purple;

    var toast = CherryToast.success(
      backgroundColor: Colors.green.shade500,
      animationType: AnimationType.fromTop,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      animationDuration: const Duration(milliseconds: 600),
      toastDuration: const Duration(milliseconds: 1500),
      toastPosition: Position.top,
      title: Text(
        '${spell.name} added to list.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: index == 0 ? const EdgeInsets.only(bottom: 1.5) : const EdgeInsets.symmetric(vertical: 1.5),
        child: ClipRRect(
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              spell.name,
              style: TextStyle(
                fontSize: AppData().fontsize - 2,
                color: atlimit ? limittextcolor : normaltextcolor,
              ),
            ),
            trailing: Text(
              spell.poolcost!,
              style: TextStyle(
                fontSize: AppData().fontsize - 2,
                color: atlimit ? limittextcolor : normaltextcolor,
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
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("RNG",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("AOE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("POW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("DUR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("OFF",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(spell.cost,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                            )),
                        Text(spell.rng,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                            )),
                        Text(spell.aoe ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                            )),
                        Text(spell.pow ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                            )),
                        Text(spell.dur ?? '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: atlimit ? limittextcolor : normaltextcolor,
                            )),
                        Text(
                          spell.off,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: atlimit ? limittextcolor : normaltextcolor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  spell.description,
                  style: TextStyle(
                    color: atlimit ? limittextcolor : normaltextcolor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            dense: true,
            tileColor: atlimit ? limittilecolor : tilecolor,
            hoverColor: hovercolor,
            onTap: () {
              army.addSpellToSpellRack(spell);
              toast.show(context);
              if (nav.swiping) {
                nav.builderPageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
              }
            },
          ),
        ),
      ),
    );
  }
}
