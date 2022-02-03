import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonStyle1(BuildContext context, String _text,Color _colors,var _onTap) {
  return Container(
    color: _colors,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _onTap,
        child: Text(_text,style: GoogleFonts.poppins(),)),
    ),
  );
}
