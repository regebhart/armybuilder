import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CopyToClipboardButton extends StatelessWidget {
  const CopyToClipboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    return InkWell(
      onTap: () async {
        if (!army.deploying) {
          // String export = 'WM3.5 Army\n\n$factionSelected - ${_listnameController.text}\n\n$_currentpoints / ${_encounterLevelSelected['armypoints']}\n';
          army.setlistname();
        }
        String export = army.copytListToClipboard();
        await Clipboard.setData(ClipboardData(text: export));
        if (context.mounted) {
          CherryToast.success(
            backgroundColor: Colors.green.shade500,
            animationType: AnimationType.fromTop,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: const Duration(milliseconds: 600),
            toastDuration: const Duration(seconds: 3),
            toastPosition: Position.top,
            title: Text(
              'Army list copied to clipboard!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
            ),
          ).show(context);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: const Icon(Icons.copy)),
      ),
    );
  }
}
