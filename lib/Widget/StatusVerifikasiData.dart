import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget statusVerifikasiData(BuildContext context, String _status,String _catatanVerifikasi) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textLabel("Status Verifikasi Data", 12, Colors.black,
                themeProvider.fontFamily, FontWeight.normal),
            Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: _status == "Belum diverifikasi"
                      ? Colors.grey
                      : Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: textLabel(_status, 9, Colors.white,
                  themeProvider.fontFamily, FontWeight.bold),
            ),
          ],
        ),
        textLabel("Catatan Verifikasi", 12, Colors.black,
            themeProvider.fontFamily, FontWeight.normal),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: EdgeInsets.all(8),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: themeProvider.bgColor,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Text(_catatanVerifikasi),
          ),
        )
      ],
    ),
  );
}
