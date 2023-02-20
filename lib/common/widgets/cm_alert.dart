import 'package:flutter/material.dart';

class CmAlert extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String? msg;
  final Widget? msgWidget;
  final Function fn;
  final Map<String, Function> btnList;

  // List<Function> btnList;

  const CmAlert({
    Key? key,
    required this.context,
    required this.title,
    this.msg,
    this.msgWidget,
    required this.fn,
    required this.btnList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: msgWidget ?? Text(msg ?? ''),
      actions: btnList.isEmpty
          ? <Widget>[
              ElevatedButton(
                child: const Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                  fn();
                },
              )
            ]
          : btnList.entries.map(
              (e) {
                return ElevatedButton(
                  child: Text(e.key),
                  onPressed: () {
                    e.value();
                  },
                );
              },
            ).toList(),
    );
  }
}
