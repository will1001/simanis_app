import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AlertButton(String _text,Color _color,var _leadingIcon,var _onpressed,BuildContext _context) {
  return ButtonTheme(
    minWidth: 20,
    height: 33.0,
    child: ElevatedButton(
      child: Text(_text,style: TextStyle(color: Colors.white),),
      onPressed: _onpressed,
      style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                    side: BorderSide(color: _color)))),
      ),
  );
}
