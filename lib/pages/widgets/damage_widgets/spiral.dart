import 'dart:math';
import 'package:armybuilder/providers/armylist.dart';
import 'package:flutter/material.dart';

Widget spiral(List<int> branchvalues, int modelindex, ArmyListNotifier army, int? listindex, int? modelistindex) {
  double framesize = 100;
  const double spacing = 21;
  const double rotation = 1.75;
  const double dotsize = 18;
  List<List<Widget>> arms = [];
  List<Widget> spiral = [];
  List<List<Map<String, double>>> points = [];
  double leftmost = 2000;
  double topmost = 2000;
  double bottommost = 0;
  double left;
  double top;

  for (var h = 0; h < 6; h++) {
    double angle = (360 / 6 * (h + 1)) * pi / 180;
    double adjustx = 0;
    double adjusty = 0;

    switch (h) {
      case 1:
        adjustx = -1;
        adjusty = 5;
        break;
      case 3:
        adjustx = -4;
        adjusty = -3;
        break;
      case 5:
        adjustx = 5;
        adjusty = -2;
        break;
      default:
        adjustx = 0;
        adjusty = 0;
    }
    double r = 0;
    Map<String, double> point;
    points.add([]);
    for (var x = 0; x <= branchvalues[h]; x++) {
      r = sqrt(x + 1) * rotation;
      angle += asin(1 / r);
      left = (r * spacing * cos(angle)) + adjustx;
      top = (r * spacing * sin(angle)) + adjusty;
      if (left < leftmost) leftmost = left;
      if (top < topmost) topmost = top;
      if (top > bottommost) bottommost = top;
      point = {'left': left, 'top': top};
      points[h].add(point);
    }
  }

  framesize = bottommost - topmost + 30;
  leftmost = leftmost.abs() + 10;
  topmost = topmost.abs() + 5;
  for (var h = 0; h < 6; h++) {
    Color color = Colors.black;
    switch (h + 1) {
      case 1 || 2:
        color = Colors.blue;
        break;
      case 3 || 4:
        color = Colors.red;
        break;
      default:
        color = Colors.green;
    }

    List<Widget> arm = [];
    for (var b = 0; b < points[h].length - 1; b++) {
      arm.add(
        Positioned(
          left: points[h][b]['left']! + leftmost,
          top: points[h][b]['top']! + topmost,
          child: spiralBox(color, dotsize, h, b, army, listindex, modelistindex),
        ),
      );
    }

    arm.add(
      Positioned(
        left: points[h][points[h].length - 1]['left']! + leftmost,
        top: points[h][points[h].length - 1]['top']! + topmost,
        child: spiralArmNum(h, color),
      ),
    );
    arms.add(arm);
  }

  for (var a = 1; a <= 6; a++) {
    spiral.add(
      Stack(children: arms[a - 1]),
    );
  }

  return SizedBox(
    height: framesize,
    width: framesize,
    child: Stack(
      children: spiral,
    ),
  );
}

Widget spiralArmNum(int h, Color color) {
  return Container(
    height: 20,
    width: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: 1, color: Colors.black),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Text(
        (h + 1).toString(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget spiralBox(Color color, double dotsize, int branchnum, int dotnum, ArmyListNotifier army, int? listindex, int? modellistindex) {
  Color dotcolor = Colors.white;
  if (listindex != null && modellistindex != null) {
    if (army.hptracking[listindex][modellistindex].containsKey('spiral')) {
      if (army.hptracking[listindex][modellistindex]['spiral'][branchnum][dotnum]) {
        dotcolor = Colors.red;
      }
    }
  }
  return GestureDetector(
    onTap: () {
      if (listindex != null && modellistindex != null) {
        army.adjustSpiralDamage(listindex, modellistindex, branchnum, dotnum);
      }
    },
    child: Container(
      decoration: BoxDecoration(border: Border.all(width: 1.5, color: color), shape: BoxShape.circle),
      child: Container(
        height: dotsize,
        width: dotsize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: dotcolor),
      ),
    ),
  );
}
