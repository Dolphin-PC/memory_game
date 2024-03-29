import 'package:card_memory_game/db/db_helper.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/providers/stage_provider.dart';
import 'package:card_memory_game/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;

  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => PointProvider()),
        ChangeNotifierProvider(create: (_) => StageProvider()),
      ],
      child: MaterialApp(
        title: 'memory game',
        theme: ThemeData(),
        home: const HomeScreen(),
      ),
    );
  }
}
