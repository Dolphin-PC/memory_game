import 'package:card_memory_game/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static show({required String msg}) {
    close();
    return Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: ColorStyles.borderColor, textColor: Colors.white, fontSize: 16.0);
  }

  static close() {
    return Fluttertoast.cancel();
  }
}
