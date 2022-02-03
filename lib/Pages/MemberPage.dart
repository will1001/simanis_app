import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/CardMenu.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/DrawerMenu.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/MenuCard.dart';
import 'package:appsimanis/Widget/StatusVerifikasiData.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberPage extends StatefulWidget {
  final Map<String, String> dataUsers;

  const MemberPage({Key? key, required this.dataUsers}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late DateTime currentBackPressTime;
  Map _cache = {};
  CRUD crud = new CRUD();
  String _nama = "";
  String _noTlp = "";
  List _dataIKM = [];
  List _dataUsers = [];
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

  // setCache() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? email = prefs.getString('email');
  //   String? nama = prefs.getString('nama');
  //   String? idUser = prefs.getString('idUser');
  //   // print(email);
  //   print("nama");
  //   print(nama);
  //   if (nama == "" || nama == null) {
  //     crud
  //         .getData("/usersEmail/${widget.dataUsers['email']}")
  //         .then((res) async {
  //       // print("asdasdasasf55555");
  //       // print(res.body);
  //       // print(jsonDecode(res.body)[0]["nama"]);
  //       // print("asdasdasasf55555");
  //       // print(res.statusCode == 200);
  //       if (res.statusCode == 200) {
  //         await prefs.setString('nama', jsonDecode(res.body)[0]['nama'] ?? "");
  //         await prefs.setString('idUser', jsonDecode(res.body)[0]['id'] ?? "");

  //       }
  //     });
  //   }

  // }

  checkDataIKM() async {
    // print("Asdaf");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');

    if (idUserCache == null) {
      crud
          .getData("/usersEmail/${widget.dataUsers['email']}")
          .then((res) async {
        // print(jsonDecode(res.body)[0]["nama"]);
        // print(res.statusCode);
        if (res.statusCode == 200) {
          await prefs.setString('nama', jsonDecode(res.body)[0]['nama'] ?? "");
          await prefs.setString('idUser', jsonDecode(res.body)[0]['id'] ?? "");

          var dataRes = jsonDecode(res.body);
          // print("/badan_usaha/${dataRes[0]['id']}");

          // setState(() {
          //   _nama = jsonDecode(res.body)[0]["nama"];
          // });
          crud.getData("/badan_usaha/${dataRes[0]['id']}").then((res2) {
            if (res2.statusCode == 200) {
              if (jsonDecode(res2.body).length != 0) {
                setState(() {
                  _dataIKM = jsonDecode(res2.body);
                  _loading = false;
                });
              }
            }
          });
        }
      });
    } else {
      crud.getData("/badan_usaha/${idUserCache}").then((res2) {
        if (res2.statusCode == 200) {
          if (jsonDecode(res2.body).length != 0) {
            setState(() {
              _dataIKM = jsonDecode(res2.body);
              _loading = false;
            });
          }
        }
      });
    }
  }

  // getUsers() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String? emailCache = prefs.getString('idUser');

  //   // print("asasdagg12121212");
  //   print('/users/$emailCache');
  //   // print("/usersEmail/${widget.dataUsers['email']}");
  //   // print(widget.dataUsers);

  //   if (emailCache == null) {
  //     crud
  //         .getData("/usersEmail/${widget.dataUsers['email']}")
  //         .then((res) async {
  //       // print(res);
  //       // print(jsonDecode(res.body));
  //       // print(res.statusCode);
  //       // print(res.statusCode);
  //       if (res.statusCode == 200) {
  //         await prefs.setString('nama', jsonDecode(res.body)[0]['nama'] ?? "");
  //         await prefs.setString('idUser', jsonDecode(res.body)[0]['id'] ?? "");

  //         // setState(() {
  //         //   _nama = jsonDecode(res.body)[0]["nama"];
  //         // });
  //         var dataRes = jsonDecode(res.body);
  //         // print(dataRes.runtimeType);
  //         // print(abc[0]);
  //         // print(abc[0]['id']);
  //         // print(jsonDecode(res.body)[0]["id"]);
  //         // print("/users/${dataRes[0]['id']}");
  //         crud.getData("/users/${dataRes[0]['id']}").then((res2) {
  //           //   print(jsonDecode(res2.body));
  //           if (res2.statusCode == 200) {
  //             setState(() {
  //               _dataUsers = jsonDecode(res2.body);
  //             });
  //           }
  //         });
  //       }
  //     });
  //   } else {
  //     crud.getData("/users/${emailCache}").then((res2) {
  //       if (res2.statusCode == 200) {
  //         setState(() {
  //           _dataUsers = jsonDecode(res2.body);
  //         });
  //       }
  //     });
  //   }
  // }

  getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailCache = prefs.getString('email');

    // print('emailCache');
    // print(emailCache);

    if (emailCache == null) {
      crud
          .getData("/usersEmail/${widget.dataUsers['email']}")
          .then((res) async {
        await prefs.setString('nama', jsonDecode(res.body)[0]['nama'] ?? "");
        await prefs.setString('idUser', jsonDecode(res.body)[0]['id'] ?? "");
        if (res.statusCode == 200) {
          var dataRes = jsonDecode(res.body);
          setState(() {
            _nama = dataRes[0]['nama'];
            _noTlp = dataRes[0]['nomor_telpon'];
            // _loading = false;
            checkDataIKM();
          });
        }
      });
    } else {
      // print(data)
      crud.getData("/usersEmail/$emailCache").then((res) async {
        if (res.statusCode == 200) {
          var dataRes = jsonDecode(res.body);
          setState(() {
            _nama = dataRes[0]['nama'];
            _noTlp = dataRes[0]['nomor_telpon'];
            // _loading = false;
            checkDataIKM();
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // setCache();
    // checkDataIKM();
    // getUsers();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    // print("_dataUsers");
    // print(_dataUsers);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 16),
                  child: customText(context, Colors.black, "Profil",
                      TextAlign.left, 16, FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 16),
                  child: customText(context, Color(0xff242F43), _nama,
                      TextAlign.left, 14, FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(context, Color(0xff727986), _noTlp,
                          TextAlign.left, 12, FontWeight.w400),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profilPage');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Color(0xff848A95),
                              ),
                            ),
                            customText(context, Color(0xff848A95), "Edit",
                                TextAlign.left, 12, FontWeight.w400)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 16, right: 16),
                  child: statusVerifikasiData(
                      context,
                      _dataIKM.length == 0
                          ? ""
                          : _dataIKM[0]["status_verifikasi"] ?? "",
                      ""),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: customText(context, Color(0xff242F43), "Akun",
                      TextAlign.left, 12, FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/informasiIKM');
                    },
                    child: customText(context, Color(0xff545C6C), "UMKM Saya",
                        TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      checkDataIKM();
                      if (_dataIKM.length == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogBox("Perhatian",
                                  "IKM Anda Belum Diverifikasi", []);
                            });
                      } else {
                        Navigator.pushNamed(context, '/produkPageMember',
                            arguments: {"data": _dataIKM});
                      }
                    },
                    child: customText(context, Color(0xff545C6C), "Produk Saya",
                        TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/linkBank');
                    },
                    child: customText(context, Color(0xff545C6C),
                        "Link Perbankan", TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: customText(context, Color(0xff242F43), "Info Lainnya",
                      TextAlign.left, 12, FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: GestureDetector(
                    onTap: () async {
                      String url =
                          "https://docs.google.com/forms/d/e/1FAIpQLSdampdX0BstgbXIrfSj89fqN-q2TFjt0rmkifEm2n5aTQ3tfQ/alreadyresponded?embedded=true";
                      if (await canLaunch(url)) {
                        await launch(url);
                        return;
                      }
                      print("couldn't launch $url");
                    },
                    child: customText(context, Color(0xff545C6C),
                        "Survei Kepuasan", TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16),
                  child: GestureDetector(
                    onTap: () async {
                      String url = "https://simanis.ntbprov.go.id";
                      if (await canLaunch(url)) {
                        await launch(url);
                        return;
                      }
                      print("couldn't launch $url");
                    },
                    child: customText(context, Color(0xff545C6C),
                        "Simanis Website", TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16),
                  child: GestureDetector(
                    onTap: () async {
                      String url =
                          "https://api.whatsapp.com/send?phone=6287728937983";
                      if (await canLaunch(url)) {
                        await launch(url);
                        return;
                      }
                      print("couldn't launch $url");
                    },
                    child: customText(context, Color(0xff545C6C), "Hubungi CS",
                        TextAlign.left, 14, FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.pushNamed(context, '/homeLayoutPage',
                          arguments: <String, dynamic>{"selectedIndex": 4});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xffE0E0E0))),
                      child: customText(context, Color(0xffCB3A31), "Keluar",
                          TextAlign.center, 14, FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _loading ? loadingWidget(context) : Container()
        ],
      ),
    );
  }
}
