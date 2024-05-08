class Spiral {
  List<String> values;
  List<List<bool>> dots;

  Spiral({
    required this.values,
    required this.dots,
  });

  factory Spiral.fromJson(json) {
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

    return Spiral(
      values: values,
      dots: dots,
    );
  }

  factory Spiral.copy(Spiral s) {
    Spiral newcopy = Spiral(values: s.values, dots: s.dots);
    return newcopy;
  }
}
