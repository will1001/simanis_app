import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/CardMenu.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/DrawerMenu.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late DateTime currentBackPressTime;
  Map _cache = {};
  CRUD crud = new CRUD();
  String? _nama;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogBox("", "Keluar dari App ?", [
            AlertButton("Ya", Colors.blue, null, () async {
              SystemNavigator.pop();
            }, context),
            AlertButton("tidak", Colors.blue, null, () {
              Navigator.pop(context);
            }, context),
          ]);
        });
    return Future.value(true);
  }

  setCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? nama = prefs.getString('nama');
    String? idUser = prefs.getString('idUser');
    if (nama == "") {
      crud.getData("/usersEmail/${email}").then((res) async {
        // print(jsonDecode(res.body)[0]["nama"]);
        print(res.statusCode);
        if (res.statusCode == 200) {
          await prefs.setString('nama', jsonDecode(res.body)[0]["nama"] ?? "");
          await prefs.setString('idUser', jsonDecode(res.body)[0]["id"] ?? "");
          setState(() {
            _nama = jsonDecode(res.body)[0]["nama"];
          });
        }
      });
    }
    setState(() {
      _nama = nama;
    });
  }

  @override
  void initState() {
    super.initState();
    setCache();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: drawerMenu(context),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            gradientBg(),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: textLabel("Selamat Datang ${_nama}", 18,
                      Colors.black, "Roboto", FontWeight.normal),
                ),
                SizedBox(
                  height: 600,
                  width: 300,
                  child: GridView.count(
                    childAspectRatio: 1 / 0.8,
                    crossAxisCount: 2,
                    children: [
                      cardMenu("Profil", Icons.person_outline_outlined, context,
                          () {
                        Navigator.pushNamed(context, '/profilPage');
                      }),
                      cardMenu("Informasi IKM", Icons.domain, context, () {
                        Navigator.pushNamed(context, '/informasiIKM');
                      }),
                      cardMenu(
                          "Produk", Icons.local_grocery_store_outlined, context,
                          () {
                        Navigator.pushNamed(context, '/produkPage');
                      }),
                      cardMenu("Pengajuan Pembiayaan",
                          Icons.how_to_vote_outlined, context, () {
                        Navigator.pushNamed(
                            context, '/pengajuanPembiayaanPage');
                      }),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
