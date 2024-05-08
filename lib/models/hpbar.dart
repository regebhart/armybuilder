class hpbar {
  String name;
  String hp;
  int damage;

  hpbar({
    required this.name,
    required this.hp,
    required this.damage,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['hp'] = hp;
    return data;
  }

  factory hpbar.copy(hpbar hp) {
    hpbar newcopy = hpbar(
      name: hp.name,
      hp: hp.hp,
      damage: 0,
    );
    return newcopy;
  }
}
