import 'package:armybuilder/pages/deployed_list/deploymainview.dart';
import 'package:armybuilder/pages/import_export/importexport.dart';
import 'package:armybuilder/pages/layouts/wide.dart';
import 'package:armybuilder/pages/menu_widgets/factionselection.dart';
import 'package:armybuilder/pages/list_selection/lists.dart';
import 'package:armybuilder/pages/menu_widgets/mainmenu.dart';
import 'package:armybuilder/pages/layouts/narrow-swiping.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    const double maxwidth = 800;
    army.setPageController(pageController);

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        const MainMenu(),
        LayoutBuilder(builder: (context, constraints) {
          bool swiping = constraints.maxWidth < maxwidth;
          army.setSwiping(swiping);
          return FactionSelection(swiping: swiping);
        }),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < maxwidth) {
            return SwipingArmyBuildingNarrowLayout(status: army.status);
          } else {
            return const ArmyBuildingWideLayout();
          }
        }),
        const SavedArmyLists(),
        const ImportExport(),
        const ArmyDeployment(),
      ],
    );
  }
}
