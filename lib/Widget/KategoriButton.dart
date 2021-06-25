import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget kategoriButton(BuildContext context, String _title, String _kategori,var _onTap) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return GestureDetector(
    onTap: _onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        height: 10,
        child: Card(
            color: _kategori == _title ? Colors.white : Colors.transparent,
            elevation: _kategori == _title ? 4 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: textLabel(
                  _title,
                  14,
                  _kategori == _title ? themeProvider.fontColor1 : themeProvider.fontColor2,
                  themeProvider.fontFamily,
                  _kategori == _title ? FontWeight.w600 : FontWeight.normal),
            )),
      ),
    ),
  );
}
