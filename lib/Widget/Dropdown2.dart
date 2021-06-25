import 'package:flutter/material.dart';

Widget dropDown2(
    var _value, String _hint, List _listItem, var _onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
    child: Container(
      width: double.infinity,
      child: DropdownButton(
          value: _value == "" ? null : _value,
          onChanged: _onChanged,
          hint: Text(_hint),
          items: _listItem.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList()),
    ),
  );
}
