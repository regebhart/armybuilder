class Feat {
  String name;
  String description;

  Feat({
    required this.name,
    required this.description,
  });

  factory Feat.fromJson(Map<String, dynamic> json) {
    return Feat(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
