import 'package:armybuilder/pages/model_browsing/categoryModelsList.dart';
import 'package:armybuilder/pages/model_browsing/categorylist.dart';
import 'package:armybuilder/pages/model_browsing/widgets/factiondropdown.dart';
import 'package:armybuilder/pages/product_stat_pages/productstatpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BrowsingWideLayout extends StatefulWidget {
  const BrowsingWideLayout({super.key});

  @override
  State<BrowsingWideLayout> createState() => _BrowsingWideLayoutState();
}

class _BrowsingWideLayoutState extends State<BrowsingWideLayout> {
  @override
  void dispose() {
    // ignore: avoid_print
    print('disposed wide layout');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('Select Faction:'),
              ),
              SizedBox(width: 500, child: FactionDropDown()),
            ],
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 1250),
                        child: const BrowsingCategoryList(),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 10,
                  child: BrowsingModelsList(),
                ),
                const Flexible(
                  flex: 15,
                  child: SingleChildScrollView(
                      child: ProductStatPage(
                    deployed: false,
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
