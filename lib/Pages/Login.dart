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
import 'package:graphql_flutter/graphql_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
  CRUD crud = new CRUD();
  bool _loading = false;
  bool _obscPass = true;
  bool _nikError = false;
  bool _passError = false;
  String _errMsg = "";
  FunctionGroup functionGroup = new FunctionGroup();
  TextEditingController nikTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Hubungi Admin Untuk Mengubah Password'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Chat Admin'),
              onPressed: () async {
                String url =
                    "https://api.whatsapp.com/send?phone=6287728937983";
                if (await canLaunch(url)) {
                  await launch(url);
                  return;
                }
                print("couldn't launch $url");
              },
            ),
          ],
        );
      },
    );
  }

  String loginMutation = r'''
      mutation($nik: String!,$password: String!){
        login(nik:$nik,password:$password){
          id
          nama
          foto
          messagges
        }
      }
    ''';

  @override
  void initState() {
    super.initState();
    nikTextEditingController.addListener(() {});
    passwordTextEditingController.addListener(() {});
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 56, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 200,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(context, Colors.black, "NIK", TextAlign.left, 14,
                      FontWeight.w400),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                    child: inputFormStyle3(
                        null,
                        "Nomor Induk Kependudukan",
                        "text",
                        "NIK",
                        "NIK Tidak Boleh Kosong",
                        _nikError,
                        nikTextEditingController,
                        false,
                        () {}),
                  ),
                  customText(context, Colors.black, "Password", TextAlign.left,
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
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _showMyDialog();
                      },
                      child: customText(context, Colors.black, "Lupa password?",
                          TextAlign.right, 14, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              _errMsg != ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              _errMsg,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              Mutation(
                options: MutationOptions(
                  document: gql(loginMutation),

                  // or do something with the result.data on completion
                  onCompleted: (dynamic resultData) {
                    String msg = resultData['login']['messagges'];

                    if (msg != "success") {
                      setState(() {
                        _errMsg = msg;
                      });
                    } else {
                      Map<String, String> data = {
                        "id": resultData['login']['id'],
                        "nama": resultData['login']['nama'],
                        "foto": resultData['login']['foto'],
                      };
                      functionGroup.saveCache(data);
                      Navigator.pushNamed(context, '/homeLayoutPage');
                    }
                    FocusManager.instance.primaryFocus?.unfocus();

                    // print(data);
                  },
                  onError: (err) {
                    print(err);
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return button2("Login", Colors.blue.shade600,
                      Color.fromARGB(255, 255, 255, 255), context, () {
                    // print(nikTextEditingController.text);
                    // print(passwordTextEditingController.text);
                    runMutation(<String, dynamic>{
                      'nik': nikTextEditingController.text,
                      'password': passwordTextEditingController.text,
                    });
                  });
                },
              ),
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
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: " Daftar disini",
                                style: TextStyle(
                                    color: Colors.blue.shade600,
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
      ),
    );
  }
}
