import 'package:flutter/material.dart';

import 'CustomText.dart';

Widget ListDataIKMWidget(BuildContext context, String _label, String _value) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 30),
          width: 150,
          child: customText(context, Colors.black26, _label, TextAlign.left, 18,
              FontWeight.w500),
        ),
        Flexible(
          child: customText(context, Colors.black, _value, TextAlign.left, 18,
              FontWeight.w500),
        )
      ],
    ),
  );
}
