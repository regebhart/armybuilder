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

  factory StatMods.copy(StatMods mods) {
    var stats = StatMods();

    if (mods.spd != null) stats.spd = mods.spd;
    if (mods.str != null) stats.str = mods.str;
    if (mods.aat != null) stats.aat = mods.aat;
    if (mods.mat != null) stats.mat = mods.mat;
    if (mods.rat != null) stats.rat = mods.rat;
    if (mods.def != null) stats.def = mods.def;
    if (mods.arm != null) stats.arm = mods.arm;
    if (mods.arc != null) stats.arc = mods.arc;
    if (mods.cmd != null) stats.cmd = mods.cmd;
    if (mods.fury != null) stats.fury = mods.fury;
    if (mods.thr != null) stats.thr = mods.thr;
    if (mods.ess != null) stats.ess = mods.ess;
    if (mods.ctrl != null) stats.ctrl = mods.ctrl;

    return stats;
  }
}
