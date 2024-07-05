import 'package:armybuilder/models/abilities.dart';
import 'package:armybuilder/models/animi.dart';
import 'package:armybuilder/models/base_stats.dart';
import 'package:armybuilder/models/modularoptions.dart';
import 'package:armybuilder/models/product.dart';
import 'package:armybuilder/models/specialability.dart';
import 'package:armybuilder/models/weapons.dart';
import 'package:armybuilder/pages/widgets/spiral.dart';
import 'package:armybuilder/providers/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cohort.dart';
import '../models/grid.dart';
import '../models/model.dart';
import '../models/spells.dart';
import '../providers/armylist.dart';
import 'widgets/web.dart';

class UniversalModelStatPage extends StatefulWidget {
  final bool deployed;
  final int modelindex;
  final int? listindex;
  final int? listmodelindex;
  const UniversalModelStatPage({
    required this.deployed,
    required this.modelindex,
    this.listindex,
    this.listmodelindex,
    super.key,
  });

  @override
  State<UniversalModelStatPage> createState() => _UniversalModelStatPageState();
}

class _UniversalModelStatPageState extends State<UniversalModelStatPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: true);

    final double width = MediaQuery.of(context).size.width * 0.95;
    Color textcolor = Colors.grey[200]!;
    const Color bordercolor = Colors.grey;
    double fontsize = AppData().fontsize - 4;

    Cohort cohort = Cohort(product: army.blankproduct, selectedOptions: []);
    Product p = army.blankproduct;
    Model m = Model(modelname: '', modeltype: [], stats: BaseStats(base: ''), title: '');
    int index = 0;
    if (widget.listindex != null) {
      index = widget.listindex!;
    }

    if (army.viewingcohort[index]) {
      cohort = army.selectedCohort;
      if (widget.deployed) {
        cohort = army.deployedLists[widget.listindex!].selectedCohort;
      } else {
        cohort = army.selectedCohort;
      }
      p = cohort.product;
      m = p.models[widget.modelindex];
    } else {
      if (widget.deployed) {
        p = army.deployedLists[widget.listindex!].selectedProduct;
      } else {
        p = army.selectedProduct;
      }
      m = p.models[widget.modelindex];
    }

    List<Widget> modelsWidget = [];
    List<String> keywordlist = [];
    List<Ability> abilitylist = [];
    List<SpecialAbility> nestedabilities = [];
    List<Weapon> weaponlist = [];
    List<Animus> animilist = [];
    BaseStats moddedStats = BaseStats(
      base: m.stats.base,
      aat: m.stats.aat,
      arc: m.stats.arc,
      arm: m.stats.arm,
      cmd: m.stats.cmd,
      ctrl: m.stats.ctrl,
      def: m.stats.def,
      ess: m.stats.ess,
      fury: m.stats.fury,
      hp: m.stats.hp,
      mat: m.stats.mat,
      rat: m.stats.rat,
      spd: m.stats.spd,
      str: m.stats.str,
      thr: m.stats.thr,
    );

    keywordlist.addAll(m.keywords!);
    abilitylist.addAll(m.characterabilities!);
    nestedabilities.addAll(m.nestedabilities!);
    weaponlist.addAll(m.weapons!);
    animilist.addAll(m.animi!);

    Widget keywords = const SizedBox();
    Widget featname = const SizedBox();
    Widget featdescription = const SizedBox();
    Widget arcananame = const SizedBox();
    Widget arcanadescription = const SizedBox();
    List<Widget> abilities = [];
    Widget ability = const SizedBox();
    Widget stats = const SizedBox();
    Widget hp = const SizedBox();
    Widget custombar = const SizedBox();
    List<Widget> weapons = [];
    List<Widget> modularoptions = [];
    List<Widget> spells = [];
    List<Widget> animi = [];
    Widget hpTitle = const SizedBox();
    bool addhp = false;

    if (army.viewingcohort[index]) {
      for (Option op in cohort.selectedOptions!) {
        if (op.keywords!.isNotEmpty) {
          keywordlist.addAll(op.keywords!);
        }
        if (op.abilities!.isNotEmpty) {
          abilitylist.addAll(op.abilities!);
        }
        if (op.nestedabilities!.isNotEmpty) {
          nestedabilities.addAll(op.nestedabilities!);
        }
        if (op.weapons!.isNotEmpty) {
          weaponlist.addAll(op.weapons!);
        }
        if (op.animi!.isNotEmpty) {
          animilist.addAll(op.animi!);
        }
        if (moddedStats.aat! != '-' && op.statmods!.aat! != '0') {
          moddedStats.aat = (int.parse(moddedStats.aat!) + int.parse(op.statmods!.aat!)).toString();
        }
        if (moddedStats.arc! != '-' && op.statmods!.arc! != '0') {
          moddedStats.arc = (int.parse(moddedStats.arc!) + int.parse(op.statmods!.arc!)).toString();
        }
        if (moddedStats.arm! != '-' && op.statmods!.arm! != '0') {
          moddedStats.arm = (int.parse(moddedStats.arm!) + int.parse(op.statmods!.arm!)).toString();
        }
        if (moddedStats.cmd! != '-' && op.statmods!.cmd! != '0') {
          moddedStats.cmd = (int.parse(moddedStats.cmd!) + int.parse(op.statmods!.cmd!)).toString();
        }
        if (moddedStats.ctrl! != '-' && op.statmods!.ctrl! != '0') {
          moddedStats.ctrl = (int.parse(moddedStats.ctrl!) + int.parse(op.statmods!.ctrl!)).toString();
        }
        if (moddedStats.def! != '-' && op.statmods!.def! != '0') {
          moddedStats.def = (int.parse(moddedStats.def!) + int.parse(op.statmods!.def!)).toString();
        }
        if (moddedStats.ess! != '-' && op.statmods!.ess! != '0') {
          moddedStats.ess = (int.parse(moddedStats.ess!) + int.parse(op.statmods!.ess!)).toString();
        }
        if (moddedStats.fury! != '-' && op.statmods!.fury! != '0') {
          moddedStats.fury = (int.parse(moddedStats.fury!) + int.parse(op.statmods!.fury!)).toString();
        }
        if (moddedStats.mat! != '-' && op.statmods!.mat! != '0') {
          moddedStats.mat = (int.parse(moddedStats.mat!) + int.parse(op.statmods!.mat!)).toString();
        }
        if (moddedStats.rat! != '-' && op.statmods!.rat! != '0') {
          moddedStats.rat = (int.parse(moddedStats.rat!) + int.parse(op.statmods!.rat!)).toString();
        }
        if (moddedStats.spd! != '-' && op.statmods!.spd! != '0') {
          moddedStats.spd = (int.parse(moddedStats.spd!) + int.parse(op.statmods!.spd!)).toString();
        }
        if (moddedStats.str! != '-' && op.statmods!.str! != '0') {
          moddedStats.str = (int.parse(moddedStats.str!) + int.parse(op.statmods!.str!)).toString();
        }
      }
    }

    keywordlist.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    abilitylist.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    nestedabilities.sort((a, b) => a.topability.name.toLowerCase().compareTo(b.topability.name.toLowerCase()));
    weaponlist.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    animilist.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (keywordlist.isNotEmpty) {
      keywords = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: 'KEYWORDS: ',
          style: TextStyle(
            color: textcolor,
            fontWeight: FontWeight.bold,
            fontSize: fontsize,
          ),
          children: [
            TextSpan(
              text: keywordlist.join(', '),
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.normal,
                fontSize: fontsize,
              ),
            ),
          ],
        ),
      );
    }
    List<List<Widget>> statrow = [];

    if (moddedStats.spd != '-') statrow.add(statBlock('SPD', moddedStats.spd!, bordercolor, textcolor));
    if (moddedStats.str != '-') statrow.add(statBlock('STR', moddedStats.str!, bordercolor, textcolor));
    if (moddedStats.aat != '-') statrow.add(statBlock('AAT', moddedStats.aat!, bordercolor, textcolor));
    if (moddedStats.mat != '-') statrow.add(statBlock('MAT', moddedStats.mat!, bordercolor, textcolor));
    if (moddedStats.rat != '-') statrow.add(statBlock('RAT', moddedStats.rat!, bordercolor, textcolor));
    if (moddedStats.def != '-') statrow.add(statBlock('DEF', moddedStats.def!, bordercolor, textcolor));
    if (moddedStats.arm != '-') statrow.add(statBlock('ARM', moddedStats.arm!, bordercolor, textcolor));
    if (moddedStats.arc != '-') statrow.add(statBlock('ARC', moddedStats.arc!, bordercolor, textcolor));
    if (moddedStats.cmd != '-') statrow.add(statBlock('CMD', moddedStats.cmd!, bordercolor, textcolor));
    if (moddedStats.ctrl != '-') statrow.add(statBlock('CTRL', moddedStats.ctrl!, bordercolor, textcolor));
    if (moddedStats.fury != '-') statrow.add(statBlock('FURY', moddedStats.fury!, bordercolor, textcolor));
    if (moddedStats.thr != '-') statrow.add(statBlock('THR', moddedStats.thr!, bordercolor, textcolor));
    if (moddedStats.ess != '-') statrow.add(statBlock('ESS', moddedStats.ess!, bordercolor, textcolor));
    if (moddedStats.base != '-') statrow.add(statBlock('Base', moddedStats.base, bordercolor, textcolor));

    TableRow toprow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][0]));
    TableRow bottomrow = TableRow(children: List.generate(statrow.length, (index) => statrow[index][1]));
    stats = Table(
      border: TableBorder.all(width: 1, color: bordercolor),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [toprow, bottomrow],
    );

    if (m.grid!.columns.isEmpty && m.spiral!.values.isEmpty && m.web!.values.isEmpty && m.hpbars!.isEmpty) {
      //single model with more than 1 HP
      if (m.stats.hp != '-' && m.stats.hp != '1') {
        addhp = true;
        List<Widget> hpbar = List.generate(
          int.parse(m.stats.hp!),
          (index) => hpbox(index, bordercolor, army, widget.listindex, widget.listmodelindex, null),
        );

        List<Widget> hpbarrow = List.generate(
            (hpbar.length / 5).ceil(),
            (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: hpbar.sublist(index * 5, (index * 5) + 5 > hpbar.length ? hpbar.length : (index * 5) + 5),
                ));
        hp = Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text('${m.modelname} HP: ${m.stats.hp!}'),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 0,
                direction: Axis.horizontal,
                children: hpbarrow,
              ),
            ],
          ),
        );
      }
    }

    if (m.hpbars!.isNotEmpty) {
      List<Widget> bars = [];
      List<Widget> hpbar = [];
      int hpbarnum = 0;
      addhp = true;
      int barcount = 0;
      if (widget.deployed) {
        barcount = army.deployedLists[widget.listindex!].barcount;
      } else {
        barcount = m.hpbars!.length;
      }
      for (int b = 0; b < barcount; b++) {
        var hp = m.hpbars![b];
        if (hp.hp != '1') {
          hpbar = List.generate(
            int.parse(hp.hp),
            (index) => hpbox(
              index,
              bordercolor,
              army,
              widget.listindex,
              widget.listmodelindex,
              hpbarnum,
            ),
          );

          if (bars.isEmpty) {
            bars.add(const SizedBox(height: 3));
          }
          bars.add(
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text('${hp.name} HP: ${hp.hp}'),
            ),
          );
          bars.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: hpbar,
            ),
          );
        }
        hpbarnum++;
      }

      hp = Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bars,
        ),
      );
    }

    if (m.custombars!.isNotEmpty) {
      List<Widget> bars = [];
      List<Widget> bar = [];
      int barnum = 0;
      int custombarcount = 0;
      if (widget.deployed) {
        custombarcount = army.deployedLists[widget.listindex!].barcount;
      } else {
        custombarcount = m.custombars!.length;
      }
      for (int b = 0; b < custombarcount; b++) {
        var cb = m.custombars![b];
        bar = List.generate(
          int.parse(cb.totalcount),
          (index) => custombarbox(
            index,
            bordercolor,
            army,
            widget.listindex!,
            widget.listmodelindex!,
            barnum,
          ),
        );

        if (bars.isEmpty) {
          bars.add(const SizedBox(height: 3));
        }
        bars.add(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, right: 5),
                child: Text('${cb.name}:'),
              ),
              ...bar,
            ],
          ),
        );
        barnum++;
      }

      custombar = Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bars,
        ),
      );
    }

    bool hasshield = false;
    if (m.shield != null) {
      hasshield = m.shield != '0' && m.shield!.isNotEmpty;
    }

    if (m.grid!.columns.isNotEmpty) {
      //generate grid
      List<Widget> grid = [];
      int col = 0;
      int max = 5;
      addhp = true;
      hpTitle = Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text('GRID:',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            )),
      );

      if (m.grid!.columns.length > 6) {
        max = 11;
      }

      for (var c = 0; c <= max; c++) {
        col++;
        if (col > 6) {
          col = 1;
          grid.add(const SizedBox(width: 5));
        }
        List<Widget> column = [];
        column.add(
          Padding(
            padding: EdgeInsets.only(top: hasshield ? fontsize + 5 : 0),
            child: Text(col.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ),
        );
        for (int rownum = 0; rownum < m.grid!.columns[c].boxes.length; rownum++) {
          GridBox r = m.grid!.columns[c].boxes[rownum];
          String system = r.system;
          Color boxborder = bordercolor;
          Color fillColor;
          bool filled = false;
          if (army.hptracking.isNotEmpty) {
            filled = army.hptracking[widget.listindex!][widget.listmodelindex!]['grid'][c][rownum];
          }
          if (r.system == '-') {
            fillColor = Colors.black;
          } else {
            fillColor = Colors.white;
          }
          if (r.system == '-' || r.system == 'x') {
            system = '';
          }
          if (widget.deployed && filled) {
            fillColor = Colors.red;
            // boxborder = fillColor;
          }

          Widget gridBox = GestureDetector(
            onTap: () {
              if (r.system != '-' && widget.listindex != null) {
                army.adjustGridDamage(widget.listindex!, widget.listmodelindex!, c, rownum);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 5, color: boxborder)),
                child: SizedBox.square(
                  dimension: 17,
                  child: Container(
                    color: fillColor,
                    child: Center(
                        child: Text(
                      system,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: fontsize,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          );
          column.add(gridBox);
        }
        grid.add(Column(
          mainAxisSize: MainAxisSize.min,
          children: column,
        ));
      }

      if (hasshield) {
        double shield = double.parse(m.shield!);
        var shieldWidget = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Force\nField',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontsize,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    6,
                    (index) => shieldBox(
                      index >= (6 - (shield / 2)),
                      army,
                      widget.listindex,
                      widget.listmodelindex,
                      0,
                      index,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    6,
                    (index) => shieldBox(
                      index >= (6 - (shield / 2)),
                      army,
                      widget.listindex,
                      widget.listmodelindex,
                      1,
                      index,
                    ),
                  ),
                ),
              ],
            )
          ],
        );

        grid.insert(6, shieldWidget);
      }

      hp = Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: grid,
        ),
      );
    }

    if (m.spiral!.values.isNotEmpty) {
      addhp = true;
      hpTitle = Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text('SPIRAL:',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            )),
      );
      List<int> spiralvalues = [];

      for (var s in m.spiral!.values) {
        spiralvalues.add(int.parse(s));
      }

      hp = spiral(spiralvalues, 0, army, widget.listindex, widget.listmodelindex);
    }

    if (m.web!.values.isNotEmpty) {
      addhp = true;
      hpTitle = Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text('WEB:',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            )),
      );

      int outer = int.parse(m.web!.values[0]);
      int middle = int.parse(m.web!.values[1]);
      int inner = int.parse(m.web!.values[2]);
      hp = web(outer, middle, inner, army, widget.listindex, widget.listmodelindex);
    }

    if (m.arcana!.name != '' && m.arcana!.description != '') {
      arcananame = Container(
        width: width,
        decoration: const BoxDecoration(
            border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          // top: BorderSide(width: 1, color: bordercolor),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          child: Text(
            'TRUMP ARCANA: ${m.arcana!.name}',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
          ),
        ),
      );

      arcanadescription = Container(
        width: width,
        padding: const EdgeInsets.only(bottom: 3),
        decoration: const BoxDecoration(
            border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          bottom: BorderSide(width: 1, color: bordercolor),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          child: RichText(
            text: TextSpan(
              text: m.arcana!.description,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.normal,
                fontSize: fontsize,
              ),
            ),
          ),
        ),
      );
    }

    if (m.feat!.name != '' && m.feat!.description != '') {
      featname = Container(
        width: width,
        decoration: const BoxDecoration(
            border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          // top: BorderSide(width: 1, color: bordercolor),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          child: Text(
            'FEAT: ${m.feat!.name}',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
          ),
        ),
      );

      featdescription = Container(
        width: width,
        padding: const EdgeInsets.only(bottom: 3),
        decoration: const BoxDecoration(
            border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          bottom: BorderSide(width: 1, color: bordercolor),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          child: RichText(
            text: TextSpan(
              text: m.feat!.description,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.normal,
                fontSize: fontsize,
              ),
            ),
          ),
        ),
      );
    }

    if (abilitylist.isNotEmpty) {
      for (var ab in abilitylist) {
        if (abilities.isEmpty) {
          abilities.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text('ABILITIES:',
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
          ));
        }
        ability = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: ab.name,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.bold,
                fontSize: fontsize,
              ),
              children: [
                TextSpan(
                  text: ' - ${ab.description}',
                  style: TextStyle(
                    color: textcolor,
                    fontWeight: FontWeight.normal,
                    fontSize: fontsize,
                  ),
                ),
              ],
            ),
          ),
        );
        abilities.add(ability);
      }
    }

    if (nestedabilities.isNotEmpty) {
      for (var n in nestedabilities) {
        if (n.topability.name != '' && n.subabilities.isNotEmpty) {
          ability = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: n.topability.name,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                ),
                children: [
                  TextSpan(
                    text: n.topability.description == '' ? '' : ' - ${n.topability.description}',
                    style: TextStyle(
                      color: textcolor,
                      fontWeight: FontWeight.normal,
                      fontSize: fontsize,
                    ),
                  ),
                ],
              ),
            ),
          );
          abilities.add(ability);
        }

        for (var ab in n.subabilities) {
          ability = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1.5),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: ab.name,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                ),
                children: [
                  TextSpan(
                    text: ' - ${ab.description}',
                    style: TextStyle(
                      color: textcolor,
                      fontWeight: FontWeight.normal,
                      fontSize: fontsize,
                    ),
                  ),
                ],
              ),
            ),
          );
          abilities.add(ability);
        }
      }
    }

    if (m.execution!.name != '') {
      ability = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: 'EXECUTION: ${m.execution!.name}',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
            children: [
              TextSpan(
                text: ' - ${m.execution!.description}',
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.normal,
                  fontSize: fontsize,
                ),
              ),
            ],
          ),
        ),
      );
      abilities.add(ability);
    }

    if (weaponlist.isNotEmpty) {
      if (weapons.isEmpty) {
        weapons.add(Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text('WEAPONS:',
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
          ),
        ));
      }
      List<String> fields = ['none', 'left', 'right'];
      for (var f in fields) {
        List<Widget> thisfield = [];
        if (f != 'none') {
          thisfield.add(Container(
              width: width,
              padding: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1, color: bordercolor),
                  right: BorderSide(width: 1, color: bordercolor),
                ),
              ),
              child: Text('${f.toUpperCase()} FIELD OF FIRE:')));
        }
        for (var w in weaponlist) {
          List<Widget> weaponabilities = [];
          Widget weaponstats = const SizedBox();
          String count = '';
          String system = '';

          if (w.fieldoffire!.toString().toLowerCase() == f) {
            String type = '';
            if (w.count! != '' && w.count != '1') {
              count = ' (x${w.count!})';
            }
            if (w.system != '') {
              system = ' (${w.system})';
            }
            switch (w.type.toLowerCase()) {
              case 'melee':
                type = 'Melee Weapon';
                weaponstats = Table(
                  border: TableBorder.all(
                    width: 1,
                    color: bordercolor,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("RNG",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("POW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("P+S",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(w.rng,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        Text(w.pow,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        w.pow == '*'
                            ? Text(w.pow, textAlign: TextAlign.center)
                            : Text((int.parse(m.stats.str!) + int.parse(w.pow)).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textcolor,
                                  fontSize: fontsize,
                                )),
                      ],
                    ),
                  ],
                );
                break;
              case 'ranged':
                type = 'Ranged Weapon';

                weaponstats = Table(
                  border: TableBorder.all(
                    width: 1,
                    color: bordercolor,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("RNG",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("ROF",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("AOE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("POW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(w.rng,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        Text(w.rof!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        Text(w.aoe!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        Text(
                          w.pow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textcolor,
                            fontSize: fontsize,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
                break;
              case 'mount':
                type = 'Mount';
                weaponstats = Table(
                  border: TableBorder.all(
                    width: 1,
                    color: bordercolor,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("RNG",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                        Text("POW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(w.rng,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                        Text(w.pow,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textcolor,
                              fontSize: fontsize,
                            )),
                      ],
                    ),
                  ],
                );
                break;
            }

            if (w.abilities!.isNotEmpty) {
              for (var ab in w.abilities!) {
                ability = Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: ab.name,
                      style: TextStyle(
                        color: textcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      ),
                      children: [
                        TextSpan(
                          text: ' - ${ab.description}',
                          style: TextStyle(
                            color: textcolor,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                weaponabilities.add(ability);
              }
            }

            if (w.presetabilities!.isNotEmpty) {
              ability = Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  w.presetabilities.toString().replaceAll('[', '').replaceAll(']', ''),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize,
                  ),
                ),
              );
              weaponabilities.insert(0, ability);
            }

            if (w.nestedabilities!.isNotEmpty) {
              for (var n in w.nestedabilities!) {
                if (n.topability.name != '' && n.subabilities.isNotEmpty) {
                  ability = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: n.topability.name,
                        style: TextStyle(
                          color: textcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize,
                        ),
                        children: [
                          TextSpan(
                            text: ' - ${n.topability.description}',
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  weaponabilities.add(ability);

                  for (var ab in n.subabilities) {
                    ability = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: '• ${ab.name}',
                          style: TextStyle(
                            color: textcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: fontsize,
                          ),
                          children: [
                            TextSpan(
                              text: ' - ${ab.description}',
                              style: TextStyle(
                                color: textcolor,
                                fontWeight: FontWeight.normal,
                                fontSize: fontsize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    weaponabilities.add(ability);
                  }
                }
              }
            }

            Widget damageType = const SizedBox();
            if (w.damagetype!.isNotEmpty) {
              String d = w.damagetype!.toString().toString().replaceAll('[', '').replaceAll(']', '');
              if (d != '') {
                damageType = Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        text: 'Damage Type: ',
                        style: TextStyle(
                          color: textcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize,
                        ),
                        children: [
                          TextSpan(
                              text: d,
                              style: TextStyle(
                                color: textcolor,
                                fontWeight: FontWeight.normal,
                                fontSize: fontsize,
                              )),
                        ]),
                  ),
                );
              }
            }

            Widget currentWeapon = Container(
              width: width,
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1, color: bordercolor),
                  right: BorderSide(width: 1, color: bordercolor),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: bordercolor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 115,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${w.name.toString().toUpperCase()}$count$system',
                                        style: TextStyle(
                                          color: textcolor,
                                          fontSize: fontsize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        type,
                                        style: TextStyle(
                                          color: textcolor,
                                          fontSize: fontsize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 200,
                                  child: weaponstats,
                                ),
                              ],
                            ),
                            damageType,
                            ...weaponabilities,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            thisfield.add(currentWeapon);
          }
        }
        if (thisfield.length > 1) {
          if (weapons.isNotEmpty) {
            weapons.add(
              Container(
                width: width,
                height: 2,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1, color: bordercolor),
                    right: BorderSide(width: 1, color: bordercolor),
                  ),
                ),
              ),
            );
          }
          weapons.addAll(thisfield);
        } else {
          if (f == 'none' && thisfield.isNotEmpty) {
            weapons.addAll(thisfield);
          }
        }
      }
    }

    if (weapons.isNotEmpty) {
      weapons.add(
        Container(
            height: 2,
            width: width,
            decoration: const BoxDecoration(
                border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            ))),
      );
    }

    if (m.spells!.isNotEmpty) {
      for (var sp in m.spells!) {
        if (spells.isEmpty) {
          spells.add(spellHeaders(width, fontsize, bordercolor, textcolor, false));
        }
        spells.add(spellStats(sp, width, fontsize, bordercolor, textcolor, false));
        spells.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, false));
      }
    }

    if (animilist.isNotEmpty) {
      for (var sp in animilist) {
        if (animi.isEmpty) {
          animi.add(spellHeaders(width, fontsize, bordercolor, textcolor, false));
        }
        Spell thisSpell = Spell(name: sp.name, cost: sp.cost, rng: sp.rng, off: sp.off, description: sp.description);
        animi.add(spellStats(thisSpell, width, fontsize, bordercolor, textcolor, false));
        animi.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, false));
      }
    }

    if (m.modularoptions!.isNotEmpty) {
      ///////////////////loop through groups      ///
      for (var mo in m.modularoptions!) {
        if (modularoptions.isEmpty) {
          modularoptions.add(const SizedBox(
            width: 1000,
            height: 10,
          ));
          modularoptions.add(
            SizedBox(
              width: 1000,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'MODULAR OPTIONS:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize + 2,
                  ),
                ),
              ),
            ),
          );
        }
        modularoptions.add(Container(
            width: 1000,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: bordercolor),
              color: Colors.grey.shade700,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Text('${mo.groupname} Options',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize + 2,
                  )),
            )));
        ///////////////////////////Loop through individual options
        for (var op in mo.options!) {
          List<Widget> modularweapons = [];
          List<Widget> statmods = [];

          modularoptions.add(Container(
            width: 1000,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 2, color: bordercolor),
                right: BorderSide(width: 2, color: bordercolor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(op.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize + 2,
                      )),
                  Text(
                    'COST: ${op.cost}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize,
                    ),
                  ),
                ],
              ),
            ),
          ));

          if (op.keywords!.isNotEmpty) {
            String keywords = op.keywords!.join(', ');
            modularoptions.add(Container(
                width: 1000,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'KEYWORDS: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize,
                        ),
                      ),
                      Text(
                        keywords,
                        style: TextStyle(
                          fontSize: fontsize,
                        ),
                      ),
                    ],
                  ),
                )));
          }

          if (op.abilities!.isNotEmpty || op.nestedabilities!.isNotEmpty) {
            // abilities = [];
            modularoptions.add(Container(
                width: 1000,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text('ABILITIES: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      )),
                )));
          }

          for (var ab in op.abilities!) {
            ability = Container(
              width: 1000,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2, color: bordercolor),
                  right: BorderSide(width: 2, color: bordercolor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: ab.name,
                    style: TextStyle(
                      color: textcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize,
                    ),
                    children: [
                      TextSpan(
                        text: ' - ${ab.description}',
                        style: TextStyle(
                          color: textcolor,
                          fontWeight: FontWeight.normal,
                          fontSize: fontsize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            modularoptions.add(ability);
          }

          if (m.nestedabilities!.isNotEmpty) {
            for (var n in op.nestedabilities!) {
              if (n.topability.name != '' && n.subabilities.isNotEmpty) {
                ability = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: n.topability.name,
                      style: TextStyle(
                        color: textcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      ),
                      children: [
                        TextSpan(
                          text: n.topability.description == '' ? '' : ' - ${n.topability.description}',
                          style: TextStyle(
                            color: textcolor,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                modularoptions.add(ability);
              }

              for (var ab in n.subabilities) {
                ability = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1.5),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: ab.name,
                      style: TextStyle(
                        color: textcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      ),
                      children: [
                        TextSpan(
                          text: ' - ${ab.description}',
                          style: TextStyle(
                            color: textcolor,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                modularoptions.add(ability);
              }
            }
          }

          if (op.weapons!.isNotEmpty) {
            if (modularweapons.isEmpty) {
              modularweapons.add(Container(
                width: width,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text('WEAPONS:',
                      style: TextStyle(
                        color: textcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      )),
                ),
              ));
            }
            List<String> fields = ['none', 'left', 'right'];
            for (var f in fields) {
              List<Widget> thisfield = [];
              if (f != 'none') {
                thisfield.add(Container(
                    width: width,
                    padding: const EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 2, color: bordercolor),
                        right: BorderSide(width: 2, color: bordercolor),
                      ),
                    ),
                    child: Text('${f.toUpperCase()} FIELD OF FIRE:')));
              }
              for (var w in op.weapons!) {
                List<Widget> weaponabilities = [];
                Widget weaponstats = const SizedBox();
                String count = '';
                String system = '';

                if (w.fieldoffire!.toString().toLowerCase() == f) {
                  String type = '';
                  if (w.count! != '' && w.count != '1') {
                    count = ' (x${w.count!})';
                  }
                  if (w.system != '') {
                    system = ' (${w.system})';
                  }
                  switch (w.type.toLowerCase()) {
                    case 'melee':
                      type = 'Melee Weapon';
                      weaponstats = Table(
                        border: TableBorder.all(
                          width: 1,
                          color: bordercolor,
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text("RNG",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("POW",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("P+S",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(w.rng,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              Text(w.pow,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              w.pow == '*'
                                  ? Text(w.pow, textAlign: TextAlign.center)
                                  : Text((int.parse(m.stats.str!) + int.parse(w.pow)).toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: textcolor,
                                        fontSize: fontsize,
                                      )),
                            ],
                          ),
                        ],
                      );
                      break;
                    case 'ranged':
                      type = 'Ranged Weapon';

                      weaponstats = Table(
                        border: TableBorder.all(
                          width: 1,
                          color: bordercolor,
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text("RNG",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("ROF",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("AOE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("POW",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(w.rng,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              Text(w.rof!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              Text(w.aoe!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              Text(
                                w.pow,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textcolor,
                                  fontSize: fontsize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                      break;
                    case 'mount':
                      type = 'Mount';
                      weaponstats = Table(
                        border: TableBorder.all(
                          width: 1,
                          color: bordercolor,
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text("RNG",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                              Text("POW",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize,
                                  )),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(w.rng,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                              Text(w.pow,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textcolor,
                                    fontSize: fontsize,
                                  )),
                            ],
                          ),
                        ],
                      );
                      break;
                  }

                  if (w.abilities!.isNotEmpty) {
                    for (var ab in w.abilities!) {
                      ability = Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: ab.name,
                            style: TextStyle(
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            ),
                            children: [
                              TextSpan(
                                text: ' - ${ab.description}',
                                style: TextStyle(
                                  color: textcolor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: fontsize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      weaponabilities.add(ability);
                    }
                  }

                  if (w.presetabilities!.isNotEmpty) {
                    ability = Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        w.presetabilities.toString().replaceAll('[', '').replaceAll(']', ''),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: textcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize,
                        ),
                      ),
                    );
                    weaponabilities.insert(0, ability);
                  }

                  if (w.nestedabilities!.isNotEmpty) {
                    for (var n in w.nestedabilities!) {
                      if (n.topability.name != '' && n.subabilities.isNotEmpty) {
                        ability = Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: n.topability.name,
                              style: TextStyle(
                                color: textcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize,
                              ),
                              children: [
                                TextSpan(
                                  text: ' - ${n.topability.description}',
                                  style: TextStyle(
                                    color: textcolor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: fontsize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        weaponabilities.add(ability);

                        for (var ab in n.subabilities) {
                          ability = Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: '• ${ab.name}',
                                style: TextStyle(
                                  color: textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontsize,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' - ${ab.description}',
                                    style: TextStyle(
                                      color: textcolor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          weaponabilities.add(ability);
                        }
                      }
                    }
                  }

                  Widget damageType = const SizedBox();
                  if (w.damagetype!.isNotEmpty) {
                    String d = w.damagetype!.toString().toString().replaceAll('[', '').replaceAll(']', '');
                    if (d != '') {
                      damageType = Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: 'Damage Type: ',
                              style: TextStyle(
                                color: textcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize,
                              ),
                              children: [
                                TextSpan(
                                    text: d,
                                    style: TextStyle(
                                      color: textcolor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize,
                                    )),
                              ]),
                        ),
                      );
                    }
                  }

                  Widget currentWeapon = Container(
                    width: width,
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 2, color: bordercolor),
                        right: BorderSide(width: 2, color: bordercolor),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            // width: width - 25,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: bordercolor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 115,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${w.name.toString().toUpperCase()}$count$system',
                                              style: TextStyle(
                                                color: textcolor,
                                                fontSize: fontsize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              type,
                                              style: TextStyle(
                                                color: textcolor,
                                                fontSize: fontsize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: 200,
                                        child: weaponstats,
                                      ),
                                    ],
                                  ),
                                  damageType,
                                  ...weaponabilities,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  thisfield.add(currentWeapon);
                }
              }
              if (thisfield.length > 1) {
                if (modularweapons.isNotEmpty) {
                  modularweapons.add(
                    Container(
                      width: width,
                      height: 2,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 2, color: bordercolor),
                          right: BorderSide(width: 2, color: bordercolor),
                        ),
                      ),
                    ),
                  );
                }
                modularweapons.addAll(thisfield);
              } else {
                if (f == 'none' && thisfield.isNotEmpty) {
                  modularweapons.addAll(thisfield);
                }
              }
            }
          }

          if (modularweapons.isNotEmpty) {
            modularweapons.add(
              Container(
                  height: 2,
                  width: width,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ))),
            );
            modularoptions.addAll(modularweapons);
          }

          if (op.animi!.isNotEmpty) {
            modularoptions.add(Container(
                width: 1000,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('ANIMUS:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize,
                      )),
                )));
            for (var sp in op.animi!) {
              if (animi.isEmpty) {
                modularoptions.add(spellHeaders(width, fontsize, bordercolor, textcolor, true));
              }
              Animus thisSpell = Animus(name: sp.name, cost: sp.cost, rng: sp.rng, off: sp.off, description: sp.description);
              modularoptions.add(animusStats(thisSpell, width, fontsize, bordercolor, textcolor, true));
              modularoptions.add(spellDescription(sp.description, width, fontsize, bordercolor, textcolor, true));
            }
          }

          List<Map<String, String>> allstats = [
            {'stat': 'SPD', 'value': op.statmods!.spd!},
            {'stat': 'STR', 'value': op.statmods!.str!},
            {'stat': 'AAT', 'value': op.statmods!.aat!},
            {'stat': 'MAT', 'value': op.statmods!.mat!},
            {'stat': 'RAT', 'value': op.statmods!.rat!},
            {'stat': 'DEF', 'value': op.statmods!.def!},
            {'stat': 'ARM', 'value': op.statmods!.arm!},
            {'stat': 'ARC', 'value': op.statmods!.arc!},
            {'stat': 'CMD', 'value': op.statmods!.cmd!},
            {'stat': 'CTRL', 'value': op.statmods!.ctrl!},
            {'stat': 'FURY', 'value': op.statmods!.fury!},
            {'stat': 'THR', 'value': op.statmods!.thr!},
            {'stat': 'ESS', 'value': op.statmods!.ess!},
          ];
          double statwidth = 40;

          for (var s in allstats) {
            if (s['value'] != '0' && s['value'] != '-') {
              if (int.tryParse(s['value']!) != null) {
                int thisstat = int.parse(s['value']!);
                String statstr = s['value']!;
                if (thisstat > 0) statstr = '+$statstr';
                statmods.add(Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: statwidth,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: bordercolor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          s['stat']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontsize,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: statwidth,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: bordercolor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          statstr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontsize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
              }
            }
          }

          if (statmods.isNotEmpty) {
            modularoptions.add(
              Container(
                width: 1000,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    'STAT ADJUSTMENTS:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize,
                    ),
                  ),
                ),
              ),
            );
            modularoptions.add(
              Container(
                width: 1000,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 2, color: bordercolor),
                    right: BorderSide(width: 2, color: bordercolor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: statmods,
                  ),
                ),
              ),
            );
          }
          modularoptions.add(
            Container(
              width: 1000,
              height: 5,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2, color: bordercolor),
                  right: BorderSide(width: 2, color: bordercolor),
                  bottom: BorderSide(width: 2, color: bordercolor),
                ),
              ),
            ),
          );
        }
        modularoptions.add(const SizedBox(
          height: 8,
        ));
      }
    }

    List<Widget> modeldoc = [];

    modeldoc.add(Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: bordercolor),
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: Padding(
          //model name
          padding: const EdgeInsets.only(left: 5, right: 5, top: 3),
          child: Text(m.modelname,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.bold,
                fontSize: fontsize,
              ))),
    ));

    modeldoc.add(Container(
      //side borders and title
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
          child: Text(m.title,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.normal,
                fontSize: fontsize,
              ))),
    ));

    modeldoc.add(Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: 'MODEL TYPE',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
            children: [
              TextSpan(
                text: ': ${m.modeltype}'.toString().toString().replaceAll('[', '').replaceAll(']', ''),
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.normal,
                  fontSize: fontsize,
                ),
              ),
            ],
          ),
        ),
      ),
    ));

    modeldoc.add(Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          bottom: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 5),
        child: keywords,
      ),
    ));

    if (addhp) {
      modeldoc.add(Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 1, color: bordercolor),
            right: BorderSide(width: 1, color: bordercolor),
          ),
        ),
        child: hpTitle,
      ));

      modeldoc.add(Container(
        width: width,
        padding: const EdgeInsets.only(right: 5, bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 1, color: bordercolor),
            right: BorderSide(width: 1, color: bordercolor),
            bottom: BorderSide(width: 1, color: bordercolor),
          ),
        ),
        child: hp,
      ));
    }

    modeldoc.add(Container(
      width: width,
      padding: const EdgeInsets.only(right: 5, bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: bordercolor),
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
          bottom: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: custombar,
    ));

    modeldoc.add(Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1, color: bordercolor),
          right: BorderSide(width: 1, color: bordercolor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Text('STATISTICS:',
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            )),
      ),
    ));

    modeldoc.add(
      Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 1, color: bordercolor),
            right: BorderSide(width: 1, color: bordercolor),
            bottom: BorderSide(width: 1, color: bordercolor),
          ),
        ),
        child: stats,
      ),
    );

    modeldoc.add(featname);
    modeldoc.add(featdescription);

    modeldoc.add(arcananame);
    modeldoc.add(arcanadescription);

    for (var a = 0; a < abilities.length; a++) {
      if (a < abilities.length - 1) {
        modeldoc.add(Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
            ),
          ),
          child: abilities[a],
        ));
      } else {
        modeldoc.add(Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            ),
          ),
          child: abilities[a],
        ));
      }
    }

    modeldoc.addAll(weapons);

    if (spells.isNotEmpty) {
      modeldoc.add(
        Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Text(
            "SPELLS:",
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
          ),
        ),
      );

      modeldoc.addAll(spells);

      modeldoc.add(
        Container(
            width: width,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: bordercolor)),
            )),
      );
    }

    if (animi.isNotEmpty) {
      modeldoc.add(
        Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: bordercolor),
              right: BorderSide(width: 1, color: bordercolor),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Text(
            "ANIMUS:",
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
          ),
        ),
      );

      modeldoc.addAll(animi);

      modeldoc.add(
        Container(
            width: width,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: bordercolor)),
            )),
      );
    }

    if (modularoptions.isNotEmpty && !widget.deployed) {
      modeldoc.add(
        Column(children: modularoptions),
      );
    }

    modelsWidget.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: modeldoc,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: modelsWidget,
    );
  }
}

List<Widget> statBlock(String stat, String value, Color bordercolor, Color textcolor) {
  // double width = 40;
  // if (stat == 'Base') width = 60;
  return [
    Text(
      stat, //STAT HEADER
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textcolor,
        fontWeight: FontWeight.bold,
        fontSize: AppData().fontsize - 4,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(1),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textcolor,
          fontSize: AppData().fontsize - 4,
        ),
      ),
    )
  ];
}

Widget spellHeaders(double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(width: option ? 2 : 1, color: bordercolor),
        right: BorderSide(width: option ? 2 : 1, color: bordercolor),
      ),
    ),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Text('',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("COST",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("RNG",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("AOE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("POW",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("DUR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text("OFF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget spellStats(Spell sp, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
  String cost = sp.cost;
  String rng = sp.rng;
  String aoe = sp.aoe ?? '-';
  String pow = sp.pow ?? '-';
  String dur = sp.dur ?? '-';
  String off = sp.off;
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(width: option ? 2 : 1, color: bordercolor),
        right: BorderSide(width: option ? 2 : 1, color: bordercolor),
      ),
    ),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Text(sp.name.toString().toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text(cost,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(rng,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(aoe,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(pow,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(dur,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(off,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget spellDescription(String description, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(width: option ? 2 : 1, color: bordercolor),
        right: BorderSide(width: option ? 2 : 1, color: bordercolor),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 3, right: 5),
      child: Text(
        description,
        style: TextStyle(
          color: textcolor,
          fontSize: fontsize,
        ),
      ),
    ),
  );
}

Widget animusStats(Animus sp, double width, double fontsize, Color bordercolor, Color textcolor, bool option) {
  String cost = sp.cost;
  String rng = sp.rng;
  String aoe = sp.aoe ?? '-';
  String pow = sp.pow ?? '-';
  String dur = sp.dur ?? '-';
  String off = sp.off;

  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(width: option ? 2 : 1, color: bordercolor),
        right: BorderSide(width: option ? 2 : 1, color: bordercolor),
      ),
    ),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Text(sp.name.toString().toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                )),
            Text(cost,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(rng,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(aoe,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(pow,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(dur,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
            Text(off,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontsize,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget hpbox(int boxindex, Color bordercolor, ArmyListNotifier army, int? listindex, int? modelindex, int? hpbarindex) {
  Color boxfillcolor = Colors.white;
  if ((boxindex + 1) % 5 == 0) boxfillcolor = Colors.grey;
  if (listindex != null && army.hptracking.isNotEmpty) {
    if (hpbarindex == null) {
      if (army.hptracking[listindex][modelindex!]['damage'] >= boxindex + 1) {
        boxfillcolor = Colors.red.shade600;
      }
    } else {
      if (army.hptracking[listindex][modelindex!]['hpbarsdamage'][hpbarindex] >= boxindex + 1) {
        boxfillcolor = Colors.red.shade600;
      }
    }
  }

  return GestureDetector(
    onTap: () {
      if (listindex != null) {
        army.adjustHPDamage(listindex, modelindex!, boxindex + 1, hpbarindex);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: boxfillcolor,
        border: Border.all(color: bordercolor),
      ),
      child: const SizedBox(width: 20, height: 20),
    ),
  );
}

Widget custombarbox(int boxindex, Color bordercolor, ArmyListNotifier army, int listindex, int modelindex, int barindex) {
  Color boxfillcolor = Colors.white;
  if ((boxindex + 1) % 5 == 0) boxfillcolor = Colors.grey;
  if (army.custombartracking.isNotEmpty) {
    if (army.custombartracking[listindex][modelindex]['value'] >= boxindex + 1) {
      boxfillcolor = Colors.green.shade600;
    }
  }

  return GestureDetector(
    onTap: () {
      army.adjustCustomBar(listindex, modelindex, boxindex + 1, barindex);
    },
    child: Container(
      decoration: BoxDecoration(
        color: boxfillcolor,
        border: Border.all(color: bordercolor),
      ),
      child: const SizedBox(width: 20, height: 20),
    ),
  );
}

Widget shieldBox(bool active, ArmyListNotifier army, int? listindex, int? modelindex, int column, int row) {
  Color fillColor;
  Color borderColor = Colors.grey.shade700;

  if (!active) {
    fillColor = Colors.black;
  } else {
    // fillColor = const Color.fromARGB(255, 170, 212, 221); //light blue
    fillColor = Colors.lightBlue.shade200;
  }

  return GestureDetector(
    onTap: () {
      if (listindex != null && modelindex != null) {
        army.adjustShieldDamage(listindex, modelindex, column, row);
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 5, color: borderColor)),
        child: SizedBox.square(
            dimension: 17,
            child: Container(
              color: fillColor,
            )),
      ),
    ),
  );
}
