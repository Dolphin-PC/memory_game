import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_game/providers/card_provider.dart';
import 'package:memory_game/screens/game_screen.dart';

class HomeScreen extends ConsumerWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ref.watch(cardProvider.notifier).init();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(), fullscreenDialog: true),
              );
            },
          ),
        ),
      ),
    );
  }
}
