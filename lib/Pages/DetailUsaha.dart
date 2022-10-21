import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../Provider/ThemeProvider.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/DropDownStringStyle2.dart';
import '../Widget/inputFormStyle4.dart';

class DetailUsaha extends StatefulWidget {
  const DetailUsaha({Key? key}) : super(key: key);

  @override
  _DetailUsahaState createState() => _DetailUsahaState();
}

class _DetailUsahaState extends State<DetailUsaha> {
  TextEditingController _nikController = new TextEditingController();
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;

  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];

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
        title: customText(context, Colors.black, "Detail Usaha", TextAlign.left,
            18, FontWeight.normal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "NIK",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(null, "Nomor Induk Kependudukan", "text", "NIK",
                "NIK Tidak Boleh Kosong", false, _nikController, false, () {}),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Nama",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(null, "Nama Anda", "text", "Nama",
                "Nama Tidak Boleh Kosong", false, _nikController, false, () {}),
            customText(context, Colors.white, "Kabupaten", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Kab/Kota",
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
                  return dropDownStringStyle2(
                      _kabupaten,
                      'Pilih Kota / Kabupaten',
                      _kabupatenList,
                      Color(0xffE4E5E7), (newValue) {
                    setState(() {
                      _kabupaten = newValue;
                      _kecamatan = null;
                      _kelurahan = null;
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Kecamatan",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options: QueryOptions(document: gql(getKecamatanQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _KecamatanList = result.data?['Kecamatan'];
                  return dropDownStringStyle2(
                      _kecamatan,
                      'Pilih Kecamatan',
                      _kabupaten == null ? [] : _KecamatanList,
                      Color(0xffE4E5E7), (newValue) {
                    setState(() {
                      _kecamatan = newValue;
                      _kelurahan = null;
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Kelurahan/Desa", TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options: QueryOptions(document: gql(getKelurahanQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _KelurahanList = result.data?['Kelurahan'];
                  return dropDownStringStyle2(
                      _kelurahan,
                      'Pilih Kelurahan',
                      _kecamatan == null ? [] : _KelurahanList,
                      Color(0xffE4E5E7), (newValue) {
                    setState(() {
                      _kelurahan = newValue;
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Alamat Lengkap", TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(
                null,
                "Alamat Lengkap Usaha",
                "text",
                "Alamat Lengkap",
                "Alamat Tidak Boleh Kosong",
                false,
                _nikController,
                false,
                () {}),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "No Hp",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(
                null,
                "Nomor Hp Anda",
                "text",
                "Alamat Lengkap",
                "Alamat Tidak Boleh Kosong",
                false,
                _nikController,
                false,
                () {}),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Nama Usaha",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(
                null,
                "Nama Usaha Anda",
                "text",
                "Alamat Lengkap",
                "Alamat Tidak Boleh Kosong",
                false,
                _nikController,
                false,
                () {}),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Bentuk Usaha", TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(
                null,
                "Pilih Bentuk Usaha",
                "text",
                "Alamat Lengkap",
                "Alamat Tidak Boleh Kosong",
                false,
                _nikController,
                false,
                () {}),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Tahun Berdiri", TextAlign.left, 17, FontWeight.normal),
            ),
            inputFormStyle4(
                null,
                "Tahun Berdiri",
                "text",
                "Alamat Lengkap",
                "Alamat Tidak Boleh Kosong",
                false,
                _nikController,
                false,
                () {}),
            button2("Simpan Perubahan", Colors.blue.shade600,
                Color.fromARGB(255, 255, 255, 255), context, () {}),
          ],
        ),
      ),
    );
  }
}
