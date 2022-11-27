import 'dart:convert';
import 'dart:io';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/InputFormImage.dart';
import 'package:appsimanis/Widget/inputFormStyle4.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//test github
class AddProduk extends StatefulWidget {
  const AddProduk({Key? key}) : super(key: key);

  @override
  _AddProdukState createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  TextEditingController _namaProdukController = new TextEditingController();
  TextEditingController _deskripsiProdukController =
      new TextEditingController();
  TextEditingController _noSertifikatHalalController =
      new TextEditingController();
  TextEditingController _thnSertifikatHalalController =
      new TextEditingController();
  TextEditingController _noSertifikatHaKiController =
      new TextEditingController();
  TextEditingController _thnSertifikatHaKiController =
      new TextEditingController();
  TextEditingController _noSertifikatSNIController =
      new TextEditingController();
  TextEditingController _thnSertifikatSNIController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _fotoProdukFile;
  PickedFile? _fotoProduk;
  bool? _sertifikatHalal = false;
  bool? _sertifikatHaKi = false;
  bool? _sertifikatSNI = false;
  var args;
  int _jmlProduk = 0;
  bool _namaProdukError = false;
  bool _deskripsiProdukError = false;

  Future<void> uploadImage(int jmlProduk) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    var request = http.MultipartRequest('POST',
        Uri.parse("https://simanis.ntbprov.go.id/api/badan_usaha/uploadgbr"));
    request.files.add(http.MultipartFile(
        'file',
        File(_fotoProduk!.path).readAsBytes().asStream(),
        File(_fotoProduk!.path).lengthSync(),
        filename: (_fotoProduk!.path).toString().split('.').last));
    request.fields['audio'] = 'value';
    request.fields['name'] = "produk${jmlProduk + 1}_$idUserCache." +
        _fotoProduk!.path.toString().split('.').last;
    request.fields['tipe_foto'] = "Produk";
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {
      // print(value);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments
          as Map)["data_badan_usaha"];
      var arguments2 = (ModalRoute.of(context)!.settings.arguments
          as Map)["jml_produk_yg_dimiliki"];
      setState(() {
        args = arguments;
        _jmlProduk = int.parse(arguments2.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
            )),
        title: customText(context, Color(0xff242F43), "Tambah Prpduk",
            TextAlign.left, 20, FontWeight.w600),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // gradientBg(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Color(0xff242F43), "Nama Produk",
                        TextAlign.left, 14, FontWeight.w400),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 16),
                      child: inputFormStyle4(
                          null,
                          "Nama Produk",
                          "text",
                          "Nama Produk",
                          "Nama Produk Tidak Boleh Kosong",
                          _namaProdukError,
                          _namaProdukController,
                          false,
                          null,
                          () {}),
                    ),
                    customText(context, Color(0xff242F43), "Deskripsi Produk",
                        TextAlign.left, 14, FontWeight.w400),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 16),
                      child: inputFormStyle4(
                          null,
                          "Deskripsi Produk",
                          "text",
                          "Deskripsi Produk",
                          "Deskripsi Produk Tidak Boleh Kosong",
                          _deskripsiProdukError,
                          _deskripsiProdukController,
                          false,
                          null,
                          () {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customText(context, Colors.black, 'Sertifikat',
                              TextAlign.left, 16, FontWeight.w700)
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 32,
                          // height: 100,
                          child: CheckboxListTile(
                              title: customText(context, Color(0xff0A0A0A),
                                  'Halal', TextAlign.left, 14, FontWeight.w400),
                              value: _sertifikatHalal,
                              onChanged: (val) {
                                setState(() {
                                  _sertifikatHalal = val;
                                });
                              }),
                        )
                      ],
                    ),
                    _sertifikatHalal != null && _sertifikatHalal != false
                        ? Column(
                            children: [
                              inputForm(
                                  null,
                                  "Nomor Sertifikat",
                                  "number",
                                  "Nomor Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _noSertifikatHalalController,
                                  false),
                              inputForm(
                                  null,
                                  "Tahun Sertifikat",
                                  "number",
                                  "Tahun Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _thnSertifikatHalalController,
                                  false)
                            ],
                          )
                        : Container(),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 32,
                          // height: 100,
                          child: CheckboxListTile(
                              title: customText(context, Color(0xff0A0A0A),
                                  'HaKi', TextAlign.left, 14, FontWeight.w400),
                              value: _sertifikatHaKi,
                              onChanged: (val) {
                                setState(() {
                                  _sertifikatHaKi = val;
                                });
                              }),
                        )
                      ],
                    ),
                    _sertifikatHaKi != null && _sertifikatHaKi != false
                        ? Column(
                            children: [
                              inputForm(
                                  null,
                                  "Nomor Sertifikat",
                                  "number",
                                  "Nomor Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _noSertifikatHaKiController,
                                  false),
                              inputForm(
                                  null,
                                  "Tahun Sertifikat",
                                  "number",
                                  "Tahun Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _thnSertifikatHaKiController,
                                  false)
                            ],
                          )
                        : Container(),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 32,
                          // height: 100,
                          child: CheckboxListTile(
                              title: customText(context, Color(0xff0A0A0A),
                                  'HaKi', TextAlign.left, 14, FontWeight.w400),
                              value: _sertifikatSNI,
                              onChanged: (val) {
                                setState(() {
                                  _sertifikatSNI = val;
                                });
                              }),
                        )
                      ],
                    ),
                    _sertifikatSNI != null && _sertifikatSNI != false
                        ? Column(
                            children: [
                              inputForm(
                                  null,
                                  "Nomor Sertifikat",
                                  "number",
                                  "Nomor Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _noSertifikatSNIController,
                                  false),
                              inputForm(
                                  null,
                                  "Tahun Sertifikat",
                                  "number",
                                  "Tahun Sertifikat",
                                  "Tidak Boleh Kosong",
                                  _thnSertifikatSNIController,
                                  false)
                            ],
                          )
                        : Container(),
                    inputFormImage(
                        context, "Foto Produk", "", "", _fotoProdukFile,
                        () async {
                      await Permission.photos.request();
                      final picker = ImagePicker();

                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);

                      setState(() {
                        if (pickedFile != null) {
                          _fotoProduk = pickedFile;
                          _fotoProdukFile = File(pickedFile.path);
                          // _imagePath = pickedFile.path;
                        } else {
                          print('No image selected.');
                        }
                      });
                      // Map<String, String> data = {
                      //   'foto_alat_produksi':
                      //       'foto_alat_produksi/Alat_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                      // };
                      // // print(data);
                      // crud.putData(
                      //     '/badan_usaha/foto_alat_produksi/${_idUser}',
                      //     data);
                    }, () async {
                      await Permission.camera.request();
                      final picker = ImagePicker();

                      final pickedFile =
                          await picker.getImage(source: ImageSource.camera);

                      setState(() {
                        if (pickedFile != null) {
                          _fotoProduk = pickedFile;
                          _fotoProdukFile = File(pickedFile.path);
                          // _imagePath = pickedFile.path;
                        } else {
                          print('No image selected.');
                        }
                      });
                      // Map<String, String> data = {
                      //   'foto_alat_produksi':
                      //       'foto_alat_produksi/Alat_${_idUser}.${pickedFile!.path.toString().split('.').last}'
                      // };
                      // crud.putData(
                      //     '/badan_usaha/foto_alat_produksi/${_idUser}',
                      //     data);
                    }),
                    button2("Tambah Produk", Color(0xff2BA33A), Colors.white,
                        context, () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? idUserCache = prefs.getString('idUser');
                      if (_formKey.currentState!.validate()) {
                        Map<String, String> data = {
                          "nama": _namaProdukController.text,
                          "id_badan_usaha": args[0]["id"],
                          "sertifikat": "",
                          "sertifikat_halal":
                              "{'no_sert':'${_noSertifikatHalalController.text}','thn_sert':'${_thnSertifikatHalalController.text}'}",
                          "sertifikat_haki":
                              "{'no_sert':'${_noSertifikatHaKiController.text}','thn_sert':'${_thnSertifikatHaKiController.text}'}",
                          "sertifikat_sni":
                              "{'no_sert':'${_noSertifikatSNIController.text}','thn_sert':'${_thnSertifikatSNIController.text}'}",
                          "barcode": "",
                          "deskripsi": _deskripsiProdukController.text,
                          'foto':
                              'foto_produk/produk${_jmlProduk + 1}_$idUserCache.${_fotoProduk!.path.toString().split('.').last}'
                        };
                        uploadImage(_jmlProduk);
                        // print(data);
                        crud.postData("/produk", data).then((res) {
                          if (res.statusCode == 201) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(
                                context, '/produkPageMember',
                                arguments: {"data": args});
                          } else {
                            print("error");
                          }
                        });
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
