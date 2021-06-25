import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget searchInput(BuildContext context) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Material(
      elevation: 9,
      borderRadius: BorderRadius.all(
        const Radius.circular(20.0),
      ),
      child: TextField(
          decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Cari Produk",
        contentPadding: EdgeInsets.all(20.0),
        suffixIcon: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: themeProvider.bgColor2,
                  borderRadius: BorderRadius.circular(50)),
            ),
            Icon(
              Icons.search,
              size: 14,
              color: Colors.white,
            )
          ],
        ),
      )),
    ),
  );
}
