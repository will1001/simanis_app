import 'package:flutter/material.dart';

Widget loadingWidget(BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black12,
      ),
      Container(
        width: 100,
        height: 100,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
    ],
  );
}
