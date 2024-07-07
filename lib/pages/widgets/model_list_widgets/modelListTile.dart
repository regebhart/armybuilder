import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../providers/appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/navigation.dart';

class CategoryModelListTile extends StatelessWidget {
  final int index;
  final Product p;
  final bool atlimit;
  final String cost;
  final void Function() onTap;
  final int group;
  const CategoryModelListTile({required this.index, required this.p, required this.atlimit, required this.cost, required this.onTap, required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    
    Color normaltextcolor = Colors.grey.shade100;
    Color limittextcolor = Colors.grey.shade400;
    Color tilecolor = Colors.deepPurple.shade700;
    Color limittilecolor = Colors.grey.shade800;
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
            leading: GestureDetector(
              onTap: () {
                army.setSelectedProduct(p);
                if (nav.swiping) {
                  nav.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              p.name,
              style: TextStyle(
                fontSize: AppData().fontsize - 2,
                color: atlimit ? limittextcolor : normaltextcolor,
              ),
            ),
            trailing: Text(
              cost,
              style: TextStyle(
                fontSize: AppData().fontsize - 4,
                color: atlimit ? limittextcolor : normaltextcolor,
              ),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              'FA: ${p.fa}', // ${atlimit ? ' Met!' : ''}',
              style: TextStyle(
                color: atlimit ? limittextcolor : normaltextcolor,
              ),
            ),
            dense: true,
            tileColor: atlimit ? limittilecolor : tilecolor,
            hoverColor: hovercolor,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
