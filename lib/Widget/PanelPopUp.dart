import 'package:flutter/material.dart';

import 'ButtonStyle1.dart';
import 'CustomText.dart';

Widget panelPopUp(BuildContext context, String _text,var _yaPressed,var _noPressed) {
  return Container(
    color: Colors.black26,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Center(
      child: Container(
        color: Colors.white,
        width: 312,
        height: 138,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: customText(
                  context,Colors.black, _text, TextAlign.center, 16, FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // buttonStyle1(context, 'Ya', Color(0xFFF6F5FF), _yaPressed),
                Container(),
                buttonStyle1(context, 'Close', Color(0xFFF6F5FF), _noPressed),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
