import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/CardMenu.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/DrawerMenu.dart';
import 'package:appsimanis/Widget/HomeCardMenu.dart';
import 'package:appsimanis/Widget/StatistikBox.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';

import 'DataCardMenu.dart';

class ListDataIKMHomeMenu extends StatefulWidget {
  const ListDataIKMHomeMenu({Key? key}) : super(key: key);

  @override
  _ListDataIKMHomeMenuState createState() => _ListDataIKMHomeMenuState();
}

class _ListDataIKMHomeMenuState extends State<ListDataIKMHomeMenu> {
  String _dataIKM = "";
  String _dataIKMTerferivikasi = "";
  String _showsubMenu = "0";

  getStatistik() {
    crud.getData("/badan_usaha/statistik/totalIKM").then((res) {
      setState(() {
        _dataIKM = jsonDecode(res.body)["total"].toString();
      });
    });

    crud.getData("/badan_usaha/statistik/totalIKMTerverifikasi").then((res) {
      setState(() {
        _dataIKMTerferivikasi = jsonDecode(res.body)["total"].toString();
      });
    });
  }

  getDataBelumTerverifikasi(String _totalData, String _dataTerverifikasi) {
    // print("_dataIKM2125");
    // print(_dataIKM);
    return (int.parse((_dataIKM == "" ? "0" : _dataIKM)) -
            int.parse(
                (_dataIKMTerferivikasi == "" ? "0" : _dataIKMTerferivikasi)))
        .toString();
  }

  navigatorPush(String _url, Object _arg) {
    Navigator.pushNamed(context, _url, arguments: _arg);
  }

  @override
  void initState() {
    super.initState();
    getStatistik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: drawerMenu(context),
      // appBar: AppBar(
      //   leading: Opacity(
      //     opacity: 0,
      //   ),
      //   iconTheme: IconThemeData(color: Colors.black),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: textLabel("Data UMKM", 15, Colors.black, "", FontWeight.w400),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff46ACD5),
                Color(0xFF4A0BFB),
              ],
            )),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 50),
                  color: Colors.white,
                  child: customText(context, Color(0xff4930C5), "Data UMKM",
                      TextAlign.left, 17, FontWeight.w700),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 130.0, left: 52),
                child: Image.asset("assets/images/menu_pattern.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 90, top: 190),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: dataCardMenu(context, "assets/images/server.png",
                          "Semua UMKM", _dataIKM, () {
                        navigatorPush("/ListDataIKM", {
                          'status_verifikasi': "null",
                        });
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: dataCardMenu(context, "assets/images/badge.png",
                          "Terverifikasi", _dataIKMTerferivikasi, () {
                        navigatorPush("/ListDataIKM", {
                          'status_verifikasi': "Sudah diverifikasi",
                        });
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45.0),
                      child: dataCardMenu(
                          context,
                          "assets/images/x-button.png",
                          "Belum Terverifikasi",
                          getDataBelumTerverifikasi(
                              _dataIKM, _dataIKMTerferivikasi), () {
                        navigatorPush("/ListDataIKM", {
                          'status_verifikasi': "Belum diverifikasi",
                        });
                      }),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
