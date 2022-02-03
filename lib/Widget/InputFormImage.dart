import 'dart:io';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget inputFormImage(
    BuildContext context,
    String _label,
    String _value,
    String? _imgLink,
    File? _imgFile,
    var _galeryIconOnTap,
    var _photoIconOnTap) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  // print("_imgLink");
  // print("null = ${_imgLink == null}");
  // print("empty = ${_imgLink == ""}");
  // print(_imgLink);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black))),
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
                    textLabel(_value, 12, Colors.black,
                        themeProvider.fontFamily, FontWeight.normal),
                    Row(
                      children: [
                        IconButton(
                            onPressed: _galeryIconOnTap,
                            icon: Icon(
                              Icons.image_outlined,
                              size: 24,
                            )),
                        IconButton(
                            onPressed: _photoIconOnTap,
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              size: 24,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // _imgLink == ""?
        Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _imgLink == "" ||
                    _imgLink == null ||
                    _imgLink == "https://simanis.ntbprov.go.id/storage/"
                ? (_imgFile == null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            color: themeProvider.bgColor,
                          ),
                          Icon(Icons.image_outlined,
                              size: 24, color: Colors.grey.shade500)
                        ],
                      )
                    : Image.file(_imgFile))
                : Image.network(_imgLink))
      ],
    ),
  );
}
