import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';

class DataTambahan extends StatefulWidget {
  const DataTambahan({Key? key}) : super(key: key);

  @override
  _DataTambahanState createState() => _DataTambahanState();
}

class _DataTambahanState extends State<DataTambahan> {
  String _idUser = "";
  File? _ktp;
  File? _kk;
  String _ktpKet = "";
  String _kkKet = "";

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

  uploadKTP() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // File file = File(result.files.single.path);
      // print(result.files.single.path!.readAsBytesSync());
      // print(result.files.single.path);
      File file = File(result.files.single.path.toString());
      setState(() {
        _ktp = file;
        _ktpKet = result.files.single.path.toString();
      });
    } else {
      // User canceled the picker
    }
  }

  uploadKK() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path.toString());

    if (result != null) {
      // File file = File(result.files.single.path);
      // print(result.files.single.path);
      setState(() {
        _kk = file;
        _kkKet = result.files.single.path.toString();
      });
    } else {
      // User canceled the picker
    }
  }

  String dataPendukungMutation = r"""
mutation($ktp: Upload!,$kk: Upload!){
        DataPendukung(
          user_id:"ebc772bc23874135b490d9d828e7f6e8",
          ktp:$ktp,
          kk:$kk,
        ) {
          messagges
        }
      }
""";
  // dataPendukungMutation() {
  //   return '''
  //     mutation(\$ktp: Upload!,\$kk: Upload!){
  //       DataPendukung(
  //         user_id:"${_idUser}",
  //         ktp:\$ktp,
  //         kk:\$kk,
  //       ) {
  //         messagges
  //       }
  //     }
  //   ''';
  // }

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
        title: customText(context, Colors.black, "Data Tambahan",
            TextAlign.left, 18, FontWeight.normal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            customText(context, Colors.black, "KTP", TextAlign.left, 14,
                FontWeight.w400),
            GestureDetector(
              onTap: uploadKTP,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4),
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
              child: Text(_ktpKet),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: customText(context, Colors.black, "KK", TextAlign.left, 14,
                  FontWeight.w400),
            ),
            GestureDetector(
              onTap: uploadKK,
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
              child: Text(_kkKet),
            ),
            Mutation(
              options: MutationOptions(
                document: gql(dataPendukungMutation),

                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  FocusManager.instance.primaryFocus?.unfocus();

                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/pengajuanDana');
                },
                onError: (err) {
                  print(err);
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return button2("Submit Pengajuan", Colors.blue.shade600,
                    Color.fromARGB(255, 255, 255, 255), context, () {
                  // print(_ktp);
                  // print(_kk);
                  var byteData = _ktp!.readAsBytesSync();
                  var multipartFile = MultipartFile.fromBytes(
                    'ktp',
                    byteData,
                    filename: '${DateTime.now().second}.png',
                    // contentType: MediaType("image", "png"),
                  );
                  var byteData2 = _kk!.readAsBytesSync();
                  var multipartFile2 = MultipartFile.fromBytes(
                    'kk',
                    byteData2,
                    filename: '${DateTime.now().second}.png',
                    // contentType: MediaType("image", "png"),
                  );
                  runMutation(<String, dynamic>{
                    "ktp": multipartFile,
                    "kk": multipartFile2,
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
