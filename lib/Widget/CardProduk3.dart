import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';

Widget cardProduk3(BuildContext context, String _namaProduk, String? _foto) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          _foto!,
          width: 120,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8),
        child: Container(
          width: 120,
          child: customText(context, Color(0xff545C6C), _namaProduk,
              TextAlign.left, 14, FontWeight.w400),
        ),
      )
    ],
  );
}
