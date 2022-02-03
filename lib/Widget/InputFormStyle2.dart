import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget inputFormStyle2(
    String _icon,
    String _hintText,
    String _keyboardType,
    String _labelText,
    String validatorMessage,
    TextEditingController _controller,
    bool _obscureText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    child: TextFormField(
      keyboardType:
          _keyboardType == "number" ? TextInputType.number : TextInputType.text,
      controller: _controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 9),
          child: Image.asset(
            _icon,
            width: 30,
            height: 30,
          ),
        ),
        hintText: _hintText,
        labelStyle: TextStyle(color: Color(0xffB8B8B8)),
        labelText: _labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    ),
  );
}
