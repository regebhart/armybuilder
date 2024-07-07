import 'package:armybuilder/providers/armylist.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/savedata.dart';
import '../../appdata.dart';

class ImportPastedList extends StatefulWidget {
  final bool opponent;
  const ImportPastedList({required this.opponent, super.key});

  @override
  State<ImportPastedList> createState() => _ImportPastedListState();
}

class _ImportPastedListState extends State<ImportPastedList> {
  final TextEditingController con = TextEditingController();

  void _getClipboardText() async {
    if (con.text == '') {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      setState(() {
        con.text = clipboardData!.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final army = Provider.of<ArmyListNotifier>(context, listen: false);
    late CherryToast toast;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.white,
                child: TextButton(
                  onPressed: () async {
                    // if (con.text != '') {
                    bool result = await importPastedList(con.text, widget.opponent, army);
                    if (result) {
                      toast = CherryToast.success(
                        backgroundColor: Colors.green.shade500,
                        animationType: AnimationType.fromBottom,
                        animationCurve: Curves.fastLinearToSlowEaseIn,
                        animationDuration: const Duration(milliseconds: 600),
                        toastDuration: const Duration(seconds: 5),
                        toastPosition: Position.bottom,
                        title: Text(
                          'List successfully imported!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                        ),
                      );
                    } else {
                      toast = CherryToast.error(
                        backgroundColor: Colors.red,
                        animationType: AnimationType.fromBottom,
                        animationCurve: Curves.fastLinearToSlowEaseIn,
                        animationDuration: const Duration(milliseconds: 600),
                        toastDuration: const Duration(seconds: 5),
                        toastPosition: Position.bottom,
                        title: Text(
                          'Invalid list.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                        ),
                      );
                    }
                    if (context.mounted) {
                      toast.show(context);
                    }
                    setState(() {
                      con.clear();
                    });
                    // }
                  },
                  child: Text(
                    'Import Pasted List',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300, minHeight: 50, maxHeight: 200),
            child: Stack(
              children: [
                TextField(
                  expands: true,
                  maxLines: null,
                  controller: con,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(color: Colors.black, fontSize: AppData().fontsize - 6),
                  onTap: _getClipboardText,
                  decoration: InputDecoration(
                    hintText: "Tap to paste list",
                    hintStyle: TextStyle(color: Colors.black54, fontSize: AppData().fontsize),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 234, 201, 201), width: 1.5),
                    ),
                    focusColor: Colors.black,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    color: Colors.red,
                    iconSize: 30,
                    onPressed: con.clear,
                    icon: const Icon(Icons.clear),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
