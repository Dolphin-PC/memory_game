import 'package:card_memory_game/common/util.dart';
import 'package:card_memory_game/common/widgets/toasts.dart';
import 'package:card_memory_game/models/stage_info_model.dart';
import 'package:card_memory_game/providers/stage_provider.dart';
import 'package:card_memory_game/screens/game_screen.dart';
import 'package:card_memory_game/styles/color_styles.dart';
import 'package:card_memory_game/styles/text_styles.dart';
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

    Widget stageCard({required StageInfoModel stage}) {
      return GestureDetector(
        onTap: () {
          if (stage.isLock) {
            Toasts.show(msg: "이전 스테이지 클리어가 필요하다냥");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameScreen(
                        stageInfoModel: stage,
                      )),
            );
          }
        },
        child: Card(
          elevation: 4,
          child: Container(
            width: 100,
            height: 100,
            color: ColorStyles.bgSecondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: stage.isLock,
                  child: Column(
                    children: [
                      const Icon(Icons.lock_outline),
                      Text(
                        textAlign: TextAlign.center,
                        '${stage.stageIdx}-${stage.roundIdx - 1}\n Clear 필요',
                        style: TextStyles.plainText,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !stage.isLock,
                  child: Text(
                    '${stage.stageIdx + 1} X ${stage.roundIdx}',
                    style: TextStyles.cardText,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

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
                      // Text('현재 스테이지 정보 : ${stageProvider.currentStage} / ${stageProvider.currentRound}'),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: FutureBuilder(
                              future: stageProvider.selectList(),
                              builder: (_, AsyncSnapshot<List<StageInfoModel>> snapshot) {
                                if (!snapshot.hasData) return Text('loading...');

                                List<StageInfoModel> list = snapshot.data!;

                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                  itemCount: stageProvider.maxStage,
                                  itemBuilder: (context, indexStage) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'STAGE ${indexStage + 1}',
                                          style: TextStyles.cardText,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          child: ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: stageProvider.maxRound,
                                            itemBuilder: (_, indexRound) {
                                              return SizedBox(
                                                width: 100,
                                                child: stageCard(
                                                  stage: list[indexStage * 10 + indexRound],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }),
                        ),
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
