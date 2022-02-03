import 'package:appsimanis/Pages/ListDataIKM.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TextLabel.dart';

Widget StatistikBox(
    BuildContext context,
    String id,
    String _title,
    String _data,
    var _onTap,
    var _onTap2,
    String _showSubMenu,
    var _openSubMenu,
    var _closeSubMenu) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Stack(
      children: [
        Card(
          elevation: 9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textLabel(_title, 17, themeProvider.fontColor1,
                      themeProvider.fontFamily, FontWeight.bold),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: textLabel(_data, 19, themeProvider.fontColor1,
                        themeProvider.fontFamily, FontWeight.bold),
                  ),
                  // Text("Lihat"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: _openSubMenu,
                          icon: Icon(
                            Icons.more_vert,
                            size: 17,
                          )),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _showSubMenu != id
              ? Container()
              : Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          GestureDetector(
                            onTap: _onTap,
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.table_chart,
                                    size: 17,
                                  ),
                                ],
                              ),
                              title: textLabel(
                                  "Data",
                                  14,
                                  themeProvider.fontColor1,
                                  themeProvider.fontFamily,
                                  FontWeight.normal),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onTap2,
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.assessment,
                                    size: 17,
                                  ),
                                ],
                              ),
                              title: textLabel(
                                  "Grafik",
                                  14,
                                  themeProvider.fontColor1,
                                  themeProvider.fontFamily,
                                  FontWeight.normal),
                            ),
                          )
                        ]).toList(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: _closeSubMenu,
                                  icon: Icon(Icons.clear)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
        )
      ],
    ),
  );
}
