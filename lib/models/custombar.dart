class CustomBar {
  String name;
  String totalcount;
  int currentvalue;

  CustomBar({
    required this.name,
    required this.totalcount,
    required this.currentvalue,
  });

  factory CustomBar.fromJson(Map<String, dynamic> json) {
       

    return CustomBar(
      name: json['name'],
      totalcount: json['count'],
      currentvalue: 0,      
    );
  }

  factory CustomBar.copy(CustomBar custom) {
    CustomBar newcopy = CustomBar(
      name: custom.name,
      totalcount: custom.totalcount,
      currentvalue: 0,
    );
    return newcopy;
  }
}
