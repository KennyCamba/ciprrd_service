import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {

  static final primary = Color(0xFF00B4C1);
  static final app_theme = MaterialColor(
      0xFF00B4C1,
      <int, Color>{
        50: Color(0xFFFFFFFF),
        100: Color(0xFFF7F7FA),
        200: Color(0xFFF7F6FF),
        300: Color(0xFF80DAE0),
        400: Color(0xFF00B4C1), //primary
        500: Color(0xFF00B4C1),
        600: Color(0xFF035B62),
        700: Color(0xFF3D4255),
        800: Color(0xFF2A2E43),
        900: Color(0xFF000000)
    }
  );


  AppColors();
}