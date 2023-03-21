import 'package:flutter/material.dart';

class ButtonStyles {
  static defaultButton() {

  }
}

class ElevatedButtonStyles {
  static get negative => ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  static get positive => ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
}