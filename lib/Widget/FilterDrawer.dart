import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget filterDrawer(BuildContext context, List<Widget> _listWidget) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.only(left: 24, top: 40),
      children: _listWidget,
    ),
  );
}
