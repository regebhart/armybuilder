// import 'package:armybuilder/models/animi.dart';
// import 'package:armybuilder/pages/widgets/spiral.dart';
// import 'package:armybuilder/providers/appdata.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/grid.dart';
// import '../models/model.dart';
// import '../models/spells.dart';
// import '../providers/armylist.dart';
// import 'widgets/web.dart';

// class ModelStatPage extends StatefulWidget {
//   final bool deployed;
//   final Model model;
//   final int modelindex;
//   final int? listindex;
//   final int? listmodelindex;
//   const ModelStatPage({required this.deployed, required this.model, required this.modelindex, this.listindex, this.listmodelindex, super.key});

//   @override
//   State<ModelStatPage> createState() => _ModelStatPageState();
// }

// class _ModelStatPageState extends State<ModelStatPage> {
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);

//     final double width = MediaQuery.of(context).size.width * 0.95;
//     Color textcolor = Colors.grey[200]!;
//     const Color bordercolor = Colors.grey;
//     Model m = widget.model;
//     double fontsize = AppData().fontsize - 4;
//     int modelindex = widget.modelindex;

//     Widget keywords = const SizedBox();
//     Widget featname = const SizedBox();
//     Widget featdescription = const SizedBox();
//     Widget arcananame = const SizedBox();
//     Widget arcanadescription = const SizedBox();
//     List<Widget> abilities = [];
//     Widget ability = const SizedBox();
//     Widget stats = const SizedBox();
//     Widget hp = const SizedBox();
//     Widget custombar = const SizedBox();
//     List<Widget> weapons = [];
//     List<Widget> modularoptions = [];
//     List<Widget> spells = [];
//     List<Widget> animi = [];
//     Widget hpTitle = const SizedBox();
//     bool addhp = false;

//     if (m.keywords!.isNotEmpty) {
//       keywords = Padding(
//         padding: const EdgeInsets.only(bottom: 3),
//         child: RichText(
//           textAlign: TextAlign.left,
//           text: TextSpan(
//             text: 'KEYWORDS: ',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//             children: [
//               TextSpan(
//                 text: m.keywords.toString().replaceAll('[', '').replaceAll(']', ''),
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.normal,
//                   fontSize: fontsize,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     List<List<Widget>> statrow = [];

//     if (m.stats.spd != '-') statrow.add(statBlock('SPD', m.stats.spd!, bordercolor, textcolor));
//     if (m.stats.str != '-') statrow.add(statBlock('STR', m.stats.str!, bordercolor, textcolor));
//     if (m.stats.aat != '-') statrow.add(statBlock('AAT', m.stats.aat!, bordercolor, textcolor));
//     if (m.stats.mat != '-') statrow.add(statBlock('MAT', m.stats.mat!, bordercolor, textcolor));
//     if (m.stats.rat != '-') statrow.add(statBlock('RAT', m.stats.rat!, bordercolor, textcolor));
//     if (m.stats.def != '-') statrow.add(statBlock('DEF', m.stats.def!, bordercolor, textcolor));
//     if (m.stats.arm != '-') statrow.add(statBlock('ARM', m.stats.arm!, bordercolor, textcolor));
//     if (m.stats.arc != '-') statrow.add(statBlock('ARC', m.stats.arc!, bordercolor, textcolor));
//     if (m.stats.cmd != '-') statrow.add(statBlock('CMD', m.stats.cmd!, bordercolor, textcolor));
//     if (m.stats.ctrl != '-') statrow.add(statBlock('CTRL', m.stats.ctrl!, bordercolor, textcolor));
//     if (m.stats.fury != '-') statrow.add(statBlock('FURY', m.stats.fury!, bordercolor, textcolor));
//     if (m.stats.thr != '-') statrow.add(statBlock('THR', m.stats.thr!, bordercolor, textcolor));
//     if (m.stats.ess != '-') statrow.add(statBlock('ESS', m.stats.ess!, bordercolor, textcolor));
//     if (m.stats.base != '-') statrow.add(statBlock('Base', m.stats.base, bordercolor, textcolor));

//     TableRow toprow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][0]));
//     TableRow bottomrow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][1]));
//     stats = Table(
//       border: TableBorder.all(width: 1, color: bordercolor),
//       defaultColumnWidth: const IntrinsicColumnWidth(),
//       children: [toprow, bottomrow],
//     );

//     if (m.grid!.columns.isEmpty && m.spiral!.values.isEmpty && m.web!.values.isEmpty && m.hpbars!.isEmpty) {
//       //single model with more than 1 HP
//       if (m.stats.hp != '-' && m.stats.hp != '1') {
//         addhp = true;
//         List<Widget> hpbar = List.generate(
//           int.parse(m.stats.hp!),
//           (index) => hpbox(index, bordercolor, army, widget.listindex, widget.listmodelindex, null),
//         );

//         List<Widget> hpbarrow = List.generate(
//             (hpbar.length / 5).ceil(),
//             (index) => Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: hpbar.sublist(index * 5, (index * 5) + 5 > hpbar.length ? hpbar.length : (index * 5) + 5),
//                 ));
//         hp = Padding(
//           padding: const EdgeInsets.all(5),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 0),
//                 child: Text('${m.modelname} HP: ${m.stats.hp!}'),
//               ),
//               Wrap(
//                 alignment: WrapAlignment.start,
//                 runSpacing: 0,
//                 direction: Axis.horizontal,
//                 children: hpbarrow,
//               ),
//             ],
//           ),
//         );
//       }
//     }

//     if (m.hpbars!.isNotEmpty) {
//       List<Widget> bars = [];
//       List<Widget> hpbar = [];
//       int hpbarnum = 0;
//       addhp = true;
//       int barcount = 0;
//       if (widget.deployed) {
//         barcount = army.deployedLists[widget.listindex!].barcount;
//       } else {
//         barcount = m.hpbars!.length;
//       }
//       for (int b = 0; b < barcount; b++) {
//         var hp = m.hpbars![b];
//         if (hp.hp != '1') {
//           hpbar = List.generate(
//             int.parse(hp.hp),
//             (index) => hpbox(
//               index,
//               bordercolor,
//               army,
//               widget.listindex,
//               widget.listmodelindex,
//               hpbarnum,
//             ),
//           );

//           if (bars.isEmpty) {
//             bars.add(const SizedBox(height: 3));
//           }
//           bars.add(
//             Padding(
//               padding: const EdgeInsets.only(top: 0),
//               child: Text('${hp.name} HP: ${hp.hp}'),
//             ),
//           );
//           bars.add(
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: hpbar,
//             ),
//           );
//         }
//         hpbarnum++;
//       }

//       hp = Padding(
//         padding: const EdgeInsets.only(left: 5, bottom: 5),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: bars,
//         ),
//       );
//     }

//     if (m.custombars!.isNotEmpty) {
//       List<Widget> bars = [];
//       List<Widget> bar = [];
//       int barnum = 0;
//       int custombarcount = 0;
//       if (widget.deployed) {
//         custombarcount = army.deployedLists[widget.listindex!].barcount;
//       } else {
//         custombarcount = m.custombars!.length;
//       }
//       for (int b = 0; b < custombarcount; b++) {
//         var cb = m.custombars![b];
//         bar = List.generate(
//           int.parse(cb.totalcount),
//           (index) => custombarbox(
//             index,
//             bordercolor,
//             army,
//             widget.listindex!,
//             widget.listmodelindex!,
//             barnum,
//           ),
//         );

//         if (bars.isEmpty) {
//           bars.add(const SizedBox(height: 3));
//         }
//         bars.add(
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 0, right: 5),
//                 child: Text('${cb.name}:'),
//               ),
//               ...bar,
//             ],
//           ),
//         );
//         barnum++;
//       }

//       custombar = Padding(
//         padding: const EdgeInsets.only(left: 5, bottom: 5),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: bars,
//         ),
//       );
//     }

//     if (m.grid!.columns.isNotEmpty) {
//       //generate grid
//       List<Widget> grid = [];
//       int col = 0;
//       int max = 5;
//       addhp = true;
//       hpTitle = Padding(
//         padding: const EdgeInsets.only(bottom: 2),
//         child: Text('GRID:',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             )),
//       );

//       if (m.grid!.columns.length > 6) {
//         max = 11;
//       }

//       for (var c = 0; c <= max; c++) {
//         col++;
//         if (col > 6) {
//           col = 1;
//           grid.add(const SizedBox(width: 5));
//         }
//         List<Widget> column = [];
//         column.add(
//           Text(col.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: textcolor,
//                 fontSize: fontsize,
//               )),
//         );
//         for (int rownum = 0; rownum < m.grid!.columns[c].boxes.length; rownum++) {
//           GridBox r = m.grid!.columns[c].boxes[rownum];
//           String system = r.system;
//           Color boxborder = bordercolor;
//           Color fillColor;
//           bool filled = false;
//           if (army.hptracking.isNotEmpty) {
//             filled = army.hptracking[widget.listindex!][widget.listmodelindex!]['grid'][c][rownum];
//           }
//           if (r.system == '-') {
//             fillColor = Colors.black;
//           } else {
//             fillColor = Colors.white;
//           }
//           if (r.system == '-' || r.system == 'x') {
//             system = '';
//           }
//           if (widget.deployed && filled) {
//             fillColor = Colors.red;
//             // boxborder = fillColor;
//           }

//           Widget gridBox = SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: GestureDetector(
//               onTap: () {
//                 if (r.system != '-' && widget.listindex != null) {
//                   army.adjustGridDamage(widget.listindex!, widget.listmodelindex!, c, rownum);
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(3),
//                 child: Container(
//                   decoration: BoxDecoration(border: Border.all(width: 5, color: boxborder)),
//                   child: SizedBox.square(
//                     dimension: 17,
//                     child: Container(
//                       color: fillColor,
//                       child: Center(
//                           child: Text(
//                         system,
//                         style: TextStyle(
//                           color: Colors.grey.shade800,
//                           fontSize: fontsize,
//                         ),
//                       )),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//           column.add(gridBox);
//         }
//         grid.add(Column(
//           mainAxisSize: MainAxisSize.min,
//           children: column,
//         ));
//       }
//       hp = Padding(
//         padding: const EdgeInsets.all(5),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: grid,
//         ),
//       );
//     }

//     if (m.spiral!.values.isNotEmpty) {
//       addhp = true;
//       hpTitle = Padding(
//         padding: const EdgeInsets.only(bottom: 2),
//         child: Text('SPIRAL:',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             )),
//       );
//       List<int> spiralvalues = [];

//       for (var s in m.spiral!.values) {
//         spiralvalues.add(int.parse(s));
//       }

//       hp = spiral(spiralvalues, modelindex, army, widget.listindex, widget.listmodelindex);
//     }

//     if (m.web!.values.isNotEmpty) {
//       addhp = true;
//       hpTitle = Padding(
//         padding: const EdgeInsets.only(bottom: 2),
//         child: Text('WEB:',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             )),
//       );

//       int outer = int.parse(m.web!.values[0]);
//       int middle = int.parse(m.web!.values[1]);
//       int inner = int.parse(m.web!.values[2]);
//       hp = web(outer, middle, inner, army, widget.listindex, widget.listmodelindex);
//     }

//     if (m.arcana!.name != '' && m.arcana!.description != '') {
//       arcananame = Container(
//         width: width,
//         decoration: const BoxDecoration(
//             border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           top: BorderSide(width: 1, color: bordercolor),
//         )),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//           child: Text(
//             'FEAT: ${m.arcana!.name}',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//           ),
//         ),
//       );

//       arcanadescription = Container(
//         width: width,
//         padding: const EdgeInsets.only(bottom: 3),
//         decoration: const BoxDecoration(
//             border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           bottom: BorderSide(width: 1, color: bordercolor),
//         )),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//           child: RichText(
//             text: TextSpan(
//               text: m.arcana!.description,
//               style: TextStyle(
//                 color: textcolor,
//                 fontWeight: FontWeight.normal,
//                 fontSize: fontsize,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     if (m.feat!.name != '' && m.feat!.description != '') {
//       featname = Container(
//         width: width,
//         decoration: const BoxDecoration(
//             border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           top: BorderSide(width: 1, color: bordercolor),
//         )),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//           child: Text(
//             'FEAT: ${m.feat!.name}',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//           ),
//         ),
//       );

//       featdescription = Container(
//         width: width,
//         padding: const EdgeInsets.only(bottom: 3),
//         decoration: const BoxDecoration(
//             border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           bottom: BorderSide(width: 1, color: bordercolor),
//         )),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//           child: RichText(
//             text: TextSpan(
//               text: m.feat!.description,
//               style: TextStyle(
//                 color: textcolor,
//                 fontWeight: FontWeight.normal,
//                 fontSize: fontsize,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     if (m.characterabilities!.isNotEmpty) {
//       for (var ab in m.characterabilities!) {
//         if (abilities.isEmpty) {
//           abilities.add(Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//             child: Text('ABILITIES:',
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//           ));
//         }
//         ability = Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//           child: RichText(
//             textAlign: TextAlign.left,
//             text: TextSpan(
//               text: ab.name,
//               style: TextStyle(
//                 color: textcolor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: fontsize,
//               ),
//               children: [
//                 TextSpan(
//                   text: ' - ${ab.description}',
//                   style: TextStyle(
//                     color: textcolor,
//                     fontWeight: FontWeight.normal,
//                     fontSize: fontsize,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//         abilities.add(ability);
//       }
//     }

//     if (m.nestedabilities!.isNotEmpty) {
//       for (var n in m.nestedabilities!) {
//         if (n.topability.name != '' && n.subabilities.isNotEmpty) {
//           ability = Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//             child: RichText(
//               textAlign: TextAlign.left,
//               text: TextSpan(
//                 text: n.topability.name,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: n.topability.description == '' ? '' : ' - ${n.topability.description}',
//                     style: TextStyle(
//                       color: textcolor,
//                       fontWeight: FontWeight.normal,
//                       fontSize: fontsize,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           abilities.add(ability);
//         }

//         for (var ab in n.subabilities) {
//           ability = Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1.5),
//             child: RichText(
//               textAlign: TextAlign.left,
//               text: TextSpan(
//                 text: ab.name,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: ' - ${ab.description}',
//                     style: TextStyle(
//                       color: textcolor,
//                       fontWeight: FontWeight.normal,
//                       fontSize: fontsize,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           abilities.add(ability);
//         }
//       }
//     }

//     if (m.execution!.name != '') {
//       ability = Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         child: RichText(
//           textAlign: TextAlign.left,
//           text: TextSpan(
//             text: 'EXECUTION: ${m.execution!.name}',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//             children: [
//               TextSpan(
//                 text: ' - ${m.execution!.description}',
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.normal,
//                   fontSize: fontsize,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//       abilities.add(ability);
//     }

//     if (m.weapons!.isNotEmpty) {
//       if (weapons.isEmpty) {
//         weapons.add(Container(
//           width: width,
//           decoration: const BoxDecoration(
//             border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//             child: Text('WEAPONS:',
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//           ),
//         ));
//       }
//       List<String> fields = ['none', 'left', 'right'];
//       for (var f in fields) {
//         List<Widget> thisfield = [];
//         if (f != 'none') {
//           thisfield.add(Container(
//               width: width,
//               padding: const EdgeInsets.only(left: 5),
//               decoration: const BoxDecoration(
//                 border: Border(
//                   left: BorderSide(width: 1, color: bordercolor),
//                   right: BorderSide(width: 1, color: bordercolor),
//                 ),
//               ),
//               child: Text('${f.toUpperCase()} FIELD OF FIRE:')));
//         }
//         for (var w in m.weapons!) {
//           List<Widget> weaponabilities = [];
//           Widget weaponstats = const SizedBox();
//           String count = '';
//           String system = '';

//           if (w.fieldoffire!.toString().toLowerCase() == f) {
//             String type = '';
//             if (w.count! != '' && w.count != '1') {
//               count = ' (x${w.count!})';
//             }
//             if (w.system != '') {
//               system = ' (${w.system})';
//             }
//             switch (w.type.toLowerCase()) {
//               case 'melee':
//                 type = 'Melee Weapon';
//                 weaponstats = Table(
//                   border: TableBorder.all(
//                     width: 1,
//                     color: bordercolor,
//                   ),
//                   columnWidths: const {
//                     0: FlexColumnWidth(1),
//                     1: FlexColumnWidth(1),
//                     2: FlexColumnWidth(1),
//                   },
//                   children: [
//                     TableRow(
//                       children: [
//                         Text("RNG",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("POW",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("P+S",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         Text(w.rng,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         Text(w.pow,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         w.pow == '*'
//                             ? Text(w.pow, textAlign: TextAlign.center)
//                             : Text((int.parse(m.stats.str!) + int.parse(w.pow)).toString(),
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: textcolor,
//                                   fontSize: fontsize,
//                                 )),
//                       ],
//                     ),
//                   ],
//                 );
//                 break;
//               case 'ranged':
//                 type = 'Ranged Weapon';

//                 weaponstats = Table(
//                   border: TableBorder.all(
//                     width: 1,
//                     color: bordercolor,
//                   ),
//                   columnWidths: const {
//                     0: FlexColumnWidth(1),
//                     1: FlexColumnWidth(1),
//                     2: FlexColumnWidth(1),
//                     3: FlexColumnWidth(1),
//                   },
//                   children: [
//                     TableRow(
//                       children: [
//                         Text("RNG",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("ROF",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("AOE",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("POW",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         Text(w.rng,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         Text(w.rof!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         Text(w.aoe!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         Text(
//                           w.pow,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: textcolor,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//                 break;
//               case 'mount':
//                 type = 'Mount';
//                 weaponstats = Table(
//                   border: TableBorder.all(
//                     width: 1,
//                     color: bordercolor,
//                   ),
//                   columnWidths: const {
//                     0: FlexColumnWidth(1),
//                     1: FlexColumnWidth(1),
//                   },
//                   children: [
//                     TableRow(
//                       children: [
//                         Text("RNG",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                         Text("POW",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             )),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         Text(w.rng,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                         Text(w.pow,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontSize: fontsize,
//                             )),
//                       ],
//                     ),
//                   ],
//                 );
//                 break;
//             }

//             if (w.abilities!.isNotEmpty) {
//               for (var ab in w.abilities!) {
//                 ability = Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 1.0),
//                   child: RichText(
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                       text: ab.name,
//                       style: TextStyle(
//                         color: textcolor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: ' - ${ab.description}',
//                           style: TextStyle(
//                             color: textcolor,
//                             fontWeight: FontWeight.normal,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//                 weaponabilities.add(ability);
//               }
//             }

//             if (w.presetabilities!.isNotEmpty) {
//               ability = Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 3),
//                 child: Text(
//                   w.presetabilities.toString().replaceAll('[', '').replaceAll(']', ''),
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                     color: textcolor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: fontsize,
//                   ),
//                 ),
//               );
//               weaponabilities.insert(0, ability);
//             }

//             if (w.nestedabilities!.isNotEmpty) {
//               for (var n in w.nestedabilities!) {
//                 if (n.topability.name != '' && n.subabilities.isNotEmpty) {
//                   ability = Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 3),
//                     child: RichText(
//                       textAlign: TextAlign.left,
//                       text: TextSpan(
//                         text: n.topability.name,
//                         style: TextStyle(
//                           color: textcolor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: fontsize,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: ' - ${n.topability.description}',
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.normal,
//                               fontSize: fontsize,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                   weaponabilities.add(ability);

//                   for (var ab in n.subabilities) {
//                     ability = Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                       child: RichText(
//                         textAlign: TextAlign.left,
//                         text: TextSpan(
//                           text: '• ${ab.name}',
//                           style: TextStyle(
//                             color: textcolor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontsize,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' - ${ab.description}',
//                               style: TextStyle(
//                                 color: textcolor,
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: fontsize,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                     weaponabilities.add(ability);
//                   }
//                 }
//               }
//             }

//             Widget damageType = const SizedBox();
//             if (w.damagetype!.isNotEmpty) {
//               String d = w.damagetype!.toString().toString().replaceAll('[', '').replaceAll(']', '');
//               if (d != '') {
//                 damageType = Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   child: RichText(
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                         text: 'Damage Type: ',
//                         style: TextStyle(
//                           color: textcolor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: fontsize,
//                         ),
//                         children: [
//                           TextSpan(
//                               text: d,
//                               style: TextStyle(
//                                 color: textcolor,
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: fontsize,
//                               )),
//                         ]),
//                   ),
//                 );
//               }
//             }

//             Widget currentWeapon = Container(
//               width: width,
//               padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
//               decoration: const BoxDecoration(
//                 border: Border(
//                   left: BorderSide(width: 1, color: bordercolor),
//                   right: BorderSide(width: 1, color: bordercolor),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       // width: width - 25,
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 1, color: bordercolor),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 SizedBox(
//                                   width: 115,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         '${w.name.toString().toUpperCase()}$count$system',
//                                         style: TextStyle(
//                                           color: textcolor,
//                                           fontSize: fontsize,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         type,
//                                         style: TextStyle(
//                                           color: textcolor,
//                                           fontSize: fontsize,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 SizedBox(
//                                   width: 200,
//                                   child: weaponstats,
//                                 ),
//                               ],
//                             ),
//                             damageType,
//                             ...weaponabilities,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//             thisfield.add(currentWeapon);
//           }
//         }
//         if (thisfield.length > 1) {
//           if (weapons.isNotEmpty) {
//             weapons.add(
//               Container(
//                 width: width,
//                 height: 2,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 1, color: bordercolor),
//                     right: BorderSide(width: 1, color: bordercolor),
//                   ),
//                 ),
//               ),
//             );
//           }
//           weapons.addAll(thisfield);
//         } else {
//           if (f == 'none' && thisfield.isNotEmpty) {
//             weapons.addAll(thisfield);
//           }
//         }
//       }
//     }

//     if (weapons.isNotEmpty) {
//       weapons.add(
//         Container(
//             height: 2,
//             width: width,
//             decoration: const BoxDecoration(
//                 border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//               bottom: BorderSide(width: 1, color: bordercolor),
//             ))),
//       );
//     }

//     if (m.spells!.isNotEmpty) {
//       for (var sp in m.spells!) {
//         if (spells.isEmpty) {
//           spells.add(spellHeaders(width, fontsize, bordercolor, textcolor, false));
//         }
//         spells.add(spellStats(sp, width, fontsize, bordercolor, textcolor, false));
//         spells.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, false));
//       }
//     }

//     if (m.animi!.isNotEmpty) {
//       for (var sp in m.animi!) {
//         if (animi.isEmpty) {
//           animi.add(spellHeaders(width, fontsize, bordercolor, textcolor, false));
//         }
//         Spell thisSpell = Spell(name: sp.name, cost: sp.cost, rng: sp.rng, off: sp.off, description: sp.description);
//         animi.add(spellStats(thisSpell, width, fontsize, bordercolor, textcolor, false));
//         animi.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, false));
//       }
//     }

//     if (m.modularoptions!.isNotEmpty && !widget.deployed) {
//       ///////////////////loop through groups      ///
//       for (var mo in m.modularoptions!) {
//         if (modularoptions.isEmpty) {
//           modularoptions.add(const SizedBox(
//             width: 1000,
//             height: 10,
//           ));
//           modularoptions.add(
//             SizedBox(
//               width: 1000,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 child: Text(
//                   'MODULAR OPTIONS:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: fontsize,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//         modularoptions.add(Container(
//             width: 1000,
//             decoration: BoxDecoration(
//               border: Border.all(width: 2, color: bordercolor),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//               child: Text('${mo.groupname} Options',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: fontsize + 2,
//                   )),
//             )));
//         ///////////////////////////Loop through individual options
//         for (var op in mo.options!) {
//           List<Widget> modularweapons = [];
//           List<Widget> statmods = [];

//           modularoptions.add(Container(
//             width: 1000,
//             decoration: const BoxDecoration(
//               border: Border(
//                 left: BorderSide(width: 2, color: bordercolor),
//                 right: BorderSide(width: 2, color: bordercolor),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(op.name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize + 2,
//                       )),
//                   Text(
//                     'COST: ${op.cost}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: fontsize + 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ));

//           if (op.keywords!.isNotEmpty) {
//             String keywords = op.keywords!.join(', ');
//             modularoptions.add(Container(
//                 width: 1000,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Row(
//                     children: [
//                       Text(
//                         'KEYWORDS: ',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: fontsize,
//                         ),
//                       ),
//                       Text(
//                         keywords,
//                         style: TextStyle(
//                           fontSize: fontsize,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )));
//           }

//           if (op.abilities!.isNotEmpty || op.nestedabilities!.isNotEmpty) {
//             // abilities = [];
//             modularoptions.add(Container(
//                 width: 1000,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Text('ABILITIES:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       )),
//                 )));
//           }
//           for (var ab in op.abilities!) {
//             ability = Container(
//               width: 1000,
//               decoration: const BoxDecoration(
//                 border: Border(
//                   left: BorderSide(width: 2, color: bordercolor),
//                   right: BorderSide(width: 2, color: bordercolor),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                 child: RichText(
//                   textAlign: TextAlign.left,
//                   text: TextSpan(
//                     text: ab.name,
//                     style: TextStyle(
//                       color: textcolor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: fontsize,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: ' - ${ab.description}',
//                         style: TextStyle(
//                           color: textcolor,
//                           fontWeight: FontWeight.normal,
//                           fontSize: fontsize,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//             modularoptions.add(ability);
//           }

//           if (m.nestedabilities!.isNotEmpty) {
//             for (var n in op.nestedabilities!) {
//               if (n.topability.name != '' && n.subabilities.isNotEmpty) {
//                 ability = Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                   child: RichText(
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                       text: n.topability.name,
//                       style: TextStyle(
//                         color: textcolor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: n.topability.description == '' ? '' : ' - ${n.topability.description}',
//                           style: TextStyle(
//                             color: textcolor,
//                             fontWeight: FontWeight.normal,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//                 modularoptions.add(ability);
//               }

//               for (var ab in n.subabilities) {
//                 ability = Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1.5),
//                   child: RichText(
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                       text: ab.name,
//                       style: TextStyle(
//                         color: textcolor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: ' - ${ab.description}',
//                           style: TextStyle(
//                             color: textcolor,
//                             fontWeight: FontWeight.normal,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//                 modularoptions.add(ability);
//               }
//             }
//           }

//           if (op.weapons!.isNotEmpty) {
//             if (modularweapons.isEmpty) {
//               modularweapons.add(Container(
//                 width: width,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                   child: Text('WEAPONS:',
//                       style: TextStyle(
//                         color: textcolor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       )),
//                 ),
//               ));
//             }
//             List<String> fields = ['none', 'left', 'right'];
//             for (var f in fields) {
//               List<Widget> thisfield = [];
//               if (f != 'none') {
//                 thisfield.add(Container(
//                     width: width,
//                     padding: const EdgeInsets.only(left: 5),
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         left: BorderSide(width: 2, color: bordercolor),
//                         right: BorderSide(width: 2, color: bordercolor),
//                       ),
//                     ),
//                     child: Text('${f.toUpperCase()} FIELD OF FIRE:')));
//               }
//               for (var w in op.weapons!) {
//                 List<Widget> weaponabilities = [];
//                 Widget weaponstats = const SizedBox();
//                 String count = '';
//                 String system = '';

//                 if (w.fieldoffire!.toString().toLowerCase() == f) {
//                   String type = '';
//                   if (w.count! != '' && w.count != '1') {
//                     count = ' (x${w.count!})';
//                   }
//                   if (w.system != '') {
//                     system = ' (${w.system})';
//                   }
//                   switch (w.type.toLowerCase()) {
//                     case 'melee':
//                       type = 'Melee Weapon';
//                       weaponstats = Table(
//                         border: TableBorder.all(
//                           width: 1,
//                           color: bordercolor,
//                         ),
//                         columnWidths: const {
//                           0: FlexColumnWidth(1),
//                           1: FlexColumnWidth(1),
//                           2: FlexColumnWidth(1),
//                         },
//                         children: [
//                           TableRow(
//                             children: [
//                               Text("RNG",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("POW",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("P+S",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                             ],
//                           ),
//                           TableRow(
//                             children: [
//                               Text(w.rng,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               Text(w.pow,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               w.pow == '*'
//                                   ? Text(w.pow, textAlign: TextAlign.center)
//                                   : Text((int.parse(m.stats.str!) + int.parse(w.pow)).toString(),
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: textcolor,
//                                         fontSize: fontsize,
//                                       )),
//                             ],
//                           ),
//                         ],
//                       );
//                       break;
//                     case 'ranged':
//                       type = 'Ranged Weapon';

//                       weaponstats = Table(
//                         border: TableBorder.all(
//                           width: 1,
//                           color: bordercolor,
//                         ),
//                         columnWidths: const {
//                           0: FlexColumnWidth(1),
//                           1: FlexColumnWidth(1),
//                           2: FlexColumnWidth(1),
//                           3: FlexColumnWidth(1),
//                         },
//                         children: [
//                           TableRow(
//                             children: [
//                               Text("RNG",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("ROF",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("AOE",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("POW",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                             ],
//                           ),
//                           TableRow(
//                             children: [
//                               Text(w.rng,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               Text(w.rof!,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               Text(w.aoe!,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               Text(
//                                 w.pow,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: textcolor,
//                                   fontSize: fontsize,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                       break;
//                     case 'mount':
//                       type = 'Mount';
//                       weaponstats = Table(
//                         border: TableBorder.all(
//                           width: 1,
//                           color: bordercolor,
//                         ),
//                         columnWidths: const {
//                           0: FlexColumnWidth(1),
//                           1: FlexColumnWidth(1),
//                         },
//                         children: [
//                           TableRow(
//                             children: [
//                               Text("RNG",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                               Text("POW",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: fontsize,
//                                   )),
//                             ],
//                           ),
//                           TableRow(
//                             children: [
//                               Text(w.rng,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                               Text(w.pow,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontSize: fontsize,
//                                   )),
//                             ],
//                           ),
//                         ],
//                       );
//                       break;
//                   }

//                   if (w.abilities!.isNotEmpty) {
//                     for (var ab in w.abilities!) {
//                       ability = Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 3),
//                         child: RichText(
//                           textAlign: TextAlign.left,
//                           text: TextSpan(
//                             text: ab.name,
//                             style: TextStyle(
//                               color: textcolor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: fontsize,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: ' - ${ab.description}',
//                                 style: TextStyle(
//                                   color: textcolor,
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: fontsize,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                       weaponabilities.add(ability);
//                     }
//                   }

//                   if (w.presetabilities!.isNotEmpty) {
//                     ability = Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 3),
//                       child: Text(
//                         w.presetabilities.toString().replaceAll('[', '').replaceAll(']', ''),
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                           color: textcolor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: fontsize,
//                         ),
//                       ),
//                     );
//                     weaponabilities.insert(0, ability);
//                   }

//                   if (w.nestedabilities!.isNotEmpty) {
//                     for (var n in w.nestedabilities!) {
//                       if (n.topability.name != '' && n.subabilities.isNotEmpty) {
//                         ability = Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 3),
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                               text: n.topability.name,
//                               style: TextStyle(
//                                 color: textcolor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: fontsize,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: ' - ${n.topability.description}',
//                                   style: TextStyle(
//                                     color: textcolor,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: fontsize,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                         weaponabilities.add(ability);

//                         for (var ab in n.subabilities) {
//                           ability = Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                             child: RichText(
//                               textAlign: TextAlign.left,
//                               text: TextSpan(
//                                 text: '• ${ab.name}',
//                                 style: TextStyle(
//                                   color: textcolor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: fontsize,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: ' - ${ab.description}',
//                                     style: TextStyle(
//                                       color: textcolor,
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: fontsize,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                           weaponabilities.add(ability);
//                         }
//                       }
//                     }
//                   }

//                   Widget damageType = const SizedBox();
//                   if (w.damagetype!.isNotEmpty) {
//                     String d = w.damagetype!.toString().toString().replaceAll('[', '').replaceAll(']', '');
//                     if (d != '') {
//                       damageType = Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 3),
//                         child: RichText(
//                           textAlign: TextAlign.left,
//                           text: TextSpan(
//                               text: 'Damage Type: ',
//                               style: TextStyle(
//                                 color: textcolor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: fontsize,
//                               ),
//                               children: [
//                                 TextSpan(
//                                     text: d,
//                                     style: TextStyle(
//                                       color: textcolor,
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: fontsize,
//                                     )),
//                               ]),
//                         ),
//                       );
//                     }
//                   }

//                   Widget currentWeapon = Container(
//                     width: width,
//                     padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         left: BorderSide(width: 2, color: bordercolor),
//                         right: BorderSide(width: 2, color: bordercolor),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             // width: width - 25,
//                             decoration: BoxDecoration(
//                               border: Border.all(width: 1, color: bordercolor),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: [
//                                       SizedBox(
//                                         width: 115,
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Text(
//                                               '${w.name.toString().toUpperCase()}$count$system',
//                                               style: TextStyle(
//                                                 color: textcolor,
//                                                 fontSize: fontsize,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               type,
//                                               style: TextStyle(
//                                                 color: textcolor,
//                                                 fontSize: fontsize,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       SizedBox(
//                                         width: 200,
//                                         child: weaponstats,
//                                       ),
//                                     ],
//                                   ),
//                                   damageType,
//                                   ...weaponabilities,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                   thisfield.add(currentWeapon);
//                 }
//               }
//               if (thisfield.length > 1) {
//                 if (modularweapons.isNotEmpty) {
//                   modularweapons.add(
//                     Container(
//                       width: width,
//                       height: 2,
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           left: BorderSide(width: 2, color: bordercolor),
//                           right: BorderSide(width: 2, color: bordercolor),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 modularweapons.addAll(thisfield);
//               } else {
//                 if (f == 'none' && thisfield.isNotEmpty) {
//                   modularweapons.addAll(thisfield);
//                 }
//               }
//             }
//           }

//           if (modularweapons.isNotEmpty) {
//             modularweapons.add(
//               Container(
//                   height: 2,
//                   width: width,
//                   decoration: const BoxDecoration(
//                       border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ))),
//             );
//             modularoptions.addAll(modularweapons);
//           }

//           if (op.animi!.isNotEmpty) {
//             modularoptions.add(Container(
//                 width: 1000,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Text('ANIMUS:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontsize,
//                       )),
//                 )));
//             for (var sp in op.animi!) {
//               if (animi.isEmpty) {
//                 modularoptions.add(spellHeaders(width, fontsize, bordercolor, textcolor, true));
//               }
//               Animus thisSpell = Animus(name: sp.name, cost: sp.cost, rng: sp.rng, off: sp.off, description: sp.description);
//               modularoptions.add(animusStats(thisSpell, width, fontsize, bordercolor, textcolor, true));
//               modularoptions.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, true));
//             }
//           }

//           List<Map<String, String>> allstats = [
//             {'stat': 'SPD', 'value': op.statmods!.spd!},
//             {'stat': 'STR', 'value': op.statmods!.str!},
//             {'stat': 'AAT', 'value': op.statmods!.aat!},
//             {'stat': 'MAT', 'value': op.statmods!.mat!},
//             {'stat': 'RAT', 'value': op.statmods!.rat!},
//             {'stat': 'DEF', 'value': op.statmods!.def!},
//             {'stat': 'ARM', 'value': op.statmods!.arm!},
//             {'stat': 'ARC', 'value': op.statmods!.arc!},
//             {'stat': 'CMD', 'value': op.statmods!.cmd!},
//             {'stat': 'CTRL', 'value': op.statmods!.ctrl!},
//             {'stat': 'FURY', 'value': op.statmods!.fury!},
//             {'stat': 'THR', 'value': op.statmods!.thr!},
//             {'stat': 'ESS', 'value': op.statmods!.ess!},
//           ];
//           double statwidth = 40;

//           for (var s in allstats) {
//             if (s['value'] != '0' && s['value'] != '-') {
//               if (int.tryParse(s['value']!) != null) {
//                 int thisstat = int.parse(s['value']!);
//                 String statstr = s['value']!;
//                 if (thisstat > 0) statstr = '+$statstr';
//                 statmods.add(Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: statwidth,
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 1, color: bordercolor),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(1),
//                         child: Text(
//                           s['stat']!,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: statwidth,
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 1, color: bordercolor),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(1),
//                         child: Text(
//                           statstr,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: fontsize,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ));
//               }
//             }
//           }

//           if (statmods.isNotEmpty) {
//             modularoptions.add(
//               Container(
//                 width: 1000,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Text(
//                     'STAT ADJUSTMENTS:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: fontsize,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//             modularoptions.add(
//               Container(
//                 width: 1000,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     left: BorderSide(width: 2, color: bordercolor),
//                     right: BorderSide(width: 2, color: bordercolor),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: statmods,
//                   ),
//                 ),
//               ),
//             );
//           }
//           modularoptions.add(
//             Container(
//               width: 1000,
//               height: 5,
//               decoration: const BoxDecoration(
//                 border: Border(
//                   left: BorderSide(width: 2, color: bordercolor),
//                   right: BorderSide(width: 2, color: bordercolor),
//                   bottom: BorderSide(width: 2, color: bordercolor),
//                 ),
//               ),
//             ),
//           );
//         }
//         modularoptions.add(const SizedBox(
//           height: 8,
//         ));
//       }
//     }

//     List<Widget> modeldoc = [];

//     modeldoc.add(Container(
//       width: width,
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(width: 1, color: bordercolor),
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: Padding(
//           //model name
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Text(m.modelname,
//               style: TextStyle(
//                 color: textcolor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: fontsize,
//               ))),
//     ));

//     modeldoc.add(Container(
//       //side borders and title
//       width: width,
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
//           child: Text(m.title,
//               style: TextStyle(
//                 color: textcolor,
//                 fontWeight: FontWeight.normal,
//                 fontSize: fontsize,
//               ))),
//     ));

//     modeldoc.add(Container(
//       width: width,
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         child: RichText(
//           textAlign: TextAlign.left,
//           text: TextSpan(
//             text: 'MODEL TYPE',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//             children: [
//               TextSpan(
//                 text: ': ${m.modeltype}'.toString().toString().replaceAll('[', '').replaceAll(']', ''),
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.normal,
//                   fontSize: fontsize,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));

//     modeldoc.add(Container(
//       width: width,
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           bottom: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         child: keywords,
//       ),
//     ));

//     if (addhp) {
//       modeldoc.add(Container(
//         width: width,
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         decoration: const BoxDecoration(
//           border: Border(
//             left: BorderSide(width: 1, color: bordercolor),
//             right: BorderSide(width: 1, color: bordercolor),
//           ),
//         ),
//         child: hpTitle,
//       ));

//       modeldoc.add(Container(
//         width: width,
//         padding: const EdgeInsets.only(right: 5, bottom: 10),
//         decoration: const BoxDecoration(
//           border: Border(
//             left: BorderSide(width: 1, color: bordercolor),
//             right: BorderSide(width: 1, color: bordercolor),
//             bottom: BorderSide(width: 1, color: bordercolor),
//           ),
//         ),
//         child: hp,
//       ));
//     }

//     modeldoc.add(Container(
//       width: width,
//       padding: const EdgeInsets.only(right: 5, bottom: 10),
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//           bottom: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: custombar,
//     ));

//     modeldoc.add(Container(
//       width: width,
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1, color: bordercolor),
//           right: BorderSide(width: 1, color: bordercolor),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         child: Text('STATISTICS:',
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             )),
//       ),
//     ));

//     modeldoc.add(
//       Container(
//         width: width,
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//         decoration: const BoxDecoration(
//           border: Border(
//             left: BorderSide(width: 1, color: bordercolor),
//             right: BorderSide(width: 1, color: bordercolor),
//             bottom: BorderSide(width: 1, color: bordercolor),
//           ),
//         ),
//         child: stats,
//       ),
//     );

//     modeldoc.add(featname);
//     modeldoc.add(featdescription);

//     modeldoc.add(arcananame);
//     modeldoc.add(arcanadescription);

//     for (var a = 0; a < abilities.length; a++) {
//       if (a < abilities.length - 1) {
//         modeldoc.add(Container(
//           width: width,
//           decoration: const BoxDecoration(
//             border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//             ),
//           ),
//           child: abilities[a],
//         ));
//       } else {
//         modeldoc.add(Container(
//           width: width,
//           decoration: const BoxDecoration(
//             border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//               bottom: BorderSide(width: 1, color: bordercolor),
//             ),
//           ),
//           child: abilities[a],
//         ));
//       }
//     }

//     modeldoc.addAll(weapons);

//     if (spells.isNotEmpty) {
//       modeldoc.add(
//         Container(
//           width: width,
//           decoration: const BoxDecoration(
//             border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//           child: Text(
//             "SPELLS:",
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//           ),
//         ),
//       );

//       for (var a in spells) {
//         modeldoc.add(a);
//       }
//       modeldoc.add(
//         Container(
//             width: width,
//             decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(width: 1, color: bordercolor)),
//             )),
//       );
//     }

//     if (animi.isNotEmpty) {
//       modeldoc.add(
//         Container(
//           width: width,
//           decoration: const BoxDecoration(
//             border: Border(
//               left: BorderSide(width: 1, color: bordercolor),
//               right: BorderSide(width: 1, color: bordercolor),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//           child: Text(
//             "ANIMUS:",
//             style: TextStyle(
//               color: textcolor,
//               fontWeight: FontWeight.bold,
//               fontSize: fontsize,
//             ),
//           ),
//         ),
//       );

//       modeldoc.addAll(animi);

//       modeldoc.add(
//         Container(
//             width: width,
//             decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(width: 1, color: bordercolor)),
//             )),
//       );
//     }

//     if (modularoptions.isNotEmpty) {
//       modeldoc.add(
//         Column(children: modularoptions),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.max,
//       children: modeldoc,
//     );
//   }
// }

// List<Widget> statBlock(String stat, String value, Color bordercolor, Color textcolor) {
//   // double width = 40;
//   // if (stat == 'Base') width = 60;
//   return [
//     Text(
//       stat, //STAT HEADER
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         color: textcolor,
//         fontWeight: FontWeight.bold,
//         fontSize: AppData().fontsize - 4,
//       ),
//     ),
//     Padding(
//       padding: const EdgeInsets.all(1),
//       child: Text(
//         value,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: textcolor,
//           fontSize: AppData().fontsize - 4,
//         ),
//       ),
//     )
//   ];
// }

// Widget spellHeaders(double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
//   return Container(
//     width: width,
//     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//     decoration: BoxDecoration(
//       border: Border(
//         left: BorderSide(width: option ? 2 : 1, color: bordercolor),
//         right: BorderSide(width: option ? 2 : 1, color: bordercolor),
//       ),
//     ),
//     child: Table(
//       columnWidths: const {
//         0: FlexColumnWidth(2),
//         1: FlexColumnWidth(1),
//         2: FlexColumnWidth(1),
//         3: FlexColumnWidth(1),
//         4: FlexColumnWidth(1),
//         5: FlexColumnWidth(1),
//         6: FlexColumnWidth(1),
//       },
//       children: [
//         TableRow(
//           children: [
//             Text('',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("COST",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("RNG",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("AOE",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("POW",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("DUR",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text("OFF",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget spellStats(Spell sp, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
//   String cost = sp.cost;
//   String rng = sp.rng;
//   String aoe = sp.aoe ?? '-';
//   String pow = sp.pow ?? '-';
//   String dur = sp.dur ?? '-';
//   String off = sp.off;
//   return Container(
//     width: width,
//     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//     decoration: BoxDecoration(
//       border: Border(
//         left: BorderSide(width: option ? 2 : 1, color: bordercolor),
//         right: BorderSide(width: option ? 2 : 1, color: bordercolor),
//       ),
//     ),
//     child: Table(
//       columnWidths: const {
//         0: FlexColumnWidth(2),
//         1: FlexColumnWidth(1),
//         2: FlexColumnWidth(1),
//         3: FlexColumnWidth(1),
//         4: FlexColumnWidth(1),
//         5: FlexColumnWidth(1),
//         6: FlexColumnWidth(1),
//       },
//       children: [
//         TableRow(
//           children: [
//             Text(sp.name.toString().toUpperCase(),
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text(cost,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(rng,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(aoe,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(pow,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(dur,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(off,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget spellDescription(String description, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
//   return Container(
//     width: width,
//     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//     decoration: BoxDecoration(
//       border: Border(
//         left: BorderSide(width: option ? 2 : 1, color: bordercolor),
//         right: BorderSide(width: option ? 2 : 1, color: bordercolor),
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.only(bottom: 3, right: 5),
//       child: Text(
//         description,
//         style: TextStyle(
//           color: textcolor,
//           fontSize: fontsize,
//         ),
//       ),
//     ),
//   );
// }

// Widget animusStats(Animus sp, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
//   String cost = sp.cost;
//   String rng = sp.rng;
//   String aoe = sp.aoe ?? '-';
//   String pow = sp.pow ?? '-';
//   String dur = sp.dur ?? '-';
//   String off = sp.off;
//   return Container(
//     width: width,
//     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//     decoration: BoxDecoration(
//       border: Border(
//         left: BorderSide(width: option ? 2 : 1, color: bordercolor),
//         right: BorderSide(width: option ? 2 : 1, color: bordercolor),
//       ),
//     ),
//     child: Table(
//       columnWidths: const {
//         0: FlexColumnWidth(2),
//         1: FlexColumnWidth(1),
//         2: FlexColumnWidth(1),
//         3: FlexColumnWidth(1),
//         4: FlexColumnWidth(1),
//         5: FlexColumnWidth(1),
//         6: FlexColumnWidth(1),
//       },
//       children: [
//         TableRow(
//           children: [
//             Text(sp.name.toString().toUpperCase(),
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontsize,
//                 )),
//             Text(cost,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(rng,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(aoe,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(pow,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(dur,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//             Text(off,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: textcolor,
//                   fontSize: fontsize,
//                 )),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget hpbox(int boxindex, Color bordercolor, ArmyListNotifier army, int? listindex, int? modelindex, int? hpbarindex) {
//   Color boxfillcolor = Colors.white;
//   if ((boxindex + 1) % 5 == 0) boxfillcolor = Colors.grey;
//   if (listindex != null && army.hptracking.isNotEmpty) {
//     if (hpbarindex == null) {
//       if (army.hptracking[listindex][modelindex!]['damage'] >= boxindex + 1) {
//         boxfillcolor = Colors.red.shade600;
//       }
//     } else {
//       if (army.hptracking[listindex][modelindex!]['hpbarsdamage'][hpbarindex] >= boxindex + 1) {
//         boxfillcolor = Colors.red.shade600;
//       }
//     }
//   }

//   return GestureDetector(
//     onTap: () {
//       if (listindex != null) {
//         army.adjustHPDamage(listindex, modelindex!, boxindex + 1, hpbarindex);
//       }
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: boxfillcolor,
//         border: Border.all(color: bordercolor),
//       ),
//       child: const SizedBox(width: 20, height: 20),
//     ),
//   );
// }

// Widget custombarbox(int boxindex, Color bordercolor, ArmyListNotifier army, int listindex, int modelindex, int barindex) {
//   Color boxfillcolor = Colors.white;
//   if ((boxindex + 1) % 5 == 0) boxfillcolor = Colors.grey;
//   if (army.custombartracking.isNotEmpty) {
//     if (army.custombartracking[listindex][modelindex]['value'] >= boxindex + 1) {
//       boxfillcolor = Colors.green.shade600;
//     }
//   }

//   return GestureDetector(
//     onTap: () {
//       army.adjustCustomBar(listindex, modelindex, boxindex + 1, barindex);
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: boxfillcolor,
//         border: Border.all(color: bordercolor),
//       ),
//       child: const SizedBox(width: 20, height: 20),
//     ),
//   );
// }
