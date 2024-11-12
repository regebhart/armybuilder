import 'package:armybuilder/pages/list_building_widgets/buttons/copytoclipboardbutton.dart';
import 'package:armybuilder/pages/deployed_list/deployedlist.dart';
import 'package:armybuilder/pages/product_stat_pages/singlemodelstatpage.dart';
import 'package:armybuilder/pages/import_export/importfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/armylist.dart';
import '../../providers/navigation.dart';

class ArmyDeploymentSwiping extends StatefulWidget {
  const ArmyDeploymentSwiping({super.key});

  @override
  State<ArmyDeploymentSwiping> createState() => _ArmyDeploymentSwipingState();
}

class _ArmyDeploymentSwipingState extends State<ArmyDeploymentSwiping> {
  PageController pageController = PageController();
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    List<Widget> additionallists = [];
    Widget opponentmodel = const SizedBox();

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

    if (army.deployedLists.length > 1) {
      for (int d = 1; d < army.deployedLists.length; d++) {
        opponentmodel = Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Text(
                            'Opponent Model',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                child: SingleModelStatPage(listindex: d),
              ),
            ],
          ),
        );
        additionallists.add(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Text(
                                    'Opponent List',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(army.deployedLists[d].list.name),
                      Text('Faction: ${army.deployedLists[d].list.listfaction}'),
                      Text('Points: ${army.deployedLists[d].list.totalpoints} / ${army.deployedLists[d].list.pointtarget}'),
                    ],
                  ),
                ),
                DeployedListWidget(listindex: d),
              ],
            ),
          ),
        ));
      }
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => updateBottomBarIndex(value),
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(army.deployedLists.isNotEmpty ? army.deployedLists[0].list.name : ''),
                                  Text('Faction: ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.listfaction : ''}'),
                                  Text(
                                      'Points: ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.totalpoints : ''} / ${army.deployedLists.isNotEmpty ? army.deployedLists[0].list.pointtarget : ''}'),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: CopyToClipboardButton(),
                            ),
                          ],
                        ),
                        const DeployedListWidget(
                          listindex: 0,
                        ),
                        if (additionallists.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 50, right: 15),
                            child: Column(
                              children: [
                                Text('Import Opponents List'),
                                SizedBox(
                                  height: 10,
                                ),
                                ImportPastedList(opponent: true),
                              ],
                            ),
                          ),
                        if (additionallists.isNotEmpty) ...additionallists,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600, minWidth: 450),
                        child: const SingleModelStatPage(listindex: 0),
                      ),
                    ),
                    opponentmodel,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
