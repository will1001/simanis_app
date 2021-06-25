import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget drawerMenu(BuildContext context) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            // border: BoxBorder(),
            color: themeProvider.bgColor,
          ),
          child: Center(
              child: Image.asset(
            'assets/images/logo.png',
            width: 220,
          )),
        ),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text('Log Out'),
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.clear();
            Navigator.pushNamed(context, '/homeLayoutPage');
          },
        ),
        // ListTile(
        //   title: Text('Item 2'),
        //   onTap: () {
        //     // Update the state of the app.
        //     // ...
        //   },
        // ),
      ],
    ),
  );
}
