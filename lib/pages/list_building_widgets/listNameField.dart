import 'package:armybuilder/pages/list_building_widgets/buttons/savelistbutton.dart';
import 'package:flutter/material.dart';
import 'package:armybuilder/pages/list_building_widgets/buttons/copytoclipboardbutton.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../appdata.dart';
import '../../providers/armylist.dart';

class ListNameField extends StatefulWidget {
  const ListNameField({super.key});

  @override
  State<ListNameField> createState() => _ListNameFieldState();
}

class _ListNameFieldState extends State<ListNameField> {
  TextEditingController con = TextEditingController();

  @override
  void dispose() {
    con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    army.setlistnameController(con);    

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text('List Name:'),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                controller: con,
                style: TextStyle(color: Colors.black, fontSize: AppData().fontsize - 2),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                ],
                decoration: InputDecoration(
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
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CopyToClipboardButton(),
              ),
              SaveListButton(),
              
            ],
          ),
        ),
      ],
    );
  }
}
