import 'package:armybuilder/models/modularoptions.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/appdata.dart';

class ModularOptionList extends StatefulWidget {
  const ModularOptionList({super.key});

  @override
  State<ModularOptionList> createState() => _ModularOptionListState();
}

class _ModularOptionListState extends State<ModularOptionList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);
    Color normaltextcolor = Colors.grey.shade100;
    // Color limittextcolor = Colors.grey.shade400;
    // Color limittilecolor = Colors.grey.shade800;

    return ListView.builder(
        itemCount: faction.modeloptions.length,
        itemBuilder: (context, i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(faction.modeloptions[i].groupname),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                    itemCount: faction.modeloptions[i].options!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Option op = faction.modeloptions[i].options![index];
                      String cost = op.cost;

                      var toast = CherryToast.success(
                        backgroundColor: Colors.green.shade500,
                        animationType: AnimationType.fromTop,
                        animationCurve: Curves.fastLinearToSlowEaseIn,
                        animationDuration: const Duration(milliseconds: 600),
                        toastDuration: const Duration(milliseconds: 1500),
                        toastPosition: Position.top,
                        title: Text(
                          '${op.name} added to list.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: Padding(
                          padding: index == 0 ? const EdgeInsets.only(bottom: 1.5) : const EdgeInsets.symmetric(vertical: 1.5),
                          child: ClipRRect(
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                op.name,
                                style: TextStyle(
                                  fontSize: AppData().fontsize - 2,
                                  color: normaltextcolor,
                                ),
                              ),
                              trailing: Text(
                                cost,
                                style: TextStyle(
                                  fontSize: AppData().fontsize - 4,
                                  color: normaltextcolor,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              dense: true,
                              tileColor: army.checkIfAnyOptionSelected(i)
                                  ? army.checkIfOptionSelected(op, i)
                                      ? Colors.deepPurple[700]
                                      : Colors.grey.shade800
                                  : Colors.deepPurple[700],
                              hoverColor: Colors.purple,
                              onTap: () {
                                army.setCohortOption(op, i);
                                toast.show(context);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}
