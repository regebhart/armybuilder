class Grid {
  List<GridColumn> columns;

  Grid({
    required this.columns,
  });

  factory Grid.fromJson(json) {
    List<GridColumn> gridColumns = [];

    List<dynamic> data = json['columns'];

    for (var c in data) {
      GridColumn columnList = GridColumn.extract(c['values']);
      gridColumns.add(columnList);
    }

    return Grid(
      columns: gridColumns,
    );
  }

  factory Grid.copy(Grid grid) {
    Grid newcopy = Grid(
      columns: List.generate(
        grid.columns.length,
        (index) => GridColumn.copy(
          grid.columns[index],
        ),
      ),
    );
    return newcopy;
  }
}

class GridColumn {
  List<GridBox> boxes;

  GridColumn({
    required this.boxes,
  });

  factory GridColumn.extract(data) {
    List<GridBox> boxList = [];

    for (var b in data) {
      boxList.add(GridBox(system: b, active: false));
    }

    return GridColumn(boxes: boxList);
  }

  List<String> toJson() {
    List<String> data = [];
    for (var b in boxes) {
      data.add(b.system);
    }
    return data;
  }

  factory GridColumn.copy(GridColumn c) {
    GridColumn newcopy = GridColumn(
      boxes: List.generate(
        c.boxes.length,
        (index) => GridBox.copy(
          c.boxes[index],
        ),
      ),
    );
    return newcopy;
  }
}

class GridBox {
  String system;
  bool active;

  GridBox({
    required this.system,
    required this.active,
  });

  factory GridBox.copy(GridBox b) {
    GridBox newcopy = GridBox(
      system: b.system,
      active: b.active,
    );
    return newcopy;
  }
}
