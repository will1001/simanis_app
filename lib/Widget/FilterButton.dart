import 'package:flutter/material.dart';

import 'CustomText.dart';

Widget filterButton(BuildContext context, String _text,String _selected,var _onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 10.0),
    child: GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            border: Border.all(color: (_selected == _text?Colors.black:Color(0xffB7B1B1)))),
        child: customText(
            context, (_selected == _text?Colors.black:Color(0xffB7B1B1)), _text, TextAlign.left, 11, FontWeight.w400),
      ),
    ),
  );
}
