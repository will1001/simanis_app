import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';

Widget dropDown2Style2(BuildContext context, var _value, String _hint,
    String _title, List _listItem, var _onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: customText(context, Color(0xFF7D6E6E), _title, TextAlign.left,
            12, FontWeight.w400),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // width: 100,
        // height: 50,
        child: DropdownButtonFormField(
            decoration: InputDecoration(
                hintText: "Pilih",
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(6.0),
                  ),
                )),
            value: _value == "" ? null : _value,
            isExpanded: true,
            onChanged: _onChanged,
            items: _listItem.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList()),
      ),
    ],
  );
}
