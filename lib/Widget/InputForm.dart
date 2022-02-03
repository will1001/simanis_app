import 'package:flutter/material.dart';

Widget inputForm(
    var _icon,
    String _hintText,
    String _keyboardType,
    String _labelText,
    String validatorMessage,
    TextEditingController _controller,
    bool _obscureText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextFormField(
      keyboardType:
          _keyboardType == "number" ? TextInputType.number : TextInputType.text,
      controller: _controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        icon: _icon,
        hintText: _hintText,
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
