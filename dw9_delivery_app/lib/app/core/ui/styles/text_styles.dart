import "package:flutter/material.dart";

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  String get font => "mplus1";

  TextStyle get textLight => TextStyle(fontWeight: FontWeight.w300, fontFamily: this.font);

  TextStyle get textRegular => TextStyle(fontWeight: FontWeight.normal, fontFamily: this.font);

  TextStyle get textMedium => TextStyle(fontWeight: FontWeight.w500, fontFamily: this.font);

  TextStyle get textSemiBold => TextStyle(fontWeight: FontWeight.w600, fontFamily: this.font);

  TextStyle get textBold => TextStyle(fontWeight: FontWeight.bold, fontFamily: this.font);

  TextStyle get textExtraBold => TextStyle(fontWeight: FontWeight.w800, fontFamily: this.font);

  TextStyle get textButtonLabel => this.textBold.copyWith(fontSize: 14);

  TextStyle get textTitle => this.textExtraBold.copyWith(fontSize: 28);
}

extension TextStylesExtensions on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}