import 'package:flutter/material.dart';
import 'dart:math' as math;


Widget dropDownStringStyle2(var _value, String _hint, List _listItem,
    Color _colorBorder, var _onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    child: Container(
      padding: EdgeInsets.all(8),
      height: 46,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: 1, color: _colorBorder)),
      width: double.infinity,
      child: DropdownButton(
          underline: Container(),
          icon: Transform.rotate(
              angle: -90 * math.pi / 180,
              child: Icon(
                Icons.chevron_left,
                size: 21,
                color: Color(0xff545C6C),
              )),
          dropdownColor: Colors.white,
          isExpanded: true,
          value: _value == "" ? null : _value,
          onChanged: _onChanged,
          hint: Text(
            _hint,
            style: TextStyle(color: Color(0xffB2B5BC)),
          ),
          items: _listItem.map((item) {
            return DropdownMenuItem(
              value: item["id"],
              child: Text(item["name"]),
            );
          }).toList()),
    ),
  );
}
