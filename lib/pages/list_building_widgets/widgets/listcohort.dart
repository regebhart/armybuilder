import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cohort.dart';
import '../../../appdata.dart';
import '../../../providers/armylist.dart';
import '../../../providers/navigation.dart';

class CohortListItem extends StatelessWidget {
  final Cohort cohort;
  final int casterindex;
  final int groupindex;
  final int cohortindex;
  final String type;
  final bool oof;
  final int? leaderindex;
  final Product? leader;
  const CohortListItem(
      {required this.cohort,
      required this.casterindex,
      required this.groupindex,
      required this.cohortindex,
      required this.type,
      required this.oof,
      this.leaderindex,
      this.leader,
      super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);
    String cost = cohort.product.points!;

    return Padding(
      padding: EdgeInsets.only(
          left: cohort.product.models[0].modularoptions!.isNotEmpty ? 0 : AppData().selectedListLeftWidth + 20,
          top: AppData().listItemSpacing,
          bottom: AppData().listItemSpacing),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (cohort.product.models[0].modularoptions!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      army.updateSelectedCaster(type, leader!);
                      if (leaderindex != null) army.setHoDLeaderIndex(leaderindex!);
                      army.setCohortVals(groupindex, cohortindex, army.selectedcastertype);
                      faction.setShowModularGroupOptions(cohort.product);
                      if (nav.swiping) {
                        nav.builderPageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
                        child: Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: AppData().fontsize + 10,
                        ),
                      ),
                    ),
                  ),
                if (cohort.product.models[0].modularoptions!.isNotEmpty) SizedBox(width: AppData().listButtonSpacing + 27),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      cohort.product.removable
                          ? GestureDetector(
                              onTap: () {
                                army.removeCohort(
                                  groupindex,
                                  cohortindex,
                                  type,
                                  oof,
                                  leaderindex,
                                );
                                faction.setShowingOptions(false);
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
                            )
                          : SizedBox(
                              width: AppData().fontsize + 15,
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
                            if (cohort.product.models[0].modularoptions!.isEmpty) {
                              army.setSelectedProduct(cohort.product);
                            } else {
                              army.setSelectedCohortWithOptions(cohort);
                            }
                            if (nav.swiping) {
                              nav.builderPageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            }
                          }),
                      SizedBox(width: AppData().listButtonSpacing),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            if (cohort.product.models[0].modularoptions!.isEmpty) {
                              army.setSelectedProduct(cohort.product);
                            } else {
                              army.setSelectedCohortWithOptions(cohort);
                            }
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
                                cohort.product.name,
                                style: TextStyle(
                                  color: army.checkFALimit(cohort.product),
                                  fontSize: AppData().fontsize - 2,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
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
                      text: cohort.product.fanum.toString(),
                      style: TextStyle(
                        color: army.checkFALimit(cohort.product),
                        fontSize: AppData().fontsize - 2,
                      ),
                    ),
                    TextSpan(
                      text: '/${cohort.product.fa}',
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
