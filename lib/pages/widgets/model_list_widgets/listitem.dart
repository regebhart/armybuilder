import 'package:armybuilder/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/faction.dart';

class ArmyListItem extends StatelessWidget {
  final Product product;
  final int index;
  final void Function() onTap;
  final bool? minsize;
  const ArmyListItem({required this.product, required this.index, required this.onTap, this.minsize, super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    String cost = product.points!;
    String type = '';
    bool displayradio = false;
    switch (product.category) {
      case 'Warcasters/Warlocks/Masters':
        type = 'warcaster';
        displayradio = true;
        break;
      case 'Solos':
        if (FactionNotifier().checkSoloForJourneyman(product) || FactionNotifier().checkProductForMashal(product)) {
          type = 'jrcaster';
          displayradio = true;
        }
        break;
      default:
        break;
    }
    if (product.category.contains('Warcaster')) {
      int bgptotal = army.calculateBGP(index);
      cost = '$bgptotal/$cost';
    }

    return Padding(
      padding: EdgeInsets.only(left: displayradio ? 0 : 50, top: AppData().listItemSpacing, bottom: AppData().listItemSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (displayradio)
            SizedBox(
              width: 50,
              child: GestureDetector(
                  onTap: () => army.updateSelectedCaster(
                        index,
                        type,
                      ),
                  child: Icon(
                    army.selectedcaster == index ? Icons.radio_button_on : Icons.radio_button_off,
                    size: AppData().fontsize + 5,
                  )),
            ),
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
                      GestureDetector(
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
                      ),
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
                            if (army.swiping) {
                              army.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          }),
                      SizedBox(width: AppData().listButtonSpacing),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            army.setSelectedProduct(product);
                            if (army.swiping) {
                              army.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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
                              army.updateUnitSize(index);
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
                  // text: 'FA: ',
                  // style: TextStyle(
                  //   color: Colors.white,
                  //   fontSize: AppData().fontsize,
                  // ),
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
