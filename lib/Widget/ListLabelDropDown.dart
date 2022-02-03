import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'CustomText.dart';

Widget ListLabelDropDown(
    BuildContext context, String _title, var _param, var _onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 24),
        child: customText(context, Color(0xff242F43), _title, TextAlign.left,
            14, FontWeight.w400),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 4, right: 16),
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: Color(0xffE4E5E7))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(context, Color(0xff242F43), _param, TextAlign.left,
                    14, FontWeight.w500),
                Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: Icon(
                      Icons.chevron_left,
                      color: Color(0xff545C6C),
                      size: 17,
                    ))
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
