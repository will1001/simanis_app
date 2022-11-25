import 'dart:convert';
import 'dart:io';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/ThemeProvider.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/DropDownStringStyle2.dart';
import '../Widget/InputFormStyle3.dart';
import '../Widget/inputFormStyle4.dart';

class FormPengajuanProduk extends StatefulWidget {
  const FormPengajuanProduk({Key? key}) : super(key: key);

  @override
  _FormPengajuanProdukState createState() => _FormPengajuanProdukState();
}

class _FormPengajuanProdukState extends State<FormPengajuanProduk> {
  File? _foto;
  String _fotoKet = "";
  String _deskripsi = "";

  bool _namaProdukError = false;
  bool _sertifikat_halal_noError = false;
  bool _sertifikat_halal_thnError = false;
  bool _sertifikat_haki_noError = false;
  bool _sertifikat_haki_thnError = false;
  bool _sertifikat_sni_noError = false;
  bool _sertifikat_sni_thnError = false;
  TextEditingController namaProdukTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_halal_noTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_halal_thnTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_haki_noTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_haki_thnTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_sni_noTextEditingController =
      new TextEditingController();
  TextEditingController sertifikat_sni_thnTextEditingController =
      new TextEditingController();

  String _idUser = "";

  CRUD crud = new CRUD();

  String PengajuanProdukMutation = r'''
      mutation($user_id: String!,$sertifikat_halal_thn: String!,$sertifikat_halal_no: String!,$sertifikat_haki_thn: String!,$sertifikat_haki_no: String!,$sertifikat_sni_thn: String!,$sertifikat_sni_no: String!,$nama: String!,$deskripsi: String!,$foto: Upload!){
        PengajuanProduk(user_id: $user_id,sertifikat_halal_no: $sertifikat_halal_no,sertifikat_halal_thn: $sertifikat_halal_thn,sertifikat_haki_no: $sertifikat_haki_no,sertifikat_haki_thn: $sertifikat_haki_thn,sertifikat_sni_no: $sertifikat_sni_no,sertifikat_sni_thn: $sertifikat_sni_thn,nama: $nama,deskripsi: $deskripsi,foto: $foto){
          messagges
        }
      }
    ''';

  uploadFoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // File file = File(result.files.single.path);
      // print(result.files.single.path!.readAsBytesSync());
      // print(result.files.single.path);
      File file = File(result.files.single.path.toString());
      setState(() {
        _foto = file;
        _fotoKet = result.files.single.path.toString();
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    namaProdukTextEditingController.addListener(() {});
    sertifikat_halal_noTextEditingController.addListener(() {});
    sertifikat_halal_thnTextEditingController.addListener(() {});
    sertifikat_haki_noTextEditingController.addListener(() {});
    sertifikat_haki_thnTextEditingController.addListener(() {});
    sertifikat_sni_noTextEditingController.addListener(() {});
    sertifikat_sni_thnTextEditingController.addListener(() {});

    getIdUser();
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUser');

    setState(() {
      _idUser = idUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black12,
            height: 2.0,
          ),
        ),
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
        title: customText(context, Colors.black, "Pengajuan Produk",
            TextAlign.left, 18, FontWeight.normal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            customText(context, Colors.black, "Nama Produk", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 24),
              child: inputFormStyle3(
                  null,
                  "Nama Produk",
                  "text",
                  "Nama Produk",
                  "Nama Produk Tidak Boleh Kosong",
                  _namaProdukError,
                  namaProdukTextEditingController,
                  false,
                  () {}),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "No Sertifikat HAKI",
                        TextAlign.left, 14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "No Sertifikat HAKI",
                            "text",
                            "No Sertifikat HAKI",
                            "No Sertifikat HAKI Tidak Boleh Kosong",
                            _sertifikat_halal_noError,
                            sertifikat_halal_noTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Tahun", TextAlign.left,
                        14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "Tahun",
                            "text",
                            "Tahun",
                            "Tahun Tidak Boleh Kosong",
                            _sertifikat_halal_thnError,
                            sertifikat_halal_thnTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "No Sertifikat HAKI",
                        TextAlign.left, 14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "No Sertifikat HAKI",
                            "text",
                            "No Sertifikat HAKI",
                            "No Sertifikat HAKI Tidak Boleh Kosong",
                            _sertifikat_haki_noError,
                            sertifikat_haki_noTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Tahun", TextAlign.left,
                        14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "Tahun",
                            "text",
                            "Tahun",
                            "Tahun Tidak Boleh Kosong",
                            _sertifikat_haki_thnError,
                            sertifikat_haki_thnTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "No Sertifikat HAKI",
                        TextAlign.left, 14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "No Sertifikat HAKI",
                            "text",
                            "No Sertifikat HAKI",
                            "No Sertifikat HAKI Tidak Boleh Kosong",
                            _sertifikat_sni_noError,
                            sertifikat_sni_noTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Tahun", TextAlign.left,
                        14, FontWeight.w400),
                    Container(
                      width: 150,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: inputFormStyle3(
                            null,
                            "Tahun",
                            "text",
                            "Tahun",
                            "Tahun Tidak Boleh Kosong",
                            _sertifikat_sni_thnError,
                            sertifikat_sni_thnTextEditingController,
                            false,
                            () {}),
                      ),
                    )
                  ],
                ),
              ],
            ),
            customText(context, Colors.black, "Deskripsi Produk",
                TextAlign.left, 14, FontWeight.w400),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _deskripsi = val;
                    });
                  },
                  maxLines: 8, //or null
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.black38,
                        ),
                      ),
                      hintText: "Enter your text here"),
                ),
              ),
            ),
            customText(context, Colors.black, "Upload Foto", TextAlign.left, 14,
                FontWeight.w400),
            GestureDetector(
              onTap: uploadFoto,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/images/file.svg"),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                        child: Container(),
                      ),
                      customText(
                          context,
                          Colors.black,
                          "Click here to Upload a file",
                          TextAlign.left,
                          14,
                          FontWeight.w400),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_fotoKet),
            ),
            Mutation(
              options: MutationOptions(
                document: gql(PengajuanProdukMutation),

                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  // String msg = resultData['PengajuanProduk']['messagges'];
                  // print(resultData);
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/pengajuanProduk');
                  // if (msg != "success") {
                  //   setState(() {
                  //     _errMsg = msg;
                  //   });
                  // } else {
                  //   Map<String, String> data = {
                  //     "id": resultData['login']['id'],
                  //     "nama": resultData['login']['nama'],
                  //     "foto": resultData['login']['foto'],
                  //   };
                  //   functionGroup.saveCache(data);
                  //   Navigator.pushNamed(context, '/homeLayoutPage');
                  // }
                  FocusManager.instance.primaryFocus?.unfocus();

                  // print(data);
                },
                onError: (err) {
                  print(err);
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return button2("Simpan Perubahan", Colors.blue.shade600,
                    Color.fromARGB(255, 255, 255, 255), context, () {
                  var byteData = _foto!.readAsBytesSync();
                  var multipartFile = MultipartFile.fromBytes(
                    'ktp',
                    byteData,
                    filename: '${DateTime.now().second}.png',
                    // contentType: MediaType("image", "png"),
                  );
                  runMutation(<String, dynamic>{
                    "user_id": _idUser,
                    "sertifikat_halal_no":
                        sertifikat_halal_noTextEditingController.text,
                    "sertifikat_halal_thn":
                        sertifikat_halal_thnTextEditingController.text,
                    "sertifikat_haki_no":
                        sertifikat_haki_noTextEditingController.text,
                    "sertifikat_haki_thn":
                        sertifikat_haki_thnTextEditingController.text,
                    "sertifikat_sni_no":
                        sertifikat_sni_noTextEditingController.text,
                    "sertifikat_sni_thn":
                        sertifikat_sni_thnTextEditingController.text,
                    "nama": namaProdukTextEditingController.text,
                    "deskripsi": _deskripsi,
                    "foto": multipartFile,
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
