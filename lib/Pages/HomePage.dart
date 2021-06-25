import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/CardProduk.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  late DateTime currentBackPressTime;
  FunctionGroup functionGroup = new FunctionGroup();
  bool _loginCache = false;
  List _listBadanUsaha = [];
  List _listBadanUsahaNotNullFoto = [];
  bool _loading = true;

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

  getBadanUsaha() {
    crud.getData("/badan_usaha/limit/20").then((res) {
      setState(() {
        _listBadanUsaha = jsonDecode(res.body);
        _listBadanUsahaNotNullFoto = jsonDecode(res.body)
        .where((el) =>
            el["foto_alat_produksi"] != null &&
            el["foto_alat_produksi"] != "")
        .toList();
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _loginCache = functionGroup.checkLoginCache();
    // });
    getBadanUsaha();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return _loading
        ? loadingWidget(context)
        : WillPopScope(
            onWillPop: onWillPop,
            child: Scaffold(
              body: Container(
                color: themeProvider.bgColor2,
                child: ListView(
                  children: [
                    Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      child: Container(
                        // height: 250,
                        decoration: BoxDecoration(
                            color: themeProvider.bgColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    // height: 10,
                                    width: 170,
                                  ),
                                  _loginCache
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: themeProvider.bgColor2,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/memberPage');
                                              },
                                              icon: Icon(
                                                Icons.person_outline,
                                                color: themeProvider
                                                    .fontColorWhite,
                                              )))
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/login');
                                          },
                                          child: textLabel(
                                              "Daftar/Login",
                                              14,
                                              themeProvider.fontColor1,
                                              themeProvider.fontFamily,
                                              FontWeight.bold),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/welcome-removebg-preview.png',
                                  height: 250,
                                ),
                              ),
                            ),
                            // Center(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       SizedBox(
                            //           height: 150,
                            //           child: cardMenu("Daftar Data IKM", Icons.ac_unit,
                            //               context, () {})),
                            //       SizedBox(
                            //           height: 150,
                            //           child: cardMenu("Daftar Data IKM", Icons.ac_unit,
                            //               context, () {}))
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textLabel("Produk IKM", 22, themeProvider.fontColor1,
                              themeProvider.fontFamily, FontWeight.bold),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/produkPage');
                            },
                            child: textLabel(
                                "Lihat Selengkapnya",
                                16,
                                themeProvider.fontColor1,
                                themeProvider.fontFamily,
                                FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1 / 1.3,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      primary: true,
                      children: _listBadanUsahaNotNullFoto.map((e) {
                        return cardProduk(
                            e["nama_perusahaan"],
                            e["nama_pemilik"],
                            _storageUrl + e["foto_alat_produksi"],
                            // "",
                            context,
                            () {});
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
