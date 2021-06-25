import 'package:flutter/material.dart';

Widget gradientBg() {
  return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFFA0D7E7),
    ],
  )));
}
