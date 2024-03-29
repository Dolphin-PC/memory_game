import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_styles.dart';

class TextStyles {
  static TextStyle get titleText => GoogleFonts.nanumBrushScript(color: ColorStyles.textColor, fontSize: 50, fontWeight: FontWeight.w700);
  static TextStyle get cardText => GoogleFonts.nanumBrushScript(color: ColorStyles.borderColor, fontSize: 25, fontWeight: FontWeight.w400);
  static TextStyle get plainText => GoogleFonts.nanumGothic(color: ColorStyles.borderColor, fontSize: 15, fontWeight: FontWeight.w400);
  static TextStyle get labelText => GoogleFonts.nanumGothic(color: ColorStyles.borderColor, fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle get buttonText => GoogleFonts.nanumGothic(color: ColorStyles.borderColor, fontSize: 15, fontWeight: FontWeight.w400);

  static TextStyle plainTexts([double fontSize = 15]) {
    return GoogleFonts.nanumGothic(color: ColorStyles.borderColor, fontSize: fontSize, fontWeight: FontWeight.w400);
  }
}
