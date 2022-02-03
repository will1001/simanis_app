import 'dart:convert';

import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/ListLabel.dart';
import 'package:appsimanis/Widget/ListLabelDropDown.dart';
import 'package:appsimanis/Widget/ListLabelInput.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/StatusVerifikasiData.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String _keyboardType = "";
  String _namaTabel = "users";
  String _redirectTo = "profilPage";
  String? _idUser = "";
  String _param = "";
  String _paramDropdown = "";
  String _content = "Edit Profil";
  String _hintText = "";
  String _labelText = "";
  String _dropDownValue = "";
  String _dateValue = "";
  TextEditingController _controller = new TextEditingController();
  List _dropDownListItem = [];
  List _dataIKM = [];
  var _dateOnChanged;
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

  dateFormat(String date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(date));
    return formatted;
  }

  setStateParam(
      bool showEditBox,
      String type,
      String param,
      String paramDropdown,
      String labelText,
      String hintText,
      String dropDownValue,
      String dateValue,
      List dropDownListItem,
      String keyboardType,
      var dropDownOnChanged,
      var dateOnChanged,
      var onPressed) {
    setState(() {
      _showEditBox = showEditBox;
      _type = type;
      _param = param;
      _paramDropdown = paramDropdown;
      _labelText = labelText;
      _hintText = hintText;
      _dropDownValue = dropDownValue;
      _dateValue = dateValue;
      _dropDownListItem = dropDownListItem;
      _keyboardType = keyboardType;
      _dropDownOnChanged = dropDownOnChanged;
      _dateOnChanged = dateOnChanged;
      _onPressed = onPressed;
    });
  }

  checkDataIKM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    crud.getData("/badan_usaha/$idUserCache").then((res) {
      if (res.statusCode == 200) {
        if (jsonDecode(res.body).length != 0) {
          setState(() {
            _dataIKM = jsonDecode(res.body);
          });
        }
      }
    });
    _loading = false;
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
    // print(idUserCache);
    setState(() {
      _idUser = idUserCache;
    });
  }

  Future<void> selectdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        _dateValue = picked.toString();
      });
  }

  @override
  void initState() {
    super.initState();
    getIdUser();
    setInitialDataUser();
    checkDataIKM();
  }

  @override
  Widget build(BuildContext context) {
    return _showEditBox
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
            _dateValue,
            _controller,
            _dropDownListItem,
            _keyboardType,
            _dropDownOnChanged,
            _dateOnChanged,
            _onPressed)
        : Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                appBar: AppBar(
                  title: customText(context, Color(0xff242F43), 'Edit Profil',
                      TextAlign.left, 20, FontWeight.w600),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.chevron_left)),
                  iconTheme: IconThemeData(color: Color(0xff242F43)),
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                body: ListView(
                  children: [
                    ListLabelInput(context, 'Nama Lengkap', _nama, () {
                      setStateParam(
                          true,
                          "textfield",
                          "nama",
                          "",
                          "Nama :",
                          "Nama :",
                          "",
                          "",
                          [],
                          "text",
                          (newValue) {},
                          () {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    ListLabelInput(
                        context,
                        'Tanggal Lahir',
                        _tglLahir == null || _tglLahir == ""
                            ? ""
                            : dateFormat(_tglLahir), () {
                      setStateParam(
                          true,
                          "date",
                          "tanggal_lahir",
                          "",
                          "Tanggal Lahir :",
                          "Tanggal Lahir :",
                          "",
                          "",
                          [],
                          "text",
                          (newValue) {}, () {
                        selectdate(context);
                      }, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    ListLabelDropDown(context, 'Jenis Kelamin', _jenisKelamin,
                        () {
                      setStateParam(
                          true,
                          "dropDown",
                          "jenis_kelamin",
                          "",
                          "Jenis Kelamin :",
                          "Jenis Kelamin :",
                          "",
                          "",
                          ["Laki-Laki", "Perempuan"],
                          "text",
                          (newValue) {
                            setState(() {
                              _dropDownValue = newValue!;
                            });
                          },
                          () {},
                          () {
                            setState(() {
                              _showEditBox = false;
                            });
                          });
                    }),
                    ListLabelInput(context, 'Email', _email, () {}),
                    ListLabelInput(context, 'NIK', _nik, () {
                      setStateParam(
                          true,
                          "textfield",
                          "nik",
                          "",
                          "NIK :",
                          "NIK :",
                          "",
                          "",
                          [],
                          "number",
                          (newValue) {},
                          () {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    ListLabelInput(context, 'Nomor Telpon', _noTlp, () {
                      setStateParam(
                          true,
                          "textfield",
                          "nomor_telpon",
                          "",
                          "Nomor Telpon :",
                          "Nomor Telpon :",
                          "",
                          "",
                          [],
                          "number",
                          (newValue) {},
                          () {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    ListLabelInput(context, 'Nama IKM', _namaIKM, () {
                      setStateParam(
                          true,
                          "textfield",
                          "nama_perusahaan",
                          "",
                          "Nama IKM :",
                          "Nama IKM :",
                          "",
                          "",
                          [],
                          "text",
                          (newValue) {},
                          () {}, () {
                        setState(() {
                          _showEditBox = false;
                        });
                      });
                    }),
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                    )
                  ],
                ),
              ),
              _dataUser.length == 0 || _loading
                  ? loadingWidget(context)
                  : Container()
            ],
          );
  }
}
