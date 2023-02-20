import 'package:flutter/material.dart';

class Util {
  static void execAfterBinding(Function fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn();
    });
  }
}
