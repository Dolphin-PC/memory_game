import 'package:card_memory_game/models/point_history_model.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PointHistoryScreen extends StatelessWidget {
  const PointHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PointProvider pointProvider = Provider.of(context, listen: false);
    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      appBar: AppBar(
        title: const Text("포인트 이력"),
        backgroundColor: ColorStyles.bgPrimaryColor,
        foregroundColor: ColorStyles.borderColor,
      ),
      body: FutureBuilder(
        future: pointProvider.selectList(),
        builder: (BuildContext context, AsyncSnapshot<List<PointHistoryModel>> snapshot) {
          if (!snapshot.hasData) return const Text("loading...");

          List<PointHistoryModel> list = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('${list[index].pointMemo} / ${list[index].pointCnt} 츄르'),
                subtitle: Text(formatDate(list[index].regDate ?? DateTime.now())),
              );
            },
          );
        },
      ),
    );
  }

  String formatDate(DateTime regDate) {
    String format = DateFormat("yyyy-MM-dd HH:mm:ss").format(regDate);
    List<String> reg = format.split(" ");
    List<String> date = reg[0].split("-");
    List<String> time = reg[1].split(":");
    return '${date[0]}-${date[1]}-${date[2]} ${time[0]}:${time[1]}:${time[2]}';
  }
}
