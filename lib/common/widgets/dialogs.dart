import 'package:card_memory_game/styles/button_styles.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static confirmDialog({
    required BuildContext context,
    String titleText = "제목",
    String succBtnName = "확인",
    required Function succFn,
    String cancelBtnName = "취소",
    required Widget contentWidget,
  }) {
    return customDialog(
      succFn,
      context: context,
      titleText: titleText,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentWidget,
        ],
      ),
      succBtnName: succBtnName,
      cancelBtnName: cancelBtnName,
    );
  }

  static defaultDialog({
    required BuildContext context,
    required String contentText,
    required String succBtnName,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          content: Text(contentText, style: TextStyles.plainTexts(15), textAlign: TextAlign.center),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButtonStyles.positive,
              child: Text(succBtnName),
            ),
          ],
        );
      },
    );
  }

  static customDialog(
    Function? succFn, {
    required BuildContext context,
    String titleText = "제목",
    required Widget contentWidget,
    String succBtnName = "확인",
    String cancelBtnName = "취소",
  }) {
    return showDialog(
      context: context,
      builder: (build) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(titleText, textAlign: TextAlign.center),
          contentPadding: EdgeInsets.zero,
          content: contentWidget,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButtonStyles.negative,
              child: Text(cancelBtnName),
            ),
            ElevatedButton(
              onPressed: () {
                if (succFn != null) {
                  succFn();
                }
                Navigator.pop(context);
              },
              style: ElevatedButtonStyles.positive,
              child: Text(succBtnName),
            ),
          ],
        );
      },
    );
  }
}
