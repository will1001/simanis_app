import 'dart:convert';
import 'dart:io';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/DaftarIKM.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/ListLabelDropDown.dart';
import 'package:appsimanis/Widget/ListLabelInput.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:http/http.dart' as http;

import 'package:appsimanis/Widget/InputFormImage.dart';
import 'package:appsimanis/Widget/ListLabel.dart';
import 'package:appsimanis/Widget/StatusVerifikasiData.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformasiIKM extends StatefulWidget {
  const InformasiIKM({Key? key}) : super(key: key);

  @override
  _InformasiIKMState createState() => _InformasiIKMState();
}

class _InformasiIKMState extends State<InformasiIKM> {
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  PickedFile? _fotoAlatProduksi;
  File? _fotoAlatProduksiFile;
  // "https://images.tokopedia.net/img/cache/700/VqbcmM/2020/6/22/f7724349-e560-41e4-bd9f-abe8cc2676aa.png";
  PickedFile? _fotoRuangProduksi;
  File? _fotoRuangProduksiFile;
  bool _showEditBox = false;
  bool _loading = true;
  String _type = "";
  String _keyboardType = "";
  String _namaTabel = "badan_usaha";
  String _redirectTo = "informasiIKM";
  String? _idUser = "";
  String _param = "";
  String _paramDropdown = "";
  String _content = "UMKM Saya";
  String _hintText = "";
  String _labelText = "";
  String _dropDownValue = "";
  String _dateValue = "";
  String _cabangIndustri = "";
  String _tahun = "";
  String _tenagaKerjaLk = "";
  String _tenagaKerjaPr = "";
  String _satuanProduksi = "";
  String _nilaiInves = "";
  String _nilaiBbBp = "";
  String _jenisUsaha = "";
  String? _fotoAlatProduksiUrl = "";
  String? _fotoRuangProduksiUrl = "";

  TextEditingController _controller = new TextEditingController();
  List _dropDownListItem = [];
  List _dataIKM = [];
  List _listCabangIndustri = [];
  var _dropDownOnChanged;
  var _dateOnChanged;
  var _onPressed;
  var _simpanOnPressed;

  Future<void> uploadImage(String _foto) async {
    var request = http.MultipartRequest('POST',
        Uri.parse("https://simanis.ntbprov.go.id/api/badan_usaha/uploadgbr"));
    request.files.add(http.MultipartFile(
        'file',
        File(_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .readAsBytes()
            .asStream(),
        File(_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .lengthSync(),
        filename: (_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .toString()
            .split('.')
            .last));
    request.fields['audio'] = 'value';
    request.fields['name'] =
        "${_foto == 'Alat' ? 'Alat' : 'Ruang'}_${_idUser}." +
            (_foto == "Alat"
                    ? _fotoAlatProduksi!.path
                    : _fotoRuangProduksi!.path)
                .toString()
                .split('.')
                .last;
    request.fields['tipe_foto'] = _foto == "Alat" ? "Alat" : "Ruang";
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {
      // print(value);
    });
  }

  // getImgFile(String _from, String _file) async {
  //   await _from == "camera"
  //       ? Permission.camera.request()
  //       : Permission.photos.request();
  //   final picker = ImagePicker();

  //   final pickedFile = await picker.getImage(
  //       source: _from == "camera" ? ImageSource.camera : ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _file == "alat" ? _fotoAlatProduksi : _fotoRuangProduksi = pickedFile;
  //       _file == "alat"
  //           ? _fotoAlatProduksiFile
  //           : _fotoRuangProduksiFile = File(pickedFile.path);
  //       // _imagePath = pickedFile.path;
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

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

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    setState(() {
      _idUser = idUserCache;
    });
  }

  checkDataIKM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    // print("idUserCache");
    // print(idUserCache);
    crud.getData("/badan_usaha/$idUserCache").then((res) {
      // print(res.statusCode);
      if (res.statusCode == 200) {
        // print("res.body");
        // print(jsonDecode(res.body).length);
        // print(_listCabangIndustri);
        if (jsonDecode(res.body).length != 0) {
          setState(() {
            _dataIKM = jsonDecode(res.body);
            // _cabangIndustri = _listCabangIndustri
            //     .where((e) => e["id"] == _dataIKM[0]["id_cabang_industri"])
            //     .toList()[0]["nama"];
            // // print(_dataIKM[0]);
            // _tahun = (_dataIKM[0]["tahun_badan_usaha"] ?? "").toString();
            // _tenagaKerjaLk = (_dataIKM[0]["male"] ?? "").toString();
            // _tenagaKerjaPr = (_dataIKM[0]["famale"] ?? "").toString();
            // _satuanProduksi = (_dataIKM[0]["satuan_produksi"] ?? "").toString();
            // _nilaiInves = (_dataIKM[0]["nilai_investasi"] ?? "").toString();
            // _nilaiBbBp = (_dataIKM[0]["nilai_bb_bp"] ?? "").toString();
            // _jenisUsaha = (_dataIKM[0]["jenis_ikm"] ?? "").toString();
            // _fotoAlatProduksiUrl = "${_storageUrl}" +
            //     (_dataIKM[0]["foto_alat_produksi"] ?? "").toString();
            // _fotoRuangProduksiUrl = "${_storageUrl}" +
            //     (_dataIKM[0]["foto_ruang_produksi"] ?? "").toString();
            // print(_listCabangIndustri
            //     .where((e) => e["id"] == _dataIKM[0]["id_cabang_industri"]).toList()[0]["nama"]);
          });
        }
      }
    });
    _loading = false;
  }

  getCabangIndsutri() {
    crud.getData("/cabang_industri").then((res) {
      setState(() {
        _listCabangIndustri = jsonDecode(res.body);
      });
    });
  }

  // setInitialValueIKM() {
  //   // _cabangIndustri = _dataIKM[0]["id_cabang_industri"];
  //   print(_listCabangIndustri);
  // }

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
    getCabangIndsutri();
    checkDataIKM();
    // setInitialValueIKM();
  }

  @override
  Widget build(BuildContext context) {
    // print("_dataIKM.length");
    // print(_dataIKM.length);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return _loading && _dataIKM.length == 0
        ? loadingWidget(context)
        : _dataIKM.length == 0
            ? DaftarIKM()
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
                    _dateValue,
                    _controller,
                    _dropDownListItem,
                    _keyboardType,
                    _dropDownOnChanged,
                    _dateOnChanged,
                    _onPressed)
                : Scaffold(
                    appBar: AppBar(
                      title: customText(context, Color(0xff242F43), 'UMKM Saya',
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
                        ListLabelDropDown(
                            context,
                            'Cabang Industri',
                            _listCabangIndustri.length == 0
                                ? ""
                                : _listCabangIndustri
                                    .where((e) =>
                                        e["id"] ==
                                        _dataIKM[0]["id_cabang_industri"])
                                    .toList()[0]["nama"], () {
                          setStateParam(
                              true,
                              "dropDown",
                              "id_cabang_industri",
                              "nama",
                              "Cabang Industri :",
                              "Cabang Industri :",
                              "",
                              "",
                              _listCabangIndustri,
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
                        ListLabelInput(
                            context,
                            'Nomor Telepon',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["nomor_telpon"] ?? "", () {
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
                        ListLabelInput(
                            context,
                            'Tahun Berdirinya Badan Usaha',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["tahun_badan_usaha"] ?? "", () {
                          setStateParam(
                              true,
                              "date",
                              "tahun_badan_usaha",
                              "",
                              "Tahun :",
                              "Tahun :",
                              "",
                              _dateValue,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 24.0),
                          child: customText(
                              context,
                              Color(0xff242F43),
                              'Jumlah Tenaga Kerja',
                              TextAlign.left,
                              16,
                              FontWeight.w700),
                        ),
                        ListLabelInput(
                            context,
                            'Laki-Laki',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["male"] ?? "", () {
                          setStateParam(
                              true,
                              "textfield",
                              "male",
                              "",
                              "Tenaga Kerja Laki-Laki :",
                              "Laki-Laki",
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
                        ListLabelInput(
                            context,
                            'Perempuan',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["famale"] ?? "", () {
                          setStateParam(
                              true,
                              "textfield",
                              "famale",
                              "",
                              "Tenaga Kerja Perempuan :",
                              "Perempuan",
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
                        ListLabelInput(
                            context,
                            'Satuan Produksi',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["satuan_produksi"] ?? "", () {
                          setStateParam(
                              true,
                              "textfield",
                              "satuan_produksi",
                              "",
                              "Satuan Produksi :",
                              "Satuan Produksi",
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
                        ListLabelDropDown(
                            context,
                            'Nilai Investasi (Per Tahun)',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["nilai_investasi"] ?? "", () {
                          setStateParam(
                              true,
                              "dropDown",
                              "nilai_investasi",
                              "",
                              "Nilai Investasi (Per Tahun) :",
                              "Nilai Investasi (Per Tahun)",
                              "",
                              "",
                              [
                                'Industri Kecil (< Rp.1.000.000.000)',
                                'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
                                'Industri Besar (> Rp.15.000.000.000)'
                              ],
                              "number",
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
                        ListLabelInput(
                            context,
                            'Nilai BB / BP (Bahan Baku / Bahan Penolong) (Per Tahun)',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["nilai_bb_bp"] ?? "", () {
                          setStateParam(
                              true,
                              "textfield",
                              "nilai_bb_bp",
                              "",
                              "Nilai BB / BP (Bahan Baku / Bahan Penolong) (Per Tahun) :",
                              "Nilai BB / BP (Bahan Baku / Bahan Penolong) (Per Tahun)",
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
                        ListLabelInput(
                            context,
                            'Jenis Badan Usaha',
                            _dataIKM.length == 0
                                ? ""
                                : _dataIKM[0]["jenis_ikm"] ?? "", () {
                          setStateParam(
                              true,
                              "dropDown",
                              "jenis_ikm",
                              "",
                              "Jenis Badan Usaha :",
                              "Jenis Badan Usaha",
                              "",
                              "",
                              ['UD', 'CV', 'PT'],
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
                        inputFormImage(
                            context,
                            "Foto Alat Produksi :",
                            "",
                            "${_storageUrl}" +
                                (_dataIKM[0]["foto_alat_produksi"] ?? "")
                                    .toString(),
                            _fotoAlatProduksiFile, () async {
                          await Permission.photos.request();
                          final picker = ImagePicker();

                          final pickedFile = await picker.getImage(
                              source: ImageSource.gallery);

                          setState(() {
                            if (pickedFile != null) {
                              _fotoAlatProduksi = pickedFile;
                              _fotoAlatProduksiFile = File(pickedFile.path);
                              _fotoAlatProduksiUrl = "";
                              // _imagePath = pickedFile.path;
                            } else {
                              print('No image selected.');
                            }
                          });
                          uploadImage("Alat");
                          Map<String, String> data = {
                            'foto_alat_produksi':
                                'foto_alat_produksi/Alat_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                          };
                          // print(data);
                          crud.putData(
                              '/badan_usaha/foto_alat_produksi/${_idUser}',
                              data);
                        }, () async {
                          await Permission.camera.request();
                          final picker = ImagePicker();

                          final pickedFile =
                              await picker.getImage(source: ImageSource.camera);

                          setState(() {
                            if (pickedFile != null) {
                              _fotoAlatProduksi = pickedFile;
                              _fotoAlatProduksiFile = File(pickedFile.path);
                              _fotoAlatProduksiUrl = "";
                              // _imagePath = pickedFile.path;
                            } else {
                              print('No image selected.');
                            }
                          });
                          uploadImage("Alat");
                          Map<String, String> data = {
                            'foto_alat_produksi':
                                'foto_alat_produksi/Alat_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                          };
                          crud.putData(
                              '/badan_usaha/foto_alat_produksi/${_idUser}',
                              data);
                        }),
                        inputFormImage(
                            context,
                            "Foto Ruang Produksi :",
                            "",
                            "${_storageUrl}" +
                                (_dataIKM[0]["foto_ruang_produksi"] ?? "")
                                    .toString(),
                            _fotoRuangProduksiFile, () async {
                          await Permission.photos.request();
                          final picker = ImagePicker();

                          final pickedFile = await picker.getImage(
                              source: ImageSource.gallery);

                          setState(() {
                            if (pickedFile != null) {
                              _fotoRuangProduksi = pickedFile;
                              _fotoRuangProduksiFile = File(pickedFile.path);
                              _fotoRuangProduksiUrl = "";
                              // _imagePath = pickedFile.path;
                            } else {
                              print('No image selected.');
                            }
                          });
                          uploadImage("Ruang");
                          Map<String, String> data = {
                            'foto_ruang_produksi':
                                'foto_ruang_produksi/Ruang_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                          };
                          crud.putData(
                              '/badan_usaha/foto_ruang_produksi/${_idUser}',
                              data);
                        }, () async {
                          await Permission.camera.request();
                          final picker = ImagePicker();

                          final pickedFile =
                              await picker.getImage(source: ImageSource.camera);

                          setState(() {
                            if (pickedFile != null) {
                              _fotoRuangProduksi = pickedFile;
                              _fotoRuangProduksiFile = File(pickedFile.path);
                              _fotoRuangProduksiUrl = "";
                              // _imagePath = pickedFile.path;
                            } else {
                              print('No image selected.');
                            }
                          });
                          uploadImage("Ruang");
                          Map<String, String> data = {
                            'foto_ruang_produksi':
                                'foto_ruang_produksi/Ruang_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                          };
                          crud.putData(
                              '/badan_usaha/foto_ruang_produksi/${_idUser}',
                              data);
                        }),
                      ],
                    ),
                  );
  }
}
