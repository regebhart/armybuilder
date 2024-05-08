import 'package:armybuilder/models/armylist.dart';
import 'package:armybuilder/models/product.dart';

class DeployedArmyList {
  ArmyList list;
  Product selectedProduct;
  Cohort selectedCohort;
  int selectedModelIndex;
  int selectedListModelIndex;
  int barcount;

  DeployedArmyList({
    required this.list,
    required this.selectedProduct,
    required this.selectedCohort,
    required this.selectedModelIndex,
    required this.selectedListModelIndex,
    required this.barcount,
  });
}
