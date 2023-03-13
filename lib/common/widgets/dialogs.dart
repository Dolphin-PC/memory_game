import 'package:flutter/material.dart';

class Dialogs {
  static confirmDialog({
    required BuildContext context,
    required String contentText,
    required String succBtnName,
    String cancelBtnName = "취소",
    required Function succFn,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          content: Text(contentText),
          actions: [
            TextButton(
              child: Text(cancelBtnName),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(succBtnName),
              onPressed: () {
                succFn();
                // Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
          content: Text(contentText),
          actions: [
            TextButton(
              child: Text(succBtnName),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
