import 'package:flutter/material.dart';

import 'CustomText.dart';

Widget listLabel2(BuildContext context, String _txt) {
  return Padding(
    padding: const EdgeInsets.only(left: 14.0, top: 7, bottom: 7),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: customText(context, Color(0xff727986), _txt, TextAlign.left,
              14, FontWeight.w400),
        ),
      ],
    ),
  );
}
