import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget listLabel(BuildContext context, String _label, String _value,var _onTap) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.62,
              child: textLabel(_label, 11, themeProvider.fontColor1,
                  themeProvider.fontFamily, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0, bottom: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textLabel(_value, 12, Colors.black, themeProvider.fontFamily,
                      FontWeight.normal),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 12,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
