import '../providers/armylist.dart';
import 'modularoptions.dart';
import 'product.dart';

class Cohort {
  Product product;
  List<Option>? selectedOptions;

  Cohort({
    required this.product,
    this.selectedOptions,
  });

  factory Cohort.fromJson(Map<String, dynamic> json) {
    Product product = ArmyListNotifier().blankproduct;
    List<Option> options = [];

    if (json.containsKey('product')) {
      product = Product.fromJson(json['product']);
      if (json.containsKey('options')) {
        for (var op in json['options']) {
          options.add(Option.fromJson(op));
        }
      }
    } else {
      product = Product.fromJson(json);
    }

    return Cohort(
      product: product,
      selectedOptions: options,
    );
  }

  factory Cohort.copy(Cohort cohort, bool copy) {
    return Cohort(
      product: Product.copyProduct(cohort.product, copy),
      selectedOptions: List.generate(
        cohort.selectedOptions!.length,
        (index) => cohort.selectedOptions![index],
      ),
    );
  }
}

class ValidCohortList {
  String factionchoice;
  List<Map<String, dynamic>> products;

  ValidCohortList({
    required this.factionchoice,
    required this.products,
  });

  factory ValidCohortList.fromJson(Map<String, dynamic> json) {
    String factionchoice = '';
    List<Map<String, dynamic>> products = [];
    
    if (json.containsKey('factionchoice')) {
      factionchoice = json['factionchoice'];
    }

    if (json.containsKey('products')) {
      for (var c in json['products']) {
        String faction = c['faction'];
        List<String> cohorts = [];
        for (var cohort in c['cohorts']) {
          cohorts.add(cohort);
        }
        products.add({'faction': faction, 'cohorts': cohorts});
      }
    }

    return ValidCohortList(
      factionchoice: factionchoice,
      products: products,
    );
  }
}
