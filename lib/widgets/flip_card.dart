import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_game/providers/card_provider.dart';

final counterProvider = StateProvider((ref) => 0);

class FlipCard extends ConsumerWidget {
  const FlipCard({
    Key? key,
    required this.cardModel,
  }) : super(key: key);

  final CardModel cardModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var watch = ref.watch(cardProvider.notifier);


    return GestureDetector(
      onTap: () => print('${cardModel.displayName}, ${cardModel.pairId}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: Center(
          child: Text(cardModel.displayName),
        ),
      ),
    );
  }
}
