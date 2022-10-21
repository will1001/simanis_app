import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget customText(BuildContext context, Color _fontColor, String _text,
    TextAlign _textAlign, double _fontSize, FontWeight _fontWeight) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return Text(
    _text,
    textAlign: _textAlign,
    softWrap: false,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontSize: _fontSize,
        fontWeight: _fontWeight,
        color: _fontColor,
        letterSpacing: 0.5),
  );
}
