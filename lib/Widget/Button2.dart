import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget button2(String _text, Color _buttonColor, Color _textColor,
    BuildContext _context, var _onPressed) {
  return Container(
    height: 46,
    width: MediaQuery.of(_context).size.width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: _buttonColor, padding: EdgeInsets.symmetric(vertical: 8)),
      onPressed: _onPressed,
      child: Text(
        _text,
        style: GoogleFonts.poppins(
            color: _textColor, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
