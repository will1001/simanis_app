import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/Dropdown3.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'CustomText.dart';

CRUD crud = new CRUD();
Widget _inputFormType = Container();
DateTime selectedDate = DateTime.now();

dateFormat(String date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(DateTime.parse(date));
  return formatted.substring(6, 10);
}

Widget editDialogBox(
    BuildContext context,
    String? _idUser,
    String _type,
    String _namaTabel,
    String _redirectTo,
    String _param,
    String _paramDropdown,
    String _content,
    String _hintText,
    String _labelText,
    String _dropDownValue,
    String _dateValue,
    TextEditingController _controller,
    List _dropDownListItem,
    String _keyboardType,
    var _dropDownOnChanged,
    var _dateOnChanged,
    var _onPressed) {
  if (_type == "dropDown") {
    _inputFormType = dropDown3(_dropDownValue, _paramDropdown, _hintText,
        _dropDownListItem, _dropDownOnChanged);
  } else if (_type == "date") {
    _inputFormType = GestureDetector(
        onTap: _dateOnChanged,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "$_labelText ${_dateValue == "" ? "" : dateFormat((_dateValue))}"),
              Icon(Icons.calendar_today)
            ],
          ),
        ));
  } else {
    _inputFormType = inputForm(
        null, _hintText, _keyboardType, _labelText, "", _controller, false);
  }
  ;
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Scaffold(
    appBar: AppBar(
      title: customText(context, Color(0xff242F43), 'Edit Profil',
          TextAlign.left, 20, FontWeight.w600),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left)),
      iconTheme: IconThemeData(color: Color(0xff242F43)),
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    body: ListView(
      children: [
        _inputFormType,
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child:
              button2("Simpan", Color(0xff2BA33A), Colors.white, context, () {
            Map<String, String> data = {};
            if (_type == "dropDown") {
              data = {_param: "$_dropDownValue"};
            } else if (_type == "date") {
              data = {_param: "$_dateValue"};
            } else {
              data = {_param: "${_controller.text}"};
            }
            // print('/badan_usaha/${_param}/${_idUser}');
            // print('/${_namaTabel}/${_param}/${_idUser}');
            // print(data);
            // print(_dropDownValue);
            // print(_type);
            crud.putData('/${_namaTabel}/${_param}/${_idUser}', data);
            // Navigator.pop(context);
            Navigator.popAndPushNamed(context, '/${_redirectTo}');
          }),
        )
      ],
    ),
  );
}
