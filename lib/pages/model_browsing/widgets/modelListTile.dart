import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/navigation.dart';

class ModelListTile extends StatelessWidget {
  final int index;
  final Product p;
  final int group;
  const ModelListTile({required this.index, required this.p, required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    
    Color normaltextcolor = Colors.grey.shade100;
    Color tilecolor = Colors.deepPurple.shade700;
    Color hovercolor = Colors.purple;

    if (group == 1) {
      tilecolor = Colors.indigoAccent.shade700;
      hovercolor = Colors.blue;
    }
    if (group == 2) {
      tilecolor = Colors.indigo.shade700;
      hovercolor = Colors.indigoAccent;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15),
      child: Padding(
        padding: index == 0 ? const EdgeInsets.only(bottom: 1.5) : const EdgeInsets.symmetric(vertical: 1.5),
        child: ClipRRect(
          child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                p.name,
                style: TextStyle(
                  fontSize: AppData().fontsize - 2,
                  color: normaltextcolor,
                ),
              ),
              dense: true,
              tileColor: tilecolor,
              hoverColor: hovercolor,
              onTap: () {
                army.setSelectedProduct(p);
                if (nav.swiping) {
                  nav.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                }
              }),
        ),
      ),
    );
  }
}
