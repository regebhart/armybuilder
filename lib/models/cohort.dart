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
}