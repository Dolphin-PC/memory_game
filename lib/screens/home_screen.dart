import 'package:flutter/material.dart';
import 'package:memory_game/providers/game_provider.dart';
import 'package:memory_game/screens/game_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('기억력 게임')),
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: IconButton(
            icon: const Icon(
              Icons.play_arrow,
              size: 200,
            ),
            onPressed: () {
              gameProvider.init();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen(), fullscreenDialog: true),
              );
            },
          ),
        ),
      ),
    );
  }
}
