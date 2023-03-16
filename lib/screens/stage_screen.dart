import 'package:card_memory_game/common/util.dart';
import 'package:card_memory_game/providers/stage_provider.dart';
import 'package:card_memory_game/styles/color_styles.dart';
import 'package:card_memory_game/widgets/point_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({Key? key}) : super(key: key);

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  late StageProvider stageProvider;

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {
      await stageProvider.initStageInfo();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    stageProvider = Provider.of(context, listen: true);

    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 포인트 위젯
              const PointWidget(),

              /// 스테이지 선택
              Visibility(
                visible: stageProvider.isInitStageInfo,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('현재 스테이지 정보 : ${stageProvider.currentStage} / ${stageProvider.currentRound}'),
                      ListView.separated(
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: 50,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Text('$index'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// 하단 [뒤로가기] 버튼
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: ColorStyles.borderColor, size: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
