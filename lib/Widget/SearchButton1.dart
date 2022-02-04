import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget SearchButton1(BuildContext context, String _hintText,
    TextEditingController _keywordController, var _onSearch, var _clearSearch) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: 50,
    child: TextField(
        controller: _keywordController,
        // style: TextStyle(color: Color(0xff545C6C), fontSize: 14),
        style: TextStyle(color: Color(0xff545C6C), fontSize: 14),
        decoration: InputDecoration(
            // border: InputBorder,

            hintStyle: TextStyle(color: Color(0xff848A95), fontSize: 14),
            hintText: _hintText,
            contentPadding: EdgeInsets.only(top: 17.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffE4E5E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffE4E5E7)),
            ),
            // suffixIcon: GestureDetector(
            //   onTap: _clearSearch,
            //   child: Icon(
            //     Icons.clear,
            //     size: 24,
            //     color: Colors.white,
            //   ),
            // ),
            prefixIcon: GestureDetector(
              onTap: _onSearch,
              child: Icon(
                Icons.search,
                size: 18,
                color: Color(0xff545C6C),
              ),
            ))),
  );
}
