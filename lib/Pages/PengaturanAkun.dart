import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class PengaturanAkun extends StatefulWidget {
  const PengaturanAkun({Key? key}) : super(key: key);

  @override
  _PengaturanAkunState createState() => _PengaturanAkunState();
}

class _PengaturanAkunState extends State<PengaturanAkun> {
  bool _passError = false;
  bool _obscPass1 = true;
  bool _obscPass2 = true;
  bool _obscPass3 = true;
  String _idUser = "";
  String _errMsg = "";
  Color _errMsgColor = Colors.red;

  TextEditingController oldPasswordTextEditingController =
      new TextEditingController();
  TextEditingController newPasswordTextEditingController =
      new TextEditingController();
  TextEditingController newPasswordConfirmTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    oldPasswordTextEditingController.addListener(() {});
    newPasswordTextEditingController.addListener(() {});
    newPasswordConfirmTextEditingController.addListener(() {});
    getIdUser();
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUser');

    setState(() {
      _idUser = idUser!;
    });
  }

  String updatePasswordMutation = r'''
      mutation($id: String!,$old_password: String!,$new_password: String!){
        UpdatePassword(id:$id,old_password:$old_password,new_password:$new_password){
          messagges
        }
      }
    ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              "assets/images/backArrow.svg",
            ),
          ),
        ),
        centerTitle: true,
        title: customText(context, Colors.black, "Update Password",
            TextAlign.left, 18, FontWeight.normal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            customText(context, Colors.black, "Password Lama", TextAlign.left,
                14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  Icons.remove_red_eye,
                  "Tulis Password Lama",
                  "text",
                  "Password",
                  "Password Tidak Boleh Kosong",
                  _passError,
                  oldPasswordTextEditingController,
                  _obscPass1, () {
                setState(() {
                  _obscPass1 = !_obscPass1;
                });
              }),
            ),
            customText(context, Colors.black, "Password Baru", TextAlign.left,
                14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  Icons.remove_red_eye,
                  "Tulis Password Baru",
                  "text",
                  "Password",
                  "Password Tidak Boleh Kosong",
                  _passError,
                  newPasswordTextEditingController,
                  _obscPass2, () {
                setState(() {
                  _obscPass2 = !_obscPass2;
                });
              }),
            ),
            customText(context, Colors.black, "Konfirmasi Password Baru",
                TextAlign.left, 14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  Icons.remove_red_eye,
                  "Tulis Ulang Password Baru",
                  "text",
                  "Password",
                  "Password Tidak Boleh Kosong",
                  _passError,
                  newPasswordConfirmTextEditingController,
                  _obscPass3, () {
                setState(() {
                  _obscPass3 = !_obscPass3;
                });
              }),
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
                            style: TextStyle(color: _errMsgColor),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Mutation(
              options: MutationOptions(
                document: gql(updatePasswordMutation),

                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  // print(updatePasswordMutation(
                  //     _idUser,
                  //     oldPasswordTextEditingController.text,
                  //     newPasswordTextEditingController.text));
                  if (newPasswordTextEditingController.text !=
                      newPasswordConfirmTextEditingController.text) {
                    setState(() {
                      _errMsg = "Password Tidak Sama";
                    });
                  } else {
                    String msg = resultData['UpdatePassword']['messagges'];
                    setState(() {
                      _errMsg = msg;
                      _errMsgColor = msg == "Password Berhasil Dirubah"
                          ? Colors.green
                          : Colors.red;
                    });
                  }

                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onError: (err) {
                  print(err);
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return button2("Update Password", Colors.blue.shade600,
                    Color.fromARGB(255, 255, 255, 255), context, () {
                  runMutation(<String, dynamic>{
                    'id': _idUser,
                    'old_password': oldPasswordTextEditingController.text,
                    'new_password': newPasswordTextEditingController.text,
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
