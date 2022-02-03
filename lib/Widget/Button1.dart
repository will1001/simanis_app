import 'package:flutter/material.dart';

Widget button1(
    String _text, Color _buttonColor, BuildContext _context, var _onPressed) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: _buttonColor, padding: EdgeInsets.symmetric(vertical: 15)),
      onPressed: _onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_text),
      ),
    ),
  );
}
