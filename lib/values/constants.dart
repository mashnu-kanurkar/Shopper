import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor purple = MaterialColor(
    0xFF55157A, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffac51e1 ),//10%
      100: Color(0xff9825da),//20%
      200: Color(0xff8821c4),//30%
      300: Color(0xff791eae),//40%
      400: Color(0xff6a1a99),//50%
      500: Color(0xff5b1683),//60%
      600: Color(0xff55157a),//70%
      700: Color(0xff4c126d),//80%
      800: Color(0xff2d0b41),//90%
      900: Color(0xff1e072c),//100%
    },
  );}


  class WidgetColors{
  static const disabled_button = Color(0xFFD79EF9);
  static const enabled_button = Color(0xFF2F0245);
  static const disabled_button_text = Color(0xFF433B49);
  static const enabled_button_text = Color(0xFFFFFFFF);
  static const error_text = Color(0xFF950404);
  static const disabled_text = Color(0xFF543978);
  static const enabled_text = Color(0xFF000000);
  static const snackbar_bg = Color(0xFFDB16D4);
  static const primary = Color(0xFF55157A);
  static const secondary = Color(0xFFFFFFFF);
}

class Constants{
  static const int otpTimeout = 60;
  static const sized_box_base_height = 2.0;
  static const sized_box_seperator_height = 12.0;
  static const sized_box_base_width = 2.0;
  static const sized_box_seperator_width = 12.0;
  static const btn_border_radius = 16.0;
  static const btn_text_padding = 16.0;
  static const btn_min_height = 12.0;
  static const text_field_margin = 16.0;
  static const base_margin = 12.0;
  static const base_padding = 8.0;

}

class StaticImages{
  static const background = "assets/images/background.png";
  static const big_logo = "assets/images/big_logo.jpeg";
  static const bird = "assets/images/bird.png";
  static const error = "assets/images/error.png";
  static const profile_placeholder = "assets/images/profile_placeholder.png";
}


enum RwOrientation{ VERTICAL, HORIZONTAL}