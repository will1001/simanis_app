import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget searchInput(BuildContext context, String _hintText,
    TextEditingController _keywordController, var _onSearch, var _clearSearch) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Material(
      elevation: 9,
      borderRadius: BorderRadius.all(
        const Radius.circular(20.0),
      ),
      child: TextField(
          controller: _keywordController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _hintText,
            contentPadding: EdgeInsets.all(20.0),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _keywordController.text == ""
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: _clearSearch,
                            child: Icon(
                              Icons.clear,
                              size: 24,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: themeProvider.bgColor2,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      GestureDetector(
                        onTap: _onSearch,
                        child: Icon(
                          Icons.search,
                          size: 14,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    ),
  );
}
