import 'package:flutter/material.dart';

class GameItems extends StatefulWidget {
  const GameItems({Key? key}) : super(key: key);

  @override
  State<GameItems> createState() => _GameItemState();
}

class _GameItemState extends State<GameItems> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.volunteer_activism),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.done_all),
          onPressed: () {},
        ),
      ],
    );
  }
}
