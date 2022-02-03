import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cardProdukHome(BuildContext context, String _img, String _txt) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8),
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Stack(
          children: [
            Image.network(
              _img,
            width: 220,
              height: 109,
              fit: BoxFit.fill,
            ),
            Opacity(
              opacity: 0.35,
              child: Container(
                color: Colors.black,
                width: 220,
                height: 109,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 11.0, bottom: 6, right: 11),
          child: Container(
            width: 200,
            child: customText(context, Colors.white, _txt, TextAlign.left, 14,
                FontWeight.w700),
          ),
        )
      ],
    ),
  );
}
