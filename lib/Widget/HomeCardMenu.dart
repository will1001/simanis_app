import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';

Widget homeCardMenu(BuildContext context, String _icon, String _text,var _onTap) {
  return Container(
    width: 150,
    height: 100,
    child: GestureDetector(
      onTap: _onTap,
      child: Card(
        elevation: 9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 11.0),
              child: Image.asset(
                _icon,
                width: 30,
                height: 30,
              ),
            ),
            Container(
              width: 70,
              child: customText(context, Colors.black, _text, TextAlign.left, 14,
                  FontWeight.w700),
            )
          ],
        ),
      ),
    ),
  );
}
