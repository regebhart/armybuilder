class AppData {
  final List<Map<String, String>> _factionList = [
    {'name': 'Blindwater Congregation', 'list': 'hordes', 'file': 'blindwater.json'},
    {'name': 'Cephalyx', 'list': 'warmachine', 'file': 'cephalyx.json'},
    {'name': 'Circle Orboros', 'list': 'hordes', 'file': 'circle.json'},
    {'name': 'Convergence of Cyriss', 'list': 'warmachine', 'file': 'convergence.json'},
    {'name': 'Crucible Guard', 'list': 'warmachine', 'file': 'crucible.json'},
    {'name': 'Cryx', 'list': 'warmachine', 'file': 'cryx.json'},
    {'name': 'Cygnar', 'list': 'warmachine', 'file': 'cygnar.json'},
    {'name': 'Grymkin', 'list': 'hordes', 'file': 'grymkin.json'},
    {'name': 'Infernals', 'list': 'hordes', 'file': 'infernals.json'},
    {'name': 'Ios', 'list': 'warmachine', 'file': 'ios.json'},
    {'name': 'Khador', 'list': 'warmachine', 'file': 'khador.json'},
    {'name': 'Khymaera', 'list': 'hordes', 'file': 'khymaera.json'},
    {'name': 'Legion of Everblight', 'list': 'hordes', 'file': 'everblight.json'},
    {'name': 'Llael', 'list': 'hordes', 'file': 'llael.json'},
    {'name': 'Mercenaries', 'list': 'warmachine', 'file': 'mercenaries.json'},
    {'name': 'Ord', 'list': 'warmachine', 'file': 'ord.json'},
    {'name': 'Orgoth', 'list': 'warmachine', 'file': 'orgoth.json'},
    {'name': 'Protectorate of Menoth', 'list': 'warmachine', 'file': 'protectorate.json'},
    {'name': 'Religion of the Twins', 'list': 'warmachine', 'file': 'religion.json'},
    {'name': 'Searforge Commission', 'list': 'warmachine', 'file': 'searforge.json'},
    {'name': 'Skorne', 'list': 'hordes', 'file': 'skorne.json'},
    {'name': 'Supernal Coalition', 'list': 'warmachine', 'file': 'supernal.json'},
    {'name': 'Talion Charter', 'list': 'warmachine', 'file': 'talion.json'},
    {'name': 'The Broken Pact', 'list': 'hordes', 'file': 'brokenpact.json'},
    {'name': 'Thornfall Alliance', 'list': 'hordes', 'file': 'thornfall.json'},
    {'name': 'Trollbloods', 'list': 'hordes', 'file': 'trollbloods.json'},
    {'name': 'Warriors of the Old Faith', 'list': 'warmachine', 'file': 'warriors.json'},
    {'name': 'Vengeance of Dhunia', 'list': 'hordes', 'file': 'vengeance.json'},
  ];
  final List<String> _productCategories = [
    'Warcasters/Warlocks/Masters',
    'Warjacks/Warbeasts/Horrors',
    'Solos',
    'Units',
    'Battle Engines',
    'Structures',
  ];
  final List<String> _warmachine = [
    'Warcasters',
    'Warjacks',
    'Solos',
    'Units',
    'Battle Engines',
    'Structures',
  ];
  final List<String> _hordes = [
    'Warlocks',
    'Warbeasts',
    'Solos',
    'Units',
    'Battle Engines',
    'Structures',
  ];

  final List<Map<String, String>> _rankingOfficers = [
    {'faction': 'Cephalyx', 'officer': 'Cephalyx Dominator'},
    {'faction': 'Crucible Guard', 'officer': 'Doctor Alejandro Mosby'},
    {'faction': 'Cygnar', 'officer': 'Captain Jonas Murdoch'},
    {'faction': 'Khador', 'officer': 'Koldun Kapitan Valachev'},
    {'faction': 'Protectorate of Menoth', 'officer': 'Attendant Priest'},
  ];

  final List<Map<String, dynamic>> encounterlevels = [
    {'name': 'Duel', 'level': '0', 'armypoints': 0, 'options': 0, 'castercount': 1},
    {'name': 'Demo', 'level': '0.5', 'armypoints': 15, 'options': 0, 'castercount': 1},
    {'name': 'Brawl', 'level': '1', 'armypoints': 25, 'options': 1, 'castercount': 1},
    {'name': 'Brawl (Classic)', 'level': '2', 'armypoints': 35, 'options': 1, 'castercount': 1},
    {'name': 'Clash', 'level': '3', 'armypoints': 50, 'options': 2, 'castercount': 1},
    {'name': 'Pitched Battle', 'level': '4', 'armypoints': 75, 'options': 3, 'castercount': 1},
    {'name': 'Grand Melee', 'level': '5', 'armypoints': 100, 'options': 4, 'castercount': 1},
    {'name': 'Major Engagement', 'level': '6', 'armypoints': 125, 'options': 5, 'castercount': 2},
    {'name': 'Major Engagement', 'level': '7', 'armypoints': 150, 'options': 6, 'castercount': 2},
    {'name': 'Major Engagement', 'level': '8', 'armypoints': 175, 'options': 7, 'castercount': 2},
    {'name': 'Open War', 'level': '9', 'armypoints': 200, 'options': 8, 'castercount': 3},
    {'name': 'Open War', 'level': '10', 'armypoints': 225, 'options': 9, 'castercount': 3},
    {'name': 'Open War', 'level': '11', 'armypoints': 250, 'options': 10, 'castercount': 3},
    {'name': 'Open War', 'level': '12', 'armypoints': 275, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '13', 'armypoints': 300, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '14', 'armypoints': 325, 'options': 10, 'castercount': 4},
    {'name': 'Open War', 'level': '15', 'armypoints': 350, 'options': 10, 'castercount': 5},
    {'name': 'Open War', 'level': '16', 'armypoints': 375, 'options': 10, 'castercount': 5},
    {'name': 'Open War', 'level': '17', 'armypoints': 400, 'options': 10, 'castercount': 5},
  ];

  final List<String> _listbuildingabilities = [
    'attached',
    'animosity',
    'attachment',
    'attached',
    'bog trog warlock',
    'caster adept',
    'command attachment',
    'companion',
    'dispensation',
    'faithful',
    'flames in the darkness',
    'garrison troops',
    'heart of darkness',
    'irregulars',
    'limited battlegroup',
    'limited marshal',
    'master infernalist',
    'mercenary',
    'military attaché',
    'of the swamp',
    'paid loyalties',
    'partisan',
    'requisition',
    'special issue',
    'spell rack',
    'split loyalties',
    'strange bedfelllows',
    'warcaster equivalent',
    'warlock adept',
    'weapon attachment',
    'weapon attachment specialists'
  ];

  final double _fontsize = 16;
  final double _iconsize = 28;
  final double _listButtonSpacing = 8;
  final double _listItemSpacing = 4;

  final double _selectedListLeftWidth = 45;

  List<String> get productCategories => _productCategories;
  List<Map<String, String>> get factionList => _factionList;
  List<String> get warmachine => _warmachine;
  List<String> get hordes => _hordes;
  List<Map<String, String>> get rankingOfficers => _rankingOfficers;
  double get fontsize => _fontsize;
  double get iconsize => _iconsize;

  double get listButtonSpacing => _listButtonSpacing;
  double get listItemSpacing => _listItemSpacing;

  double get selectedListLeftWidth => _selectedListLeftWidth;
  List<String> get listbuildingabilities => _listbuildingabilities;

  AppData();
}
