import 'dart:convert';

import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/Dropdown2.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkPerbankan extends StatefulWidget {
  const LinkPerbankan({Key? key}) : super(key: key);

  @override
  _LinkPerbankanState createState() => _LinkPerbankanState();
}

class _LinkPerbankanState extends State<LinkPerbankan> {
  bool _loading = true;
  List _dataUser = [];
  String? _bank;
  List _listBank = [
    'Bank 1',
    'Bank 2',
    'Bank 3',
    'Bank 4',
  ];

  getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    crud.getData("/users/$idUserCache").then((res) {
      if (res.statusCode == 200) {
        setState(() {
          _dataUser = jsonDecode(res.body);
          _loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                customText(context, Colors.black, " Data Pemohon : ",
                    TextAlign.left, 16, FontWeight.normal),
                dropDown2(_bank, "Bank", _listBank, (newValue) {
                  setState(() {
                    _bank = newValue!;
                  });
                }),
                Text(
                    "Nama : ${(_dataUser.length == 0 ? "" : _dataUser[0]["nama"]).toString()}"),
                Text(
                    "Jenis kelamin : ${(_dataUser.length == 0 ? "" : _dataUser[0]["jenis_kelamin"]).toString()}"),
                Text(
                    "NIK : ${(_dataUser.length == 0 ? "" : _dataUser[0]["nik"]).toString()}"),
                Text(
                    "Nomor Telpon : ${(_dataUser.length == 0 ? "" : _dataUser[0]["nomor_telpon"]).toString()}"),
                // _nama = (_dataUser[0]["nama"] ?? "").toString();
                // _tglLahir = (_dataUser[0]["tanggal_lahir"] ?? "").toString();
                // _jenisKelamin = (_dataUser[0]["jenis_kelamin"] ?? "").toString();
                // _email = (_dataUser[0]["email"] ?? "").toString();
                // _nik = (_dataUser[0]["nik"] ?? "").toString();
                // _noTlp = (_dataUser[0]["nomor_telpon"] ?? "").toString();
                // _namaIKM = (_dataUser[0]["nama_perusahaan"] ?? "").toString();
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        color: Colors.grey,
                      ),
                      customText(context, Colors.black, " Formolir dari Bank ",
                          TextAlign.center, 14, FontWeight.normal)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: button1("Submit", Colors.blue, context, () {}),
                )
              ],
            ),
          ),
        ),
        _dataUser.length == 0 || _loading ? loadingWidget(context) : Container()
      ],
    );
  }
}
