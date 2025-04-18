import 'package:armybuilder/models/cohort.dart';
import 'package:uuid/uuid.dart';

import 'model.dart';

class Product {
  List<String> primaryFaction;
  List<String> factions;
  String name;
  String fa;
  String basefa;
  String? attachlimit;
  String? points;
  List<Model> models;
  String category;
  Map<String, dynamic>? unitPoints;
  int fanum;
  bool selectable;
  bool removable;
  List<ValidCohortList>? validcohortmodels;
  String uuid;

  Product({
    required this.primaryFaction,
    required this.factions,
    required this.name,
    required this.category,
    required this.fa,
    required this.basefa,
    this.attachlimit,
    this.points,
    required this.models,
    this.unitPoints,
    required this.fanum,
    required this.selectable,
    required this.removable,
    this.validcohortmodels,
    required this.uuid,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> primaryfaction = [];
    String fieldallowance = '';
    Map<String, dynamic> unitpoints = {};

    print(json['name']);

    if (json.containsKey('primaryfaction')) {
      primaryfaction = (json['primaryfaction'] as List).map((e) => e as String).toList();
    }

    List<String> factions = [];

    if (json.containsKey('factions')) {
      factions = (json['factions'] as List).map((e) => e as String).toList();
    }

    if (json.containsKey('fieldallowance')) {
      fieldallowance = json['fieldallowance'];
    }

    String productname = json['name'];
    // print(productname);
    String productpoints = '';
    if (json.containsKey('points')) {
      productpoints = json['points'];
    }

    String attachlimit = '';
    if (json.containsKey('attachlimit')) {
      attachlimit = json['attachlimit'];
    }

    List<Model> models = [];
    for (var m in json['models']) {
      Model model = Model.fromJson(m);
      models.add(model);
    }

    String category = '';
    if (json.containsKey('category')) {
      final List<String> modelTypes = [
        'Warcasters/Warlocks/Masters',
        'Warjacks/Warbeasts/Horrors',
        'Solos',
        'Units',
        'Attachments',
        'Battle Engines',
      ];

      category = json['category'];
      modelTypes.forEach((element) {
        if (element.toLowerCase().contains(json['category'])) {
          category = element;
        }
      });
    }

    if (json.containsKey('unitpoints')) {
      unitpoints = json['unitpoints'];
      if (unitpoints.containsKey('mincost')) {
        unitpoints['basemincost'] = unitpoints['mincost'];
      }
      if (unitpoints.containsKey('maxcost')) {
        unitpoints['basemaxcost'] = unitpoints['maxcost'];
      }
    }

    List<ValidCohortList> validcohort = [];
    if (json.containsKey('validcohortmodels')) {
      for (var c in json['validcohortmodels']) {
        validcohort.add(ValidCohortList.fromJson(c));
      }
    }

    return Product(
      primaryFaction: primaryfaction,
      factions: factions,
      name: productname,
      category: category,
      fa: fieldallowance,
      basefa: fieldallowance,
      attachlimit: attachlimit,
      points: productpoints,
      models: models,
      unitPoints: unitpoints,
      fanum: 0,
      selectable: true,
      removable: true,
      validcohortmodels: validcohort,
      uuid: const Uuid().v1(),
    );
  }

  factory Product.copyProduct(Product product, bool copy) {
    Map<String, dynamic> unitpoints = {};
    if (product.unitPoints != null) {
      unitpoints = Map.from(product.unitPoints!);
    }

    Product newcopy = Product(
      primaryFaction: product.primaryFaction,
      factions: product.factions,
      name: product.name,
      category: product.category,
      fa: product.fa,
      basefa: product.basefa,
      attachlimit: product.attachlimit,
      points: product.points,
      selectable: product.selectable,
      removable: product.removable,
      models: List.generate(
        product.models.length,
        (index) => Model.copy(
          product.models[index],
        ),
      ),
      unitPoints: unitpoints,
      fanum: product.fanum,
      validcohortmodels: product.validcohortmodels,
      uuid: copy
          ? product.uuid == ''
              ? const Uuid().v1()
              : product.uuid
          : const Uuid().v1(),
    );
    return newcopy;
  }
}
