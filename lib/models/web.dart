class Web {
  List<String> values;
  List<List<bool>> dots;

  Web({
    required this.values,
    required this.dots,
  });

  factory Web.fromJson(json) {
    List<String> values = [];
    List<List<bool>> dots = [];
    for (var v in json) {
      values.add(v);
    }

    for (int s = 0; s < values.length; s++) {
      int count = int.parse(values[s]);
      dots.add([]);
      for (int c = 0; c < count; c++) {
        dots[s].add(false);
      }
    }

    return Web(
      values: values,
      dots: dots,
    );
  }
  
  factory Web.copy(Web web) {
    return Web(
      values: web.values,
      dots: web.dots,
    );
  }
}
