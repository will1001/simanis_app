import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';

Widget ButtonGradient1(BuildContext context,String _text,double _fontSize,var _onTap) {
  return GestureDetector(
    onTap: _onTap,
    child: Container(
      width: 91,
      height: 31,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff46ACD5),
              Color(0xFF4A0BFB),
            ],
          )),
      child: Center(
        child: customText(context, Colors.white, _text, TextAlign.left,
            _fontSize, FontWeight.w500),
      ),
    ),
  );
}
