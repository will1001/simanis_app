import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  bool _obscPass = true;

  TextEditingController passwordTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
        title: customText(context, Colors.black, "Notifikasi", TextAlign.left,
            18, FontWeight.normal),
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
                  passwordTextEditingController,
                  _obscPass, () {
                setState(() {
                  _obscPass = !_obscPass;
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
                  passwordTextEditingController,
                  _obscPass, () {
                setState(() {
                  _obscPass = !_obscPass;
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
                  passwordTextEditingController,
                  _obscPass, () {
                setState(() {
                  _obscPass = !_obscPass;
                });
              }),
            ),
            button2("Update Password", Colors.blue.shade600,
                Color.fromARGB(255, 255, 255, 255), context, () {}),
          ],
        ),
      ),
    );
  }
}
