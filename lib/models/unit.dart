import '../providers/armylist.dart';
import 'cohort.dart';
import 'product.dart';

class Unit {
  Product unit;
  bool minsize;
  bool hasMarshal;
  Product commandattachment;
  List<Product> weaponattachments;
  List<Cohort> cohort;
  List<int> weaponattachmentlimits;

  Unit({
    required this.unit,
    required this.minsize,
    required this.hasMarshal,
    required this.commandattachment,
    required this.weaponattachments,
    required this.cohort,
    required this.weaponattachmentlimits,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    Product command = ArmyListNotifier().blankproduct;
    bool hasmarshal = false;

    if (json.containsKey('hasmarshal')) {
      hasmarshal = json['hasmarshal'];
    }

    if (json.containsKey('commandattachment')) {
      command = Product.fromJson(json['commandattachment']);
    }

    List<Product> weapons = [];
    if (json.containsKey('weaponattachments')) {
      for (var wa in json['weaponattachments']) {
        weapons.add(Product.fromJson(wa));
      }
    }

    List<Cohort> cohort = [];
    if (json.containsKey('cohort')) {
      for (var c in json['cohort']) {
        cohort.add(Cohort.fromJson(c));
      }
    }

    List<int> weaponattachmentlimits = [3, 3];

    return Unit(
      unit: Product.fromJson(json['unit']),
      minsize: json['minsize'],
      hasMarshal: hasmarshal,
      commandattachment: command,
      weaponattachments: weapons,
      cohort: cohort,
      weaponattachmentlimits: weaponattachmentlimits,
    );
  }

  factory Unit.copy(Unit unit, bool copy) {
    return Unit(
      unit: Product.copyProduct(unit.unit, copy),
      minsize: unit.minsize,
      hasMarshal: unit.hasMarshal,
      commandattachment: Product.copyProduct(unit.commandattachment, copy),
      weaponattachments: List.generate(
        unit.weaponattachments.length,
        (index) => unit.weaponattachments[index],
      ),
      cohort: List.generate(
        unit.cohort.length,
        (index) => unit.cohort[index],
      ),
      weaponattachmentlimits: List.generate(
        unit.weaponattachmentlimits.length,
        (index) => unit.weaponattachmentlimits[index],
      ),
    );
  }
}
