import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/InputFormStyle2.dart';
import 'package:appsimanis/Widget/InputFormStyle3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  //  final VoidCallback changeStateLogin;

// const Login({Key? key, required this.changeStateLogin}) : super(key: key);
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final _formKey = GlobalKey<FormState>();
  CRUD crud = new CRUD();
  bool _loading = false;
  bool _obscPass = true;
  bool _emailError = false;
  bool _passError = false;
  FunctionGroup functionGroup = new FunctionGroup();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      // emailTextEditingController.text = "wilirahmatm@gmail.com";
      // passwordTextEditingController.text = "wili123";
      // emailTextEditingController.text = "wilirahmatm@gmail.com";
      // passwordTextEditingController.text = "wili123";
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xff2BA33A),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 56, right: 16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(context, Colors.white, "Daftar Sekarang",
                    TextAlign.left, 28, FontWeight.w600),
                Padding(
                  padding: const EdgeInsets.only(bottom: 52.0),
                  child: customText(
                      context,
                      Colors.white,
                      "Aplikasi Simanis Dinas Perindustriaan NTB",
                      TextAlign.left,
                      20,
                      FontWeight.w400),
                ),
                customText(context, Colors.white, "Email", TextAlign.left, 14,
                    FontWeight.w400),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                  child: inputFormStyle3(
                      null,
                      "Email",
                      "text",
                      "Email",
                      "Email Tidak Boleh Kosong",
                      _emailError,
                      emailTextEditingController,
                      false,
                      () {}),
                ),
                customText(context, Colors.white, "Password", TextAlign.left,
                    14, FontWeight.w400),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16),
                  child: inputFormStyle3(
                      Icons.remove_red_eye,
                      "Password",
                      "text",
                      "Password",
                      "Password Tidak Boleh Kosong",
                      _passError,
                      passwordTextEditingController,
                      _obscPass, () {
                    setState(() {
                      _obscPass = !_obscPass;
                    });
                  }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String url =
                          "https://simanis.ntbprov.go.id:8443/get_password.php?locale=default";
                      if (await canLaunch(url)) {
                        await launch(url);
                        return;
                      }
                      print("couldn't launch $url");
                    },
                    child: customText(context, Colors.white, "Lupa password?",
                        TextAlign.right, 14, FontWeight.w400),
                  ),
                ],
              ),
            ),
            button2("Masuk", Colors.white, Color(0xff2BA33A), context, () {
              // Navigator.pushNamed(context, '/homeLayoutPage',
              //     arguments: <String, dynamic>{"selectedIndex": 3});
              if (emailTextEditingController.text != "" &&
                  passwordTextEditingController.text != "") {
                Map<String, String> dataUsers = {
                  "email": emailTextEditingController.text,
                  "password": passwordTextEditingController.text,
                };
                crud.checkLogin(dataUsers).then((res) {
                  var dataRes = jsonDecode(res.body);

                  String message = dataRes['message'];
                  // print(res.statusCode);
                  // print(res.statusCode == 201);
                  if (res.statusCode == 201) {
                    if (message == "data ada") {
                      setState(() {
                        _loading = true;
                      });
                      crud
                          .getData("/usersEmail/${emailTextEditingController.text}")
                          .then((res) async {
                        if (res.statusCode == 200) {
                          Map<String, String> dataUsersCache = {
                            "email": emailTextEditingController.text,
                            "password": passwordTextEditingController.text,
                            "idUser": jsonDecode(res.body)[0]['id']
                          };
                          functionGroup.saveCache(dataUsersCache);
                        }
                      });
                      Navigator.pushNamed(context, '/homeLayoutPage',
                          arguments: <String, dynamic>{
                            "selectedIndex": 4,
                            "dataUsers": dataUsers
                          });
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogBox("alert", message, []);
                          });
                    }
                  } else {
                    print("error");
                  }
                });
              } else if (emailTextEditingController.text == "" &&
                  passwordTextEditingController.text != "") {
                if (mounted) {
                  setState(() {
                    _emailError = true;
                    _passError = false;
                  });
                }
              } else if (emailTextEditingController.text != "" &&
                  passwordTextEditingController.text == "") {
                if (mounted) {
                  setState(() {
                    _emailError = false;
                    _passError = true;
                  });
                }
              } else if (emailTextEditingController.text == "" &&
                  passwordTextEditingController.text == "") {
                if (mounted) {
                  setState(() {
                    _emailError = true;
                    _passError = true;
                  });
                }
              }
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 45),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/daftar');
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Belum punya akun?",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: " Daftar disini",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/homeLayoutPage',
                          arguments: <String, dynamic>{"selectedIndex": 0});
                    },
                    child: customText(
                        context,
                        Colors.white,
                        "Masuk ke halaman utama",
                        TextAlign.center,
                        14,
                        FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
