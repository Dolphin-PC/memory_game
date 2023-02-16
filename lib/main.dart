import 'package:flutter/material.dart';
import 'package:memory_game/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'memory game',
        theme: ThemeData(),
        home: const HomeScreen(),
      ),
    );
  }
}
