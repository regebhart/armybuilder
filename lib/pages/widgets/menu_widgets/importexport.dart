import 'package:armybuilder/pages/widgets/importfield.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

import '../models/savedata.dart';
import '../providers/appdata.dart';

class ImportExport extends StatefulWidget {
  const ImportExport({super.key});

  @override
  State<ImportExport> createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  @override
  Widget build(BuildContext context) {
    late CherryToast toast;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.white,
                  child: TextButton(
                    onPressed: () async {
                      await exportLists();
                    },
                    child: Text(
                      'Download All Lists',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 15),
            child: SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.white,
                  child: TextButton(
                    onPressed: () async {
                      int result = await importLists();
                      switch (result) {
                        case -1:
                          //there was an error
                          toast = CherryToast.error(
                            backgroundColor: Colors.red,
                            animationType: AnimationType.fromBottom,
                            animationCurve: Curves.fastLinearToSlowEaseIn,
                            animationDuration: const Duration(milliseconds: 600),
                            toastDuration: const Duration(seconds: 5),
                            toastPosition: Position.bottom,
                            title: Text(
                              'Invalid file.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                            ),
                          );
                          break;
                        case 99:
                          //invalid list/file
                          toast = CherryToast.error(
                            backgroundColor: Colors.red,
                            animationType: AnimationType.fromBottom,
                            animationCurve: Curves.fastLinearToSlowEaseIn,
                            animationDuration: const Duration(milliseconds: 600),
                            toastDuration: const Duration(seconds: 5),
                            toastPosition: Position.bottom,
                            title: Text(
                              'One or more of the lists in the file is invalid.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                            ),
                          );
                          break;
                        case 1:
                          toast = CherryToast.success(
                            backgroundColor: Colors.green.shade500,
                            animationType: AnimationType.fromBottom,
                            animationCurve: Curves.fastLinearToSlowEaseIn,
                            animationDuration: const Duration(milliseconds: 600),
                            toastDuration: const Duration(seconds: 5),
                            toastPosition: Position.bottom,
                            title: Text(
                              'Lists successfully imported!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                            ),
                          );
                          break;
                        case -10:
                          break;
                      }
                      if (context.mounted) toast.show(context);
                    },
                    child: Text(
                      'Import Lists from File',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              '- OR -',
              style: TextStyle(fontSize: AppData().fontsize - 2, color: Colors.white),
            ),
          ),
          const ImportPastedList(opponent: false,),
        ],
      ),
    );
  }
}
