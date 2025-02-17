import 'package:armybuilder/pages/model_browsing/browsing_categoryModelsList.dart';
import 'package:armybuilder/pages/model_browsing/widgets/factiondropdown.dart';
import 'package:armybuilder/pages/product_cards/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/faction.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: true); //for testing card

    return Scaffold(
        body: SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              FactionDropDown(),
              BrowsingModelsList(),
            ],
          ),
          // ModelCard(),
        ],
      ),
    ));
  }
}
