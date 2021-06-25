import 'package:flutter/material.dart';

Widget textLabel(String _text, double _fontSize, Color _fontColor,
    String _fontFamily, FontWeight _fontWeight) {
  return Text(_text,
      style: TextStyle(
          fontSize: _fontSize,
          fontFamily: _fontFamily == "" ? "Roboto" : _fontFamily,
          fontWeight: _fontWeight,
          color: _fontColor));
}
