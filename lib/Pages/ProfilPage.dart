import 'dart:convert';

import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/ListLabel.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/StatusVerifikasiData.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _showEditBox = false;
  bool _loading = true;
  String _type = "";
  String _namaTabel = "users";
  String _redirectTo = "profilPage";
  String? _idUser = "";
  String _param = "";
  String _paramDropdown = "";
  String _content = "Informasi IKM";
  String _hintText = "";
  String _labelText = "";
  String _dropDownValue = "";
  TextEditingController _controller = new TextEditingController();
  List _dropDownListItem = [];
  List _dataUser = [];
  var _dropDownOnChanged;
  var _onPressed;
  String _nama = "";
  String _tglLahir = "";
  String _jenisKelamin = "";
  String _email = "";
  String _nik = "";
  String _noTlp = "";
  String _namaIKM = "";

  setStateParam(
      bool showEditBox,
      String type,
      String param,
      String paramDropdown,
      String labelText,
      String hintText,
      String dropDownValue,
      List dropDownListItem,
      var dropDownOnChanged,
      var onPressed) {
    setState(() {
      _showEditBox = showEditBox;
      _type = type;
      _param = param;
      _paramDropdown = paramDropdown;
      _labelText = labelText;
      _hintText = hintText;
      _dropDownValue = dropDownValue;
      _dropDownListItem = dropDownListItem;
      _dropDownOnChanged = dropDownOnChanged;
      _onPressed = onPressed;
    });
  }

  setInitialDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    crud.getData("/users/$idUserCache").then((res) {
      if (res.statusCode == 200) {
        setState(() {
          _dataUser = jsonDecode(res.body);
          _nama = (_dataUser[0]["nama"] ?? "").toString();
          _tglLahir = (_dataUser[0]["tanggal_lahir"] ?? "").toString();
          _jenisKelamin = (_dataUser[0]["jenis_kelamin"] ?? "").toString();
          _email = (_dataUser[0]["email"] ?? "").toString();
          _nik = (_dataUser[0]["nik"] ?? "").toString();
          _noTlp = (_dataUser[0]["nomor_telpon"] ?? "").toString();
          _namaIKM = (_dataUser[0]["nama_perusahaan"] ?? "").toString();
          _loading = false;
        });
      }
    });
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    setState(() {
      _idUser = idUserCache;
    });
  }

  @override
  void initState() {
    super.initState();
    getIdUser();
    setInitialDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? loadingWidget(context)
        : _showEditBox
            ? editDialogBox(
                context,
                _idUser,
                _type,
                _namaTabel,
                _redirectTo,
                _param,
                _paramDropdown,
                _content,
                _hintText,
                _labelText,
                _dropDownValue,
                _controller,
                _dropDownListItem,
                _dropDownOnChanged,
                _onPressed)
            : Scaffold(
                appBar: AppBar(
                  title: textLabel(
                      "Profil", 15, Colors.black, "", FontWeight.w400),
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                body: ListView(
                  children: [
                    statusVerifikasiData(context, "Belum diverifikasi", ""),
                    listLabel(context, "Nama :", _nama, () {
                      setStateParam(true, "textfield", "nama", "", "Nama :",
                          "Nama :", "", [], (newValue) {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    listLabel(context, "Tanggal Lahir :", _tglLahir, () {}),
                    listLabel(context, "Jenis Kelamin :", _jenisKelamin, () {
                      setStateParam(
                              true,
                              "dropDown",
                              "jenis_kelamin",
                              "",
                              "Jenis Kelamin :",
                              "Jenis Kelamin :",
                              "",
                              ["Laki-Laki","Perempuan"], (newValue) {
                            setState(() {
                              _dropDownValue = newValue!;
                            });
                          }, () {
                            setState(() {
                              _showEditBox = false;
                            });
                          });
                    }),
                    listLabel(context, "Email :", _email, () {}),
                    listLabel(context, "NIK :", _nik, () {
                      setStateParam(true, "textfield", "nik", "", "NIK :",
                          "NIK :", "", [], (newValue) {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    listLabel(context, "Nomor Telpon :", _noTlp, () {
                      setStateParam(true, "textfield", "nomor_telpon", "", "Nomor Telpon :",
                          "Nomor Telpon :", "", [], (newValue) {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    listLabel(context, "Nama IKM :", _namaIKM, () {
                      setStateParam(true, "textfield", "nama_perusahaan", "", "Nama IKM :",
                          "Nama IKM :", "", [], (newValue) {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    // listLabel(context, "Nomor Telpon :", "081703999567",(){}),
                  ],
                ),
              );
  }
}
