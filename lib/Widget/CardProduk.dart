import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget cardProduk(String _namaProduk, String _namaIKM, String? _photoProduk,
    BuildContext context, var _onTap) {
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
             _photoProduk == null || _photoProduk == ""? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: themeProvider.bgColor,
              ),
              Icon(Icons.image_outlined, size: 24, color: Colors.grey.shade500)
            ],
          ): Center(
                child: Container(
                  height: 100,
                  child: Image.network(_photoProduk),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: textLabel(_namaProduk, 12, Colors.black,
                    themeProvider.fontFamily, FontWeight.normal),
              ),
              textLabel(_namaIKM, 12, Colors.grey, themeProvider.fontFamily,
                  FontWeight.normal)
            ],
          ),
        ),
      ),
    ),
  );
}
