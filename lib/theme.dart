import 'package:flutter/material.dart';

class ChampagneTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xffF1F1F1),
        primaryColor: Color(0xff69A8BB),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff69A8BB)),
        textTheme: const TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xff363B3F),
              fontSize: 32,
            ),
            headline2: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xff363B3F),
                fontSize: 18)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 83, 126, 139)))),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff69A8BB)))),
        inputDecorationTheme: const InputDecorationTheme(
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.fromLTRB(16, 16, 0, 16),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff69A8BB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffCACED0)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff69A8BB),
              ),
            ),
            labelStyle: TextStyle(color: Color(0xffCACED0)),
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xffCACED0))));
  }
}
