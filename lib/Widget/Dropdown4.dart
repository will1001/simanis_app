import 'package:flutter/material.dart';

Widget dropDown4(var _value, String _param, String _Idparam, String _hint,
    List _listItem, Color _colorBorder, var _onChanged) {
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
          value: _value == "" ? null : _value,
          onChanged: _onChanged,
          isExpanded: true,
          hint: Text(
            _hint,
            style: TextStyle(color: Color(0xffB2B5BC)),
          ),
          items: _listItem.map((item) {
            return DropdownMenuItem(
              value: (_param == "" ? item : item[_Idparam]),
              child: Text((_param == "" ? item : item[_param])),
            );
          }).toList()),
    ),
  );
}
