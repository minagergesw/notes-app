import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Style {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: Color(0xffEDF9FC),
      primaryColorDark: Colors.deepOrange,
      cardColor: Color.fromARGB(255, 249, 211, 189),
      brightness: Brightness.light,
       textTheme:
         TextTheme(
      headline1: TextStyle(color: Colors.black87.withOpacity(0.6)),
      headline2: TextStyle(color: Colors.black87.withOpacity(0.6)),
      bodyText2: TextStyle(color: Colors.black87.withOpacity(0.6)),
      subtitle1: TextStyle(color: Colors.black87.withOpacity(0.6)),
    ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Colors.black45,
        cardColor: Colors.grey.shade900,
        primarySwatch: Colors.deepPurple,
        primaryColorDark: Color.fromARGB(255, 124, 66, 223),
        brightness: Brightness.dark);
  }
}
