import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../Provider/ThemeProvider.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/DropDownStringStyle2.dart';
import '../Widget/inputFormStyle4.dart';

class FormPengajuanDana extends StatefulWidget {
  const FormPengajuanDana({Key? key}) : super(key: key);

  @override
  _FormPengajuanDanaState createState() => _FormPengajuanDanaState();
}

class _FormPengajuanDanaState extends State<FormPengajuanDana> {
  TextEditingController _nikController = new TextEditingController();
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
  String? _idInstansi = null;

  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List _listInstansi = [
    {"id": "1", "name": "BANK NTB SYARIAH"},
    {"id": "2", "name": "KOPERASI"},
  ];

  CRUD crud = new CRUD();

  getKabuatenQuery() {
    return '''
      query{
        Kabupaten{
          id
          name
        }
      }
    ''';
  }

  getKecamatanQuery() {
    return '''
      query{
        Kecamatan(id_kabupaten:"${_kabupaten}"){
          id
          name
        }
      }
    ''';
  }

  getKelurahanQuery() {
    return '''
      query{
        Kelurahan(id_kecamatan:"${_kecamatan}"){
          id
          name
        }
      }
    ''';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: SvgPicture.asset(
      //         "assets/images/backArrow.svg",
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: customText(context, Colors.black, "Detail Usaha", TextAlign.left,
      //       18, FontWeight.normal),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Instansi",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options: QueryOptions(document: gql(getKabuatenQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _kabupatenList = result.data?['Kabupaten'];
                  return dropDownStringStyle2(_idInstansi, 'Pilih Instansi',
                      _listInstansi, Color(0xffE4E5E7), (newValue) {
                    setState(() {
                      _idInstansi = newValue;
                    });
                  });
                },
              ),
            ),
            _idInstansi.toString().contains("bank")
                ? Text(_idInstansi!)
                : _idInstansi.toString().contains("koperasi")
                    ? Text(_idInstansi!)
                    : Text(_idInstansi.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: button2(
                          "kembali", Colors.white, Colors.black, context, () {
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: button2("Ajukan Dana", Colors.blue.shade600,
                          Color.fromARGB(255, 255, 255, 255), context, () {}),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
