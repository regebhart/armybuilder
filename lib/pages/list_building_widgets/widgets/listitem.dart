import 'package:armybuilder/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/faction.dart';
import '../../../providers/navigation.dart';

class ArmyListItem extends StatelessWidget {
  final Product product;
  final int? index;
  final void Function() onTap;
  final bool? minsize;
  final bool hod;
  final int? leaderindex;
  const ArmyListItem({required this.product, required this.index, required this.onTap, this.minsize, required this.hod, this.leaderindex, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    String cost = product.points!;
    String type = '';
    bool displayradio = false;

    double radioWidth = 30;

    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        type = 'warcaster';
        displayradio = true;
        break;
      case 'Solos':
        if (FactionNotifier().checkSoloForJourneyman(product) || FactionNotifier().checkProductForMarshal(product)) {
          if (product.selectable) {
            type = !hod ? 'jrcaster' : 'oofjrcaster';
            displayradio = true;
          }
        }
        break;
      default:
        break;
    }
    if (product.category.contains('Warcaster')) {
      int bgptotal = army.calculateBGP(index!);
      cost = '$bgptotal/$cost';
    }

    return Padding(
      padding: EdgeInsets.only(left: displayradio ? 0 : radioWidth, top: AppData().listItemSpacing, bottom: AppData().listItemSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (displayradio)
            SizedBox(
              width: radioWidth,
              child: GestureDetector(
                  onTap: () {
                    int factionindex = -1;
                    if (hod) {
                      factionindex = AppData().factionList.indexWhere((element) =>
                          element['name']!.toLowerCase() == army.armyList.leadergroup[army.hodleaderindex].heartofdarknessfaction!.toLowerCase());
                    }
                    army.updateSelectedCaster(type, product);
                    if (leaderindex != null) army.setHoDLeaderIndex(leaderindex!);
                    if (faction.selectedCategory == 1) {
                      faction.setSelectedCategory(
                        1,
                        army.selectedcasterProduct,
                        null,
                        army.selectedcasterFactionIndexes,
                        hod,
                        factionindex,
                        false,
                        army.armyList.listfaction,
                        army.armyList.solos.indexWhere((element) => element.name == 'Julius Raelthorne') >= 0,
                      );
                    }
                  },
                  child: Icon(
                    army.selectedcaster == index &&
                            (army.selectedcastertype == type || (army.selectedcastertype == 'oofcohort' && type == 'warcaster'))
                        ? Icons.radio_button_on
                        : Icons.radio_button_off,
                    size: AppData().fontsize + 5,
                  )),
            ),
          SizedBox(width: AppData().selectedListLeftWidth - radioWidth),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      product.removable
                          ? GestureDetector(
                              onTap: onTap,
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
                            )
                          : const SizedBox(width: 30),
                      SizedBox(width: AppData().listButtonSpacing),
                      GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                size: AppData().fontsize + 6,
                              ),
                            ),
                          ),
                          onTap: () {
                            army.setSelectedProduct(product);
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          }),
                      SizedBox(width: AppData().listButtonSpacing),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            army.setSelectedProduct(product);
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: AppData().fontsize,
                                maxHeight: AppData().fontsize * 2 + 25,
                              ),
                              child: Text(
                                product.name,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(fontSize: AppData().fontsize - 2),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (product.unitPoints!['maxcost'] != '-' && minsize != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 5.0),
                          child: InkWell(
                            onTap: () {
                              army.updateUnitSize(index!, hod, leaderindex);
                            },
                            child: Icon(
                              minsize! ? Icons.add_circle : Icons.remove_circle,
                              size: AppData().fontsize + 10,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: product.fanum.toString(),
                      style: TextStyle(
                        color: army.checkFALimit(product),
                        fontSize: AppData().fontsize - 2,
                      ),
                    ),
                    TextSpan(
                      text: '/${product.fa}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppData().fontsize - 2,
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
        ],
      ),
    );
  }
}
