import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class Kartu extends StatefulWidget {
  const Kartu({Key? key}) : super(key: key);

  @override
  _KartuState createState() => _KartuState();
}

class _KartuState extends State<Kartu> {
  bool _passError = false;
  bool _obscPass = true;
  String _idUser = "";
  File? _foto;
  String _fotoKet = "";

  TextEditingController passwordTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    getIdUser();
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUser');

    setState(() {
      _idUser = idUser!;
    });
  }

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

  getKartuQuery() {
    return '''
      query{
        Kartu(user_id:"${_idUser}"){
          nik
          id_cabang_industri
          id_kabupaten
          nama_direktur
          alamat_lengkap
          nama_usaha
          kabupaten
          foto
        }
      }
    ''';
  }

  String KartuMutation = r'''
      mutation($user_id: String!,$foto: Upload!){
        Kartu(user_id: $user_id,foto: $foto){
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
        title: customText(context, Colors.black, "Kartu", TextAlign.left, 18,
            FontWeight.normal),
      ),
      backgroundColor: Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Query(
          options: QueryOptions(document: gql(getKartuQuery())),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Text("");
            }
            final _dataList = result.data?['Kartu'];
            return ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                              "https://simanis.ntbprov.go.id/" +
                                  _dataList[0]['foto'],
                              height: 100),
                          Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                    context,
                                    Colors.black,
                                    "No Kartu." +
                                        _dataList[0]['nik'].substring(
                                            _dataList[0]['nik']
                                                    .toString()
                                                    .length -
                                                4,
                                            _dataList[0]['nik']
                                                .toString()
                                                .length) +
                                        _dataList[0]['id_cabang_industri']
                                            .toString() +
                                        _dataList[0]['id_kabupaten'],
                                    TextAlign.left,
                                    20,
                                    FontWeight.bold),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: customText(
                                      context,
                                      Colors.black,
                                      "NIK " + _dataList[0]['nik'],
                                      TextAlign.center,
                                      18,
                                      FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(context, Colors.black26, "Nama",
                                      TextAlign.left, 18, FontWeight.normal),
                                  Container(
                                    width: 210,
                                    child: customText(
                                        context,
                                        Colors.black,
                                        _dataList[0]['nama_direktur'],
                                        TextAlign.left,
                                        18,
                                        FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(context, Colors.black26, "Alamat",
                                      TextAlign.left, 18, FontWeight.normal),
                                  Container(
                                    width: 210,
                                    child: customText(
                                        context,
                                        Colors.black,
                                        _dataList[0]['alamat_lengkap'],
                                        TextAlign.left,
                                        18,
                                        FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(
                                      context,
                                      Colors.black26,
                                      "Badan Usaha",
                                      TextAlign.left,
                                      18,
                                      FontWeight.normal),
                                  Container(
                                    width: 210,
                                    child: customText(
                                        context,
                                        Colors.black,
                                        _dataList[0]['nama_usaha'],
                                        TextAlign.left,
                                        18,
                                        FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(
                                      context,
                                      Colors.black26,
                                      "Kabupaten",
                                      TextAlign.left,
                                      18,
                                      FontWeight.normal),
                                  Container(
                                      width: 210,
                                      child: customText(
                                          context,
                                          Colors.black,
                                          _dataList[0]['kabupaten'],
                                          TextAlign.left,
                                          18,
                                          FontWeight.normal)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: uploadFoto,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text("Pilih Foto"),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff374151), width: 1),
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
                        document: gql(KartuMutation),

                        // or do something with the result.data on completion
                        onCompleted: (dynamic resultData) {
                          Navigator.popAndPushNamed(context, '/kartu');

                          FocusManager.instance.primaryFocus?.unfocus();

                          // print(data);
                        },
                        onError: (err) {
                          print(err);
                        },
                      ),
                      builder: (RunMutation runMutation, QueryResult? result) {
                        return Container(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: button2(
                                "Ganti Foto",
                                Colors.blue.shade600,
                                Color.fromARGB(255, 255, 255, 255),
                                context, () {
                              var byteData = _foto!.readAsBytesSync();
                              var multipartFile = MultipartFile.fromBytes(
                                'ktp',
                                byteData,
                                filename: '${DateTime.now().second}.png',
                                // contentType: MediaType("image", "png"),
                              );
                              runMutation(<String, dynamic>{
                                "user_id": _idUser,
                                "foto": multipartFile,
                              });
                            }),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
