import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AlertDialogBox(String _title,String _content,List<Widget> _action) {
  return AlertDialog(
    title: Text(_title),
    content: Text(_content),
    actions: _action,
  );
}
