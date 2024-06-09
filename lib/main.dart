import 'package:armybuilder/firebase_options.dart';
import 'package:armybuilder/pages/widgets/factionupdatedates.dart';
import 'package:armybuilder/providers/appdata.dart';
import 'package:armybuilder/providers/armylist.dart';
import 'package:armybuilder/providers/faction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pagecontainer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalytics.instance.logScreenView(screenName: 'Visitor');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ArmyListNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => FactionNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'Warmachine MK 3.5 Army Builder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'WM 3.5 Army Builder'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ArmyListNotifier army = Provider.of<ArmyListNotifier>(context, listen: false);
    FactionNotifier faction = Provider.of<FactionNotifier>(context, listen: false);

    String buildlastupdated = '6/8/2024 v1';

    if (faction.allFactions.isEmpty) {
      faction.readAllFactions();
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Padding(
          padding: const EdgeInsets.only(top: 55.0),
          child: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('New List'),
                  onTap: () {
                    Navigator.of(context).pop();
                    army.resetEncounterLevel();
                    army.resetList();
                    army.pageController.jumpToPage(1);
                  },
                ),
                ListTile(
                  title: const Text('Edit/Deploy Army'),
                  onTap: () {
                    Navigator.of(context).pop();
                    army.pageController.jumpToPage(3);
                  },
                ),
                ListTile(
                  title: const Text('Import/Export'),
                  onTap: () {
                    Navigator.of(context).pop();
                    army.pageController.jumpToPage(4);
                  },
                ),
                ListTile(
                  title: Text(
                    'Build Updated: $buildlastupdated',
                    style: TextStyle(fontSize: AppData().fontsize - 4),
                  ),
                ),
                const FactionDatesListTile(),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(
          child: PagesContainer(),
        ),
      ),
    );
  }
}
