class Spell {
  String name;
  String cost;
  String rng;
  String? aoe;
  String? pow;
  String? dur;
  String off;
  String description;
  List<String>? poolfactions;
  String? poolcost;

  Spell({
    required this.name,
    required this.cost,
    required this.rng,
    this.aoe,
    this.pow,
    this.dur,
    required this.off,
    required this.description,
    this.poolfactions,
    this.poolcost,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    String name = '';
    String cost = '';
    String rng = '';
    String aoe = '';
    String pow = '';
    String dur = '';
    String off = '';
    String description = '';
    String poolcost = '';
    List<String> poolfactions = [];

    if (json.containsKey('name')) name = json['name'];
    if (json.containsKey('cost')) cost = json['cost'];
    if (json.containsKey('rng')) rng = json['rng'];
    if (json.containsKey('aoe')) aoe = json['aoe'];
    if (json.containsKey('pow')) pow = json['pow'];
    if (json.containsKey('dur')) dur = json['dur'];
    if (json.containsKey('off')) {
      if (json['off'] == '-') {
        off = json['off'];
      } else {
        off = json['off'] ? 'YES' : 'NO';
      }
    }
    if (json.containsKey('description')) description = json['description'];
    if (json.containsKey('poolcost')) poolcost = json['poolcost'];
    if (json.containsKey('poolfactions')) {
      for (var p in json['poolfactions']) {
        poolfactions.add(p);
      }
    }

    return Spell(
      name: name,
      cost: cost,
      rng: rng,
      aoe: aoe,
      pow: pow,
      dur: dur,
      off: off,
      description: description,
      poolfactions: poolfactions,
      poolcost: poolcost,
    );
  }

  factory Spell.copy(Spell spell) {
    return Spell(
      name: spell.name,
      cost: spell.cost,
      rng: spell.rng,
      aoe: spell.aoe,
      pow: spell.pow,
      dur: spell.dur,
      off: spell.off,
      description: spell.description,
      poolfactions: spell.poolfactions,
      poolcost: spell.poolcost,
    );
  }
}
