import 'package:flutter/cupertino.dart';

// import 'grid.dart';

class BaseStats with ChangeNotifier {
  String base;
  String? spd;
  String? str;
  String? aat;
  String? mat;
  String? rat;
  String? def;
  String? arm;
  String? arc;
  String? cmd;
  String? ctrl;
  String? hp;
  String? fury;
  String? thr;
  String? ess;

  BaseStats({
    required this.base,
    this.spd,
    this.str,
    this.aat,
    this.mat,
    this.rat,
    this.def,
    this.arm,
    this.arc,
    this.cmd,
    this.ctrl,
    this.hp,
    this.fury,
    this.thr,
    this.ess,
  });

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    String spd = '-';
    if (json.containsKey('spd')) spd = json['spd'];
    String str = '-';
    if (json.containsKey('str')) str = json['str'];
    String aat = '-';
    if (json.containsKey('aat')) aat = json['aat'];
    String mat = '-';
    if (json.containsKey('mat')) mat = json['mat'];
    String rat = '-';
    if (json.containsKey('rat')) rat = json['rat'];
    String def = '-';
    if (json.containsKey('def')) def = json['def'];
    String arm = '-';
    if (json.containsKey('arm')) arm = json['arm'];
    String arc = '-';
    if (json.containsKey('arc')) arc = json['arc'];
    String cmd = '-';
    if (json.containsKey('cmd')) cmd = json['cmd'];
    String ctrl = '-';
    if (json.containsKey('ctrl')) ctrl = json['ctrl'];
    String hp = '-';
    if (json.containsKey('hp')) hp = json['hp'];
    String fury = '-';
    if (json.containsKey('fury')) fury = json['fury'];
    String thr = '-';
    if (json.containsKey('thr')) thr = json['thr'];
    String ess = '-';
    if (json.containsKey('ess')) ess = json['ess'];

    return BaseStats(
      base: json['basesize'],
      spd: spd,
      str: str,
      aat: aat,
      mat: mat,
      rat: rat,
      def: def,
      arm: arm,
      arc: arc,
      cmd: cmd,
      ctrl: ctrl,
      hp: hp,
      fury: fury,
      thr: thr,
      ess: ess,
    );
  }
}
