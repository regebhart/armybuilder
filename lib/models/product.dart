import 'model.dart';

class Product {
  List<String> primaryFaction;
  List<String> factions;
  String name;
  String fa;
  String? attachlimit;
  String? points;
  List<Model> models;
  String category;
  Map<String, dynamic>? unitPoints;
  int fanum;

  Product({
    required this.primaryFaction,
    required this.factions,
    required this.name,
    required this.category,
    required this.fa,
    this.attachlimit,
    this.points,
    required this.models,
    this.unitPoints,
    required this.fanum,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> primaryfaction = [];
    String fieldallowance = '';
    Map<String, dynamic> unitpoints = {};

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
    }

    return Product(
      primaryFaction: primaryfaction,
      factions: factions,
      name: productname,
      category: category,
      fa: fieldallowance,
      attachlimit: attachlimit,
      points: productpoints,
      models: models,
      unitPoints: unitpoints,
      fanum: 0,
    );
  }

  factory Product.copyProduct(Product product) {
    Product newcopy = Product(
      primaryFaction: product.primaryFaction,
      factions: product.factions,
      name: product.name,
      category: product.category,
      fa: product.fa,
      attachlimit: product.attachlimit,
      points: product.points,
      models: List.generate(
        product.models.length,
        (index) => Model.copy(
          product.models[index],
        ),
      ),
      unitPoints: product.unitPoints,
      fanum: product.fanum,
    );
    return newcopy;
  }
}
