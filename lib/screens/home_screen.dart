import 'package:card_memory_game/ads/ad_banner.dart';
import 'package:card_memory_game/screens/setting_screen.dart';
import 'package:card_memory_game/widgets/point_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PointWidget(),
                  IconButton(
                    color: ColorStyles.borderColor,
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingScreen()),
                      );
                    },
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Hero(
                        tag: 'default',
                        child: Image.asset(
                          'assets/images/default.png',
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
                    Text(
                      '카드뒤집기게임에 온 걸 환영한다냥\n시작하려면 날 눌러라냥',
                      textAlign: TextAlign.center,
                      style: TextStyles.cardText,
                    ),
                  ],
                ),
              ),
              const AdBanner()
            ],
          ),
        ),
      ),
    );
  }
}
