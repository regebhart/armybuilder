import 'dart:math';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

Widget web(int outer, int middle, int inner, ArmyListNotifier army, int? listindex, int? modelindex) {
  const double dotsize = 18;
  const double outerradius = 120;
  const double middleradius = 90;
  const double innerradius = 60;
  const double padding = 14;
  const double framesize = outerradius * 2 + padding * 2;
  const double framecenter = outerradius;

  List<Widget> outerWidgets = List.generate(
      outer, (index) => ring(outerradius, (360 / outer * index) - 90, dotsize, framecenter, 0, index, army, listindex, modelindex, padding));
  List<Widget> middleWidgets = List.generate(
      middle, (index) => ring(middleradius, (360 / middle * index) + 90, dotsize, framecenter, 1, index, army, listindex, modelindex, padding));
  List<Widget> innerWidgets = List.generate(
      inner, (index) => ring(innerradius, (360 / inner * index) - 90, dotsize, framecenter, 2, index, army, listindex, modelindex, padding));

  // outerWidgets = outerWidgets.reversed.toList();
  // middleWidgets = middleWidgets.reversed.toList();
  // innerWidgets = innerWidgets.reversed.toList();

  outerWidgets.insert(
      0,
      Center(
          child: Container(
              height: outerradius * 2,
              width: outerradius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Colors.red[200]!),
              ))));

  middleWidgets.insert(
      0,
      Center(
          // left: framesize / 2 - middleradius,
          // top: framesize / 2 - middleradius,
          child: Container(
              height: middleradius * 2,
              width: middleradius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Colors.red[600]!),
              ))));

  innerWidgets.insert(
      0,
      Center(
          // left: framesize / 2 - innerradius,
          // top: framesize / 2 - innerradius,
          child: Container(
              height: innerradius * 2,
              width: innerradius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Colors.red[900]!),
              ))));

  List<Widget> web = [];
  web.addAll(outerWidgets);
  web.addAll(middleWidgets);
  web.addAll(innerWidgets);

  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.all(padding),
      child: SizedBox(
        height: framesize,
        width: framesize,
        child: Stack(
          children: web,
        ),
      ),
    ),
  );
}

Widget ring(double radius, double angle, double dotsize, double center, int ringindex, int dotindex, ArmyListNotifier army, int? listindex,
    int? modelindex, double padding) {
  final double rad = radians(angle);
  Widget box = webBox(Colors.black, dotsize, ringindex, dotindex, army, listindex, modelindex);
  return Positioned(
    top: center + (dotsize / 2) + (radius * sin(rad)) - (padding / 2),
    left: center + (dotsize / 2) + (radius * cos(rad)) - (padding / 2),
    child: box,
  );
}

// Widget outerboxes(double radius, double angle, double dotsize) {
//   final double rad = radians(angle - 90);
//   Widget box = spiralBox(Colors.black, dotsize);
//   const double radius = 120;
//   return Positioned(
//     top: radius + (radius * sin(rad)),
//     left: radius + (radius * cos(rad)),
//     child: box,
//   );
// }

// Widget middleboxes(double radius, double angle, double dotsize) {
//   final double rad = radians(angle + 90);
//   Widget box = spiralBox(Colors.black, dotsize);
//   const double radius = 85;
//   return Positioned(
//     top: 120 + (radius * sin(rad)),
//     left: 120 + (radius * cos(rad)),
//     child: box,
//   );
// }

// Widget innerboxes(double radius, double angle, double dotsize) {
//   final double rad = radians(angle - 90);
//   Widget box = spiralBox(Colors.black, dotsize);
//   const double radius = 50;
//   return Positioned(
//     top: 120 + (radius * sin(rad)),
//     left: 120 + (radius * cos(rad)),
//     child: box,
//   );
// }

Widget webBox(Color color, double dotsize, int ringindex, int dotindex, ArmyListNotifier army, int? listindex, int? modelindex) {
  Color dotcolor = Colors.white;
  if (listindex != null && modelindex != null) {
    if (army.hptracking[listindex][modelindex].containsKey('web')) {
      if (army.hptracking[listindex][modelindex]['web'][ringindex][dotindex]) {
        dotcolor = Colors.red;
      }
    }
  }
  return GestureDetector(
    onTap: () {
      if (listindex != null && modelindex != null) {
        army.adjustWebDamage(listindex, modelindex, ringindex, dotindex);
      }
    },
    child: Container(
      decoration: BoxDecoration(border: Border.all(width: 3, color: color), shape: BoxShape.circle),
      child: Container(
        height: dotsize,
        width: dotsize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: dotcolor),
      ),
    ),
  );
}
