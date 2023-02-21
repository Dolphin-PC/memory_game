import 'package:flutter/material.dart';
import 'package:memory_game/providers/game_provider.dart';
import 'package:memory_game/styles/color_styles.dart';
import 'package:memory_game/styles/text_styles.dart';
import 'package:provider/provider.dart';

import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: false);

    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '카드뒤집기',
                textAlign: TextAlign.center,
                style: TextStyles.titleText,
              ),
              // Container(
              //   width: 120,
              //   height: 120,
              //   decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/default_icon.png'))),
              // ),
              Expanded(
                child: GestureDetector(
                  child: Hero(
                    tag: 'default_icon',
                    child: Image.asset(
                      'assets/images/default_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(), fullscreenDialog: true),
                    );
                  },
                ),
              ),
              Text('', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
