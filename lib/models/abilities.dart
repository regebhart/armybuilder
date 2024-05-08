class Ability {
  String name;
  String description;

  Ability({
    required this.name,
    required this.description,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'],
      description: json['description'],
    );
  }
}