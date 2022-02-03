import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';

Widget dataCardMenu(BuildContext context, String _icon, String _text,
    String _jmlUmkm, var _onpressed) {
  return GestureDetector(
    onTap: _onpressed,
    child: Container(
      width: 207,
      height: 90,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  child: customText(context, Colors.black, _text,
                      TextAlign.left, 14, FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: customText(context, Colors.grey, _jmlUmkm,
                      TextAlign.left, 14, FontWeight.w700),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
