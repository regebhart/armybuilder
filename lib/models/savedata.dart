// class SaveData() {
import 'dart:convert';
import 'dart:html';

import 'package:armybuilder/providers/armylist.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/appdata.dart';
import '../providers/faction.dart';
import 'armylist.dart';

//delete all lists
clearAllSavedLists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('lists', []);
}

//delete single list
deletearmylist(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> lists = prefs.getStringList('lists') ?? [];
  lists.removeAt(index);
  prefs.setStringList('lists', lists);
}

//save new
saveNewList(ArmyList list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> lists = prefs.getStringList('lists') ?? [];
  lists.insert(0, jsonEncode(list.toJson()));
  prefs.setStringList('lists', lists);
}

//save as
updateExisitingList(ArmyList army, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> lists = prefs.getStringList('lists') ?? [];
  lists[index] = jsonEncode(army.toJson());
  prefs.setStringList('lists', lists);
}

sortSavedLists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> lists = prefs.getStringList('lists') ?? [];
  List<Map<String, dynamic>> armylists = [];
  for (var list in lists) {
    armylists.add(jsonDecode(list));
  }
  armylists.sort((a, b) {
    final int sortbyfaction = a['faction'].toString().toLowerCase().compareTo(b['faction'].toString().toLowerCase());
    if (sortbyfaction == 0) {
      final int pointsort = a['pointtarget'].toString().toLowerCase().compareTo(b['pointtarget'].toString().toLowerCase());
      if (pointsort == 0) {
        //sort by point value
        return a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
      }
      return pointsort;
    }
    return sortbyfaction;
  });
  lists.clear();
  for (var list in armylists) {
    lists.add(jsonEncode(list));
  }
  prefs.setStringList('lists', lists);
}

//get and return saved lists
Future<List<String>> loadSavedLists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> lists = prefs.getStringList('lists') ?? [];

  return lists;
}

//export lists to a txt file
exportLists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('lists')) {
    String lists = prefs.getStringList('lists')!.join('::::');
    final bytes = utf8.encode(lists);
    final blob = Blob([bytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'army_list_backup.txt';
    document.body!.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(url);
  } else {
    //no lists currently saved
  }
}

//import txt file to lists
Future<int> importLists() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ['txt'],
    type: FileType.custom,
    allowMultiple: false,
  );

  if (result != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lists = prefs.getStringList('lists') ?? [];
    PlatformFile file = result.files.first;
    String fileContent = utf8.decode(file.bytes!);
    final reg = RegExp(r'^[a-zA-Z0-9\#\[\]\,\.\&\-\\\/\:\{\}\"\? ]+$');
    if (reg.hasMatch(fileContent)) {
      List<String> armies = fileContent.split('::::');
      for (var a in armies) {
        Map<String, dynamic> list = jsonDecode(a);
        bool validlist = await FactionNotifier().validateListFromFile(list);
        if (!validlist) {
          return 99;
        }
        lists.insert(0, a);
      }
    } else {
      return -1;
    }
    await prefs.setStringList('lists', lists);
    return 1;
  } else {
    return -10;
  }
}

Future<bool> importPastedList(String text, bool opponent, ArmyListNotifier army) async {
  if (text == '') return false;
  final alphanumeric = RegExp(r'^[a-zA-Z0-9 ]+$');
  List<String> lines = text.split('\n');
  String factionselected = '';
  String listname = '';
  String currentpoints = '';
  String pointtarget = '';
  List<String> productNames = [];

  for (String line in lines) {
    if (factionselected != '' && currentpoints != '' && pointtarget != '' && (line != '')) {
      String name = line;
      if (name.contains('BGP: +')) {
        name = name.substring(0, name.indexOf('- BGP: +') - 1).trim();
      }
      if (name.contains('- PC:')) {
        name = name.substring(0, name.indexOf('- PC:') - 1);
      }
      if (name.indexOf('-') == 0) {
        name = name.substring(1).trim();
      }
      productNames.add(name.trim());
    }
    if (factionselected == '') {
      for (Map<String, String> faction in AppData().factionList) {
        if (line.contains(faction['name']!)) {
          factionselected = faction['name']!;
          if (line.contains('-')) {
            listname = line.substring(line.indexOf('-') + 1).trim();
            if (!alphanumeric.hasMatch(listname)) return false;
          }
        }
      }
    }
    if (currentpoints == '' && pointtarget == '') {
      int pos = line.indexOf(' / ');
      if (pos != -1) {
        currentpoints = line.substring(0, pos).trim();
        pointtarget = line.substring(pos + 2).trim();
      }
    }
  }
  if (factionselected == '') return false;
  if (currentpoints == '') return false;
  if (pointtarget == '') return false;
  if (productNames.isEmpty) return false;
  ArmyList newlist = ArmyList(
    name: listname,
    listfaction: factionselected,
    totalpoints: currentpoints,
    pointtarget: pointtarget,
    leadergroup: [],
    units: [],
    solos: [],
    battleengines: [],
    structures: [],
    jrcasters: [],
  );

  int factionindex = AppData().factionList.indexWhere((element) => element['name'] == factionselected);

  bool valid = await FactionNotifier().validateProductNames(factionindex, productNames);
  // return valid;
  if (valid) {
    newlist = await FactionNotifier().convertProductNameListToArmyList(newlist, productNames);
  } else {
    return false;
  }

  if (opponent) {
    army.deployList(newlist);
  } else {
    saveNewList(newlist);
  }
  return true;
}
