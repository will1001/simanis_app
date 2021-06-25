import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  CRUD crud = new CRUD();
  bool _loading = false;
  FunctionGroup functionGroup = new FunctionGroup();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      emailTextEditingController.text = "wilirahmatm@gmail.com";
      passwordTextEditingController.text = "wili123";
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/bgLogin.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 00.0, bottom: 104),
                  child: Image.asset('assets/images/logo.png'),
                ),
                inputForm(
                    Icon(Icons.person),
                    'Masukan Email anda',
                    'Email',
                    'Email Tidak Boleh Kosong',
                    emailTextEditingController,
                    false),
                inputForm(
                    Icon(Icons.lock),
                    'Masukan Password anda',
                    'Password',
                    'Password Tidak Boleh Kosong',
                    passwordTextEditingController,
                    true),
                button1("Login", themeProvider.buttonColor, context, () {
                  // Navigator.pushNamed(context, '/homeLayoutPage',
                  //     arguments: <String, dynamic>{"selectedIndex": 3});
                  if (_formKey.currentState!.validate()) {
                    Map<String, String> dataUsers = {
                      "email": emailTextEditingController.text,
                      "password": passwordTextEditingController.text,
                    };
                    crud.checkLogin(dataUsers).then((res) {
                      String message = jsonDecode(res.body)["message"];
                      if (res.statusCode == 201) {
                        if (message == "data ada") {
                          setState(() {
                            _loading = true;
                          });
                          functionGroup.saveCache(dataUsers);
                          Navigator.pushNamed(context, '/homeLayoutPage',
                              arguments: <String, dynamic>{"selectedIndex": 3});
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
                  }
                }),
                button1("Daftar", themeProvider.buttonColor, context, () {
                  Navigator.pushNamed(context, '/daftar');
                }),
              ],
            ),
          ),
          !_loading
              ? Container()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.black26,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    Container(
                        color: Colors.white,
                        width: 200,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        )),
                  ],
                ),
        ],
      ),
    );
  }
}
