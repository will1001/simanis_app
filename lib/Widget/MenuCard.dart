import 'package:flutter/material.dart';

import 'CustomText.dart';

Widget menuCard(BuildContext context, String _text, String _icon,var _ontap) {
  return Padding(
    padding: const EdgeInsets.only(top: 21.0),
    child: GestureDetector(
      onTap: _ontap,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: 197,
            height: 61,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customText(context, Colors.black, _text, TextAlign.left, 14,
                      FontWeight.w500)
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 160),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset(
                  _icon,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
