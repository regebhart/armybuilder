import 'package:armybuilder/pages/list_building_widgets/buttonRow.dart';
import 'package:armybuilder/pages/list_building_widgets/categorylist.dart';
import 'package:armybuilder/pages/list_building_widgets/listNameField.dart';
import 'package:armybuilder/pages/list_building_widgets/modularItemsList.dart';
import 'package:armybuilder/pages/product_stat_pages/productstatpage.dart';
import 'package:armybuilder/pages/list_building_widgets/pointselect.dart';
import 'package:armybuilder/pages/list_building_widgets/selectedModelsList.dart';
import 'package:armybuilder/pages/list_building_widgets/categoryModelsList.dart';
import 'package:armybuilder/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/armylist.dart';
import '../../../providers/faction.dart';
import '../../../providers/navigation.dart';

class SwipingArmyBuildingNarrowLayout extends StatefulWidget {
  final String status;
  const SwipingArmyBuildingNarrowLayout({required this.status, super.key});

  @override
  State<SwipingArmyBuildingNarrowLayout> createState() => _SwipingArmyBuildingNarrowLayoutState();
}

class _SwipingArmyBuildingNarrowLayoutState extends State<SwipingArmyBuildingNarrowLayout> {
  PageController pageController = PageController();
  int _bottomBarIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.status == 'edit' ? 1 : 0);
    if (widget.status == 'edit') _bottomBarIndex = 1;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    nav.setBuilderPageController(pageController);
    nav.setSwiping(true);

    void updateBottomBarIndex(int index) {
      if (index != _bottomBarIndex) {
        if (_bottomBarIndex == 2) {
          army.setSelectedProduct(army.blankproduct);
        }
        setState(() {
          _bottomBarIndex = index;
        });
      }
    }

    void bottomBarTap(int index) {
      if (index != _bottomBarIndex) {
        updateBottomBarIndex(index);
        pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    }

    String cost = '';
    if (army.selectedcasterProduct.name != '' && army.selectedcasterProduct.category.contains('Warcaster')) {
      int bgptotal = army.calculateBGP(army.selectedcaster);
      cost = ' $bgptotal/${army.selectedcasterProduct.points}';
    }

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

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            label: 'Models',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Model Stats',
          ),
        ],
        currentIndex: _bottomBarIndex,
        onTap: bottomBarTap,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.blue.shade400,
        backgroundColor: Colors.grey.shade900,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: PointSelect(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '${army.factionSelected} Army List',
                style: TextStyle(fontSize: AppData().fontsize - 2),
              ),
              points,
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) => updateBottomBarIndex(value),
              children: [
                Scaffold(
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: SizedBox(
                          height: AppData().fontsize + 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.purple,
                              child: Center(
                                child: Text(
                                  army.selectedcasterProduct.name != '' ? '${army.selectedcasterProduct.name} Selected$cost' : 'No leader selected',
                                  style: TextStyle(fontSize: AppData().fontsize - 4, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: CategoryList(),
                              ),
                            ),
                            Flexible(
                              flex: 17,
                              child: !faction.showingoptions ? const CategoryModelsList() : const ModularOptionList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Scaffold(
                  body: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListNameField(),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: ButtonRow(),
                        ),
                        Flexible(
                          flex: 11,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: SingleChildScrollView(
                              child: ModelSelectedList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: ProductStatPage(
                        deployed: false,
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
