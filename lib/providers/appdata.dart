class AppData {
  final List<Map<String, String>> _factionList = [
    {'name': 'Blindwater Congregation', 'list': 'hordes', 'file': 'blindwater.json'},
    // {'name': 'Cephalyx', 'type': 'warmachine'}
    // {'name': 'Convergence of Cyriss', 'type': 'warmachine'}
    {'name': 'Circle Orboros', 'list': 'hordes', 'file': 'circle.json'},
    {'name': 'Crucible Guard', 'list': 'warmachine', 'file': 'crucible.json'},
    {'name': 'Cryx', 'list': 'warmachine', 'file': 'cryx.json'},
    {'name': 'Cygnar', 'list': 'warmachine', 'file': 'cygnar.json'},
    {'name': 'Grymkin', 'list': 'hordes', 'file': 'grymkin.json'},
    // 'Infernals',
    // 'Ios',
    {'name': 'Khador', 'list': 'warmachine', 'file': 'khador.json'},
    {'name': 'Khymaera', 'list': 'hordes', 'file': 'khymaera.json'},
    {'name': 'Legion of Everblight', 'list': 'hordes', 'file': 'everblight.json'},
    // 'Llael',
    // 'Mercenaries',
    // 'Ord',
    {'name': 'Orgoth', 'list': 'warmachine', 'file': 'orgoth.json'},
    {'name': 'Protectorate of Menoth', 'list': 'warmachine', 'file': 'protectorate.json'},
    // 'Religion of the Twins',
    // 'Searforge Commission',
    {'name': 'Skorne', 'list': 'hordes', 'file': 'skorne.json'},
    // 'Supernal Coalition',
    // 'Talion Charter',
    {'name': 'Thornfall Alliance', 'list': 'hordes', 'file': 'thornfall.json'},
    {'name': 'Trollbloods', 'list': 'hordes', 'file': 'trollbloods.json'},
  ];
  final List<String> _productCategories = [
    'Warcasters/Warlocks/Masters',
    'Warjacks/Warbeasts/Horrors',
    'Solos',
    'Units',
    // 'Attachments',
    'Battle Engines',
    'Structures',
  ];
  final List<String> _warmachine = [
    'Warcasters',
    'Warjacks',
    'Solos',
    'Units',
    // 'Attachments',
    'Battle Engines',
    'Structures',
  ];
  final List<String> _hordes = [
    'Warlocks',
    'Warbeasts',
    'Solos',
    'Units',
    // 'Attachments',
    'Battle Engines',
    'Structures',
  ];
  // final List<String> _infernals = [
  //   'Warcasters/Warlocks/Masters',
  //   'Warjacks/Warbeasts/Horrors',
  //   'Solos',
  //   'Units',
  //   // 'Attachments',
  //   'Battle Engines',
  //   'Structures',
  // ];
  final List<Map<String, dynamic>> encounterlevels = [
    {'name': 'Duel', 'level': '0', 'armypoints': 0, 'options': 0, 'castercount': 1},
    {'name': 'Demo', 'level': '0.5', 'armypoints': 15, 'options': 0, 'castercount': 1},
    {'name': 'Brawl', 'level': '1', 'armypoints': 25, 'options': 1, 'castercount': 1},
    {'name': 'Clash', 'level': '2', 'armypoints': 50, 'options': 2, 'castercount': 1},
    {'name': 'Pitched Battle', 'level': '3', 'armypoints': 75, 'options': 3, 'castercount': 1},
    {'name': 'Grand Melee', 'level': '4', 'armypoints': 100, 'options': 4, 'castercount': 1},
    {'name': 'Major Engagement', 'level': '5', 'armypoints': 125, 'options': 5, 'castercount': 2},
    {'name': 'Major Engagement', 'level': '6', 'armypoints': 150, 'options': 6, 'castercount': 2},
    {'name': 'Major Engagement', 'level': '7', 'armypoints': 175, 'options': 7, 'castercount': 2},
    {'name': 'Open War', 'level': '8', 'armypoints': 200, 'options': 8, 'castercount': 3},
    {'name': 'Open War', 'level': '9', 'armypoints': 225, 'options': 9, 'castercount': 3},
    {'name': 'Open War', 'level': '10', 'armypoints': 250, 'options': 10, 'castercount': 3},
    {'name': 'Open War', 'level': '11', 'armypoints': 275, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '12', 'armypoints': 300, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '13', 'armypoints': 325, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '14', 'armypoints': 350, 'options': 10, 'castercount': 5},
    {'name': 'Open War', 'level': '15', 'armypoints': 375, 'options': 10, 'castercount': 5},
    {'name': 'Open War', 'level': '16', 'armypoints': 400, 'options': 10, 'castercount': 5},
  ];
  final double _fontsize = 16;
  final double _iconsize = 28;
  final double _listButtonSpacing = 8;
  final double _listItemSpacing = 4;

  List<String> get productCategories => _productCategories;
  List<Map<String, String>> get factionList => _factionList;
  List<String> get warmachine => _warmachine;
  List<String> get hordes => _hordes;
  double get fontsize => _fontsize;
  double get iconsize => _iconsize;

  double get listButtonSpacing => _listButtonSpacing;
  double get listItemSpacing => _listItemSpacing;

  AppData();
}
