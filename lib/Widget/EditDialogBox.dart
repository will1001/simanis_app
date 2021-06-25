import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Dropdown3.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

CRUD crud = new CRUD();

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
    TextEditingController _controller,
    List _dropDownListItem,
    var _dropDownOnChanged,
    var _onPressed) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: _onPressed, icon: Icon(Icons.arrow_back)),
      title: textLabel(_content, 15, Colors.black, "", FontWeight.w400),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    body: ListView(
      children: [
        _type == "dropDown"
            ? dropDown3(_dropDownValue, _paramDropdown, _hintText,
                _dropDownListItem, _dropDownOnChanged)
            : inputForm(null, _hintText, _labelText, "", _controller, false),
        button1("Simpan", themeProvider.fontColor1, context, () {
          Map<String, String> data = {
            _param: _type == "dropDown" ? _dropDownValue : _controller.text
          };
          print('/badan_usaha/${_param}/${_idUser}');
          print(data);
          // print(_dropDownValue);
          // print(_type);
          crud.putData('/${_namaTabel}/${_param}/${_idUser}', data);
          // Navigator.pop(context);
          Navigator.popAndPushNamed(context, '/${_redirectTo}');
        })
      ],
    ),
  );
}
