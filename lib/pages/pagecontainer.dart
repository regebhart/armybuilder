import 'package:armybuilder/pages/deployed_list/deploymainview.dart';
import 'package:armybuilder/pages/deployed_list/deploymainviewswiping.dart';
import 'package:armybuilder/pages/import_export/importexport.dart';
import 'package:armybuilder/pages/list_building_widgets/layouts/wide.dart';
import 'package:armybuilder/pages/menu_widgets/factionselection.dart';
import 'package:armybuilder/pages/armylist_selection/armylists.dart';
import 'package:armybuilder/pages/menu_widgets/mainmenu.dart';
import 'package:armybuilder/pages/list_building_widgets/layouts/narrow-swiping.dart';
import 'package:armybuilder/pages/model_browsing/layouts/narrow-swiping.dart';
import 'package:armybuilder/pages/model_browsing/layouts/wide.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation.dart';

class PagesContainer extends StatefulWidget {
  const PagesContainer({super.key});

  @override
  State<PagesContainer> createState() => _PagesContainerState();
}

class _PagesContainerState extends State<PagesContainer> {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    NavigationNotifier nav = Provider.of<NavigationNotifier>(context, listen: false);

    const double minwidth = 1080; //minimum width to display wide layout
    nav.setPageController(pageController);

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        //1:menu
        const MainMenu(),

        //2:model browsing
        LayoutBuilder(builder: (context, constraints) {
          bool swiping = constraints.maxWidth < minwidth;
          nav.setSwiping(swiping);
          if (swiping) {
            return SwipingBrowsingNarrowLayout(status: army.status);
          } else {
            return const BrowsingWideLayout();
          }
        }),

        //3:faction selection
        LayoutBuilder(builder: (context, constraints) {
          bool swiping = constraints.maxWidth < minwidth;
          nav.setSwiping(swiping);
          return FactionSelection(swiping: swiping);
        }),

        //3:list building
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < minwidth) {
            return SwipingArmyBuildingNarrowLayout(status: army.status);
          } else {
            return const ArmyBuildingWideLayout();
          }
        }),

        //4:edit/deploy army lists
        const SavedArmyLists(),

        //5:import or export lists
        const ImportExport(),

        //6:deployed lists/playing a game
        LayoutBuilder(builder: (context, constraints) {
          bool swiping = constraints.maxWidth < minwidth;
          nav.setSwiping(swiping);
          if (swiping) {
            return const ArmyDeploymentSwiping();
          } else {
            return const ArmyDeploymentWideView();
          }
        }),
      ],
    );
  }
}
