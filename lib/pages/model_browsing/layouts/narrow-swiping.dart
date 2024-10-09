import 'package:armybuilder/pages/model_browsing/browsing_categoryModelsList.dart';
import 'package:armybuilder/pages/model_browsing/browsing_categorylist.dart';
import 'package:armybuilder/pages/product_stat_pages/productstatpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/armylist.dart';
import '../../../providers/navigation.dart';
import '../widgets/factiondropdown.dart';

class SwipingBrowsingNarrowLayout extends StatefulWidget {
  final String status;
  const SwipingBrowsingNarrowLayout({required this.status, super.key});

  @override
  State<SwipingBrowsingNarrowLayout> createState() => _SwipingBrowsingNarrowLayoutState();
}

class _SwipingBrowsingNarrowLayoutState extends State<SwipingBrowsingNarrowLayout> {
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
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    nav.setBuilderPageController(pageController);

    void updateBottomBarIndex(int index) {
      if (index != _bottomBarIndex) {
        if (_bottomBarIndex == 1) {
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
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) => updateBottomBarIndex(value),
              children: const [
                Scaffold(
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text('Select Faction:'),
                            ),
                            FactionDropDown(),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: BrowsingCategoryList(),
                              ),
                            ),
                            Flexible(
                              flex: 17,
                              child: BrowsingModelsList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
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
