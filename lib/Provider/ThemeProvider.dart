import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color bgColor = Color(0xFFE5EEFB);
  Color bgColor2 = Color(0xFFA0D7E7);
  Color buttonColor = Color(0xFF0049C6);
  Color iconColor = Color(0xFF4976C5);
  Color fontColor1 = Color(0xFF133A66);
  Color fontColor2 = Color(0xFF878C92);
  Color fontColorWhite = Colors.white;
  String fontFamily = "Roboto";

  // void changeThemeColor(Color color) {
  //   mainColor = color;
  //   notifyListeners();
  // }
}
