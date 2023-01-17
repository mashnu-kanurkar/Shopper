import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/values/constants.dart';

ThemeData themeData_light = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,
  primarySwatch: Palette.purple,
  //primarySwatch: Colors.teal[400],
    scaffoldBackgroundColor: WidgetColors.secondary,

  // Define the default font family.

  fontFamily: 'Raleway',
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,),
    bodyText1: TextStyle(fontSize: 16.0, color: WidgetColors.enabled_text),
    bodyText2: TextStyle(fontSize: 12.0, color: WidgetColors.enabled_text),
  ),


  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  // textTheme: const TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  // ),
);
