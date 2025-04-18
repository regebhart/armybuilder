// Widget cardspiral(double x, double y, double spiralwidth, double spiralheight, List<int> values, bool gargantuan) {
//   const double dotsize = 24 / scalevalue;
//   const double backsize = dotsize + (20 / scalevalue);

//   double framecenterx = spiralwidth / 2;
//   double framecentery = spiralheight / 2;
//   Color dotbordercolor = Colors.white;
//   Color backcolor = Colors.white;
//   List<Widget> spiral = [];
//   List<Widget> backs = [];
//   List<Widget> lines = [];

//   if (gargantuan) {
//     framecenterx = spiralwidth / 2;
//     framecentery = spiralheight / 2 - (60 / scalevalue);
//   }

//   for (var branch = 0; branch < values.length; branch++) {
//     double angle = (360 / values.length) * branch;
//     double wrapangle = 90.0;

//     double topoffset = 0;
//     double leftoffset = 0;

//     switch (branch) {
//       case 1:
//         topoffset = dotsize * 0.6; // -dotsize * positive goes up
//         leftoffset = -dotsize * 0.15; // dotsize * positive goes right
//         break;
//       case 3:
//         topoffset = -dotsize * 0.5;
//         leftoffset = -dotsize * 0.5; // dotsize * positive goes right
//         break;
//       case 5:
//         topoffset = -dotsize * 0.15;
//         leftoffset = dotsize * 0.6;
//         break;
//       default:
//         break;
//     }

//     switch (branch + 1) {
//       case 1 || 2:
//         dotbordercolor = Colors.blue;
//         backcolor = Colors.purple;
//         break;
//       case 3 || 4:
//         dotbordercolor = Colors.red;
//         backcolor = Colors.deepOrange;
//         break;
//       default:
//         dotbordercolor = Colors.green;
//         backcolor = Colors.yellow;
//     }

//     // if (branch.isEven) {
//     for (int d = 2; d < values[branch] + 2; d++) {
//       angle = angle + (wrapangle / (d + 1) * 1.25);

//       spiral.add(spiralbranch(angle, dotsize, framecenterx, framecentery, branch, d, topoffset, leftoffset, dotbordercolor));
//       // backs.add(spiralBackground(angle, framecenterx, framecentery, d, backcolor, dotsize, backsize, topoffset, leftoffset));

//       // if (d != values[branch] + 1) {
//       //   lines.add(spiralLine(angle, framecenterx, framecentery, d, dotsize, backsize, topoffset, leftoffset, branch, false));
//       //   if (d == 3 && branch.isEven) {
//       //     lines.add(spiralLine(angle, framecenterx, framecentery, d, dotsize, backsize, topoffset, leftoffset, branch, true));
//       //   }
//       // }
//     }

//     angle = angle + (wrapangle / (values[branch] + 1.5) * 1.25);

//     spiral.add(Positioned(
//       top: framecentery + ((values[branch] + 2) * dotsize * sin(radians(angle)) * 0.9) + topoffset,
//       left: framecenterx + ((values[branch] + 2) * dotsize * cos(radians(angle)) * 0.9) + leftoffset,
//       child: Container(
//         decoration: BoxDecoration(border: Border.all(width: 1.5, color: Colors.green), shape: BoxShape.circle),
//         child: Container(
//           height: dotsize + (4 / scalevalue),
//           width: dotsize + (4 / scalevalue),
//           decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//           child: Text(
//             (branch + 1).toString(),
//             style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     ));
//     angle = angle + (wrapangle / values[branch]);
//   }
//   return Positioned(
//     left: x,
//     top: y,
//     child: SizedBox(
//       width: spiralwidth,
//       height: spiralheight,
//       child: Stack(children: [
//         // Image.asset(
//         //   'assets/card_assets/parts/Infernal Circle.png',
//         //   width: webwidth / scalevalue,
//         //   height: webheight / scalevalue,
//         // ),
//         ...backs,
//         ...lines,
//         ...spiral,
//       ]),
//     ),
//   );
// }


// Widget spiralLine(double angle, double centerx, double centery, int dotindex, double dotsize, double backsize, double topoffset, double leftoffset,
//     int branch, bool offbranch) {
//   final double rad = radians(angle);

//   return Positioned(
//     top: centery + ((dotindex - 0.5) * dotsize * sin(rad) * 0.9) + topoffset - ((backsize / 2) - (dotsize / 2)),
//     left: centerx + ((dotindex - 0.5) * dotsize * cos(rad) * 0.9) + leftoffset - ((backsize / 2) - (dotsize / 2)),
//     child: Transform.rotate(
//       angle: radians(angle + 60 + (!offbranch ? 0 : 60)),
//       child: SizedBox(
//         width: backsize,
//         height: backsize,
//         child: CustomPaint(
//           painter: LinePainter(),
//         ),
//       ),
//     ),
//   );
// }

// Widget spiralBackground(Color color, double backsize) {
//   return Container(
//     width: backsize,
//     height: backsize,
//     decoration: BoxDecoration(
//       color: color,
//       shape: BoxShape.circle,
//     ),
//   );
// }

// class WarbeastSpiralPainter extends CustomPainter {
//   final List<int> damageGrid;

//   WarbeastSpiralPainter(this.damageGrid);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     final Paint backgroundPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final center = size.center(Offset.zero);
//     final double radiusStep = 10;

//     const double angleStep = 2 * pi / 36;

//     for (int b = 0; b < damageGrid.length; b++) {
//       int totalBoxes = damageGrid[b];
//       for (int i = 0; i < totalBoxes; i++) {
//         double radius = (i ~/ totalBoxes + 1) * radiusStep;
//         double angle = (i % totalBoxes) * angleStep;

//         Offset circleCenter = center + Offset(radius * cos(angle), radius * sin(angle));
//         double circleRadius = 5;
//         canvas.drawCircle(circleCenter, circleRadius, backgroundPaint);
//         canvas.drawCircle(circleCenter, circleRadius, paint);
//       }
//     }
//   }

  // @override
  // bool shouldRepaint(covariant CustomPainter oldDelegate) {
  //   return true;
  // }
// }