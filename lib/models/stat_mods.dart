class StatMods {
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
  String? fury;
  String? thr;
  String? ess;

  StatMods({
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
    this.fury,
    this.thr,
    this.ess,
  });

  factory StatMods.fromJson(Map<String, dynamic> json) {
    var stats = StatMods();

    if (json.containsKey('spd')) stats.spd = json['spd'];
    if (json.containsKey('str')) stats.str = json['str'];
    if (json.containsKey('aat')) stats.aat = json['aat'];
    if (json.containsKey('mat')) stats.mat = json['mat'];
    if (json.containsKey('rat')) stats.rat = json['rat'];
    if (json.containsKey('def')) stats.def = json['def'];
    if (json.containsKey('arm')) stats.arm = json['arm'];
    if (json.containsKey('arc')) stats.arc = json['arc'];
    if (json.containsKey('cmd')) stats.cmd = json['cmd'];
    if (json.containsKey('fury')) stats.fury = json['fury'];
    if (json.containsKey('thr')) stats.thr = json['thr'];
    if (json.containsKey('ess')) stats.ess = json['ess'];
    if (json.containsKey('ctrl')) stats.ctrl = json['ctrl'];

    return stats;
  }
}
