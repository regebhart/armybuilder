class Animus {
  String name;
  String cost;
  String rng;
  String? aoe;
  String? pow;
  String? dur;
  String off;
  String description;

  Animus({
    required this.name,
    required this.cost,
    required this.rng,
    this.aoe,
    this.pow,
    this.dur,
    required this.off,
    required this.description,
  });

  factory Animus.fromJson(Map<String, dynamic> json) {
    // print(json['name']);
    String cost = "";
    String rng = "";
    String aoe = "";
    String pow = "";
    String dur = "";
    String off = "";
    String description = "";

    if (json.containsKey('cost')) cost = json['cost'];
    if (json.containsKey('rng')) rng = json['rng'];
    if (json.containsKey('aoe')) aoe = json['aoe'];
    if (json.containsKey('pow')) pow = json['pow'];
    if (json.containsKey('dur')) dur = json['dur'];
    if (json.containsKey('off')) off = json['off'];
    if (json.containsKey('description')) description = json['description'];

    return Animus(
      name: json['name'],
      cost: cost,
      rng: rng,
      aoe: aoe,
      pow: pow,
      dur: dur,
      off: off,
      description: description,
    );
  }
}
