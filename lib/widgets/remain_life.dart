import 'package:flutter/material.dart';

class RemainLife extends StatelessWidget {
  const RemainLife({Key? key, required this.life}) : super(key: key);

  final int life;
  final int maxLife = 3;

  @override
  Widget build(BuildContext context) {
    List<IconButton> getHeartWidget() {
      List<int> list = [];
      for (int i = 1; i <= maxLife; i++) {
        if (life >= i) {
          list.add(1);
        } else {
          list.add(0);
        }
      }

      return list.map((item) {
        if (item == 1) {
          return IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          );
        }
        return IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {},
        );
      }).toList();
    }

    return Row(children: getHeartWidget());
  }
}
