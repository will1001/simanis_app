import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget cardMenu(
    String _title, IconData _icon, BuildContext context, var _onTap) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: _onTap,
      child: Card(
        elevation: 9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  _icon,
                  color: themeProvider.iconColor,
                  size: 35,
                ),
              ),
              textLabel(_title, 14, Colors.black, themeProvider.fontFamily,
                  FontWeight.normal)
            ],
          ),
        ),
      ),
    ),
  );
}
