import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CustomText.dart';

Widget statusVerifikasiData(
    BuildContext context, String _status, String _catatanVerifikasi) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      width: 120,
      // height: 30,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: _status == "Belum diverifikasi"
              ? Color(0xffFFF4F2)
              : Color(0xffEBFFEB),
          border: Border.all(
              width: 1,
              color: _status == "Belum diverifikasi"
                  ? Color(0xffEEB3B0)
                  : Color(0xff96D698)),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: customText(context, Color(0xff2BA33A), _status, TextAlign.left, 10,
          FontWeight.w500),
    ),
  );
}
