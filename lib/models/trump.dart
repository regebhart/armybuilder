class TrumpArcana {
  String name;
  String description;

  TrumpArcana({
    required this.name,
    required this.description,
  });

  factory TrumpArcana.fromJson(Map<String, dynamic> json) {
    return TrumpArcana(
      name: json['name'],
      description: json['description'],
    );
  }
}
