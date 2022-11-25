import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController _jumlah_dana_koperasi_controller =
      new TextEditingController();
  TextEditingController _jangka_waktu_koperasi_controller =
      new TextEditingController();
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
  String? _idInstansi = null;
  String? _userIdInstansi = null;
  String? _idJumlahPinjaman = null;
  String? _idJangkaWaktu = null;
  String? _jenisAkad = null;
  String? _jumlah_dana_koperasi = null;
  String? _jangka_waktu_koperasi = null;

  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List _listJenisAkad = [
    {"id": "Murobhahah", "nama": "Murobhahah"},
    {"id": "Mudharobah", "nama": "Mudharobah"},
    {"id": "Musyarakah", "nama": "Musyarakah"}
  ];
  String _idUser = "";

  CRUD crud = new CRUD();

  getInstansiQuery() {
    return '''
      query{
        Instansi{
          id
          user_id
          nama
        }
      }
    ''';
  }

  getJumlahPinjamanQuery(id) {
    return '''
      query{
        ListJumlahPinjaman(id_instansi:"${id}"){
          id
          jumlah
        }
      }
    ''';
  }

  getJangkaWaktuQuery(id) {
    return '''
      query{
        ListJangkaWaktu(id_instansi:"${id}"){
          id
          waktu
        }
      }
    ''';
  }

  getSimulasiAngsuranQuery(instansi, JumlahPinjaman, jangkaWaktu) {
    return '''
      query{
        SimulasiAngsuran(id_instansi:"${instansi}",id_jml_pinjaman:"${JumlahPinjaman}",id_jangka_waktu:"${jangkaWaktu}"){
          angsuran
        }
      }
    ''';
  }

  PengajuanDanaMutation(user_id, jumlah_dana, waktu_pinjaman, alasan, instansi,
      jenis_pengajuan, jumlah_dana_bank, jangka_waktu_bank) {
    return '''
      mutation{
        PengajuanDana(
          user_id:"${user_id}",
          jumlah_dana:"${jumlah_dana}",
          waktu_pinjaman:"${waktu_pinjaman}",
          alasan:"${alasan}",
          instansi:"${instansi}",
          jenis_pengajuan:"${jenis_pengajuan}",
          jumlah_dana_bank:"${jumlah_dana_bank}",
          jangka_waktu_bank:"${jangka_waktu_bank}"
        ) {
          messagges
        }
      }
    ''';
  }

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
                options: QueryOptions(document: gql(getInstansiQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _dataList = result.data?['Instansi'];
                  return dropDownStringStyle2(_idInstansi, 'Pilih Instansi',
                      _dataList, Color(0xffE4E5E7), (newValue) {
                    var user_id =
                        _dataList.where((e) => e["id"] == newValue).toList();
                    // print(user_id[0]['user_id']);
                    setState(() {
                      _idInstansi = newValue;
                      _userIdInstansi = user_id[0]['user_id'];
                    });
                  });
                },
              ),
            ),
            _idInstansi == "2"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // inputFormStyle4(
                      //     null,
                      //     "Jumlah Pembiayaan",
                      //     "number",
                      //     "Jumlah Pembiayaan",
                      //     "Jumlah Pembiayaan Tidak Boleh Kosong",
                      //     false,
                      //     _jumlah_dana_koperasi_controller,
                      //     false,
                      //     () {}),
                      TextField(
                        onChanged: (val) {
                          _jumlah_dana_koperasi = val;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'Jumlah Pembiayaan',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: TextField(
                          onChanged: (val) {
                            _jangka_waktu_koperasi = val;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelText: 'Jangka Waktu (/ Bulan)',
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                      //   child: inputFormStyle4(
                      //       null,
                      //       "Jangka Waktu (/ Bulan)",
                      //       "number",
                      //       "Jangka Waktu (/ Bulan)",
                      //       "Jangka Waktu Tidak Boleh Kosong",
                      //       false,
                      //       _jangka_waktu_koperasi_controller,
                      //       false,
                      //       () {}),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: dropDownStringStyle2(
                            _jenisAkad,
                            'Pilih Jenis Akad',
                            _listJenisAkad,
                            Color(0xffE4E5E7), (newValue) {
                          setState(() {
                            _jenisAkad = newValue;
                          });
                        }),
                      )
                    ],
                  )
                : _idInstansi == "1"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: customText(
                                context,
                                themeProvider.fontColor1,
                                "Jumlah Pinjaman",
                                TextAlign.left,
                                17,
                                FontWeight.normal),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 16),
                            child: Query(
                              options: QueryOptions(
                                  document:
                                      gql(getJumlahPinjamanQuery(_idInstansi))),
                              builder: (QueryResult result,
                                  {fetchMore, refetch}) {
                                if (result.hasException) {
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return Text("");
                                }
                                final _dataList =
                                    result.data?['ListJumlahPinjaman'];
                                return dropDownStringStyle2(
                                    _idJumlahPinjaman,
                                    'Pilih Jumlah Pinjaman',
                                    _dataList,
                                    Color(0xffE4E5E7), (newValue) {
                                  setState(() {
                                    _idJumlahPinjaman = newValue;
                                  });
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: customText(
                                context,
                                themeProvider.fontColor1,
                                "Jangka Waktu",
                                TextAlign.left,
                                17,
                                FontWeight.normal),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 16),
                            child: Query(
                              options: QueryOptions(
                                  document:
                                      gql(getJangkaWaktuQuery(_idInstansi))),
                              builder: (QueryResult result,
                                  {fetchMore, refetch}) {
                                if (result.hasException) {
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return Text("");
                                }
                                final _dataList =
                                    result.data?['ListJangkaWaktu'];
                                return dropDownStringStyle2(
                                    _idJangkaWaktu,
                                    'Pilih Jangka Waktu',
                                    _dataList,
                                    Color(0xffE4E5E7), (newValue) {
                                  setState(() {
                                    _idJangkaWaktu = newValue;
                                  });
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 16),
                            child: Query(
                              options: QueryOptions(
                                  document: gql(getSimulasiAngsuranQuery(
                                      _idInstansi,
                                      _idJumlahPinjaman,
                                      _idJangkaWaktu))),
                              builder: (QueryResult result,
                                  {fetchMore, refetch}) {
                                if (result.hasException) {
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return Text("");
                                }
                                final _dataList =
                                    result.data?['SimulasiAngsuran'];
                                var formatter = NumberFormat('#,###,000');
                                return Text("Total Angsuran: " +
                                    (_dataList.length != 0
                                        ? formatter
                                            .format(int.parse(
                                                _dataList[0]['angsuran']))
                                            .toString()
                                        : ""));
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
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
                Mutation(
                  options: MutationOptions(
                    document: gql(_idInstansi == "1"
                        ? PengajuanDanaMutation(
                            _idUser,
                            null,
                            null,
                            "",
                            _userIdInstansi,
                            null,
                            _idJumlahPinjaman,
                            _idJangkaWaktu,
                          )
                        : PengajuanDanaMutation(
                            _idUser,
                            _jumlah_dana_koperasi,
                            _jangka_waktu_koperasi,
                            "",
                            _userIdInstansi,
                            _jenisAkad,
                            null,
                            null,
                          )),
                    onCompleted: (dynamic resultData) {
                     

                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/pengajuanDana');

                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onError: (err) {
                      print(err);
                    },
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: button2(
                              "Ajukan Dana",
                              Colors.blue.shade600,
                              Color.fromARGB(255, 255, 255, 255),
                              context,
                              () => runMutation({
                                    "user_id": _idUser,
                                    "jumlah_dana": null,
                                    "waktu_pinjaman": null,
                                    "alasan": "",
                                    "instansi": _userIdInstansi,
                                    "jenis_pengajuan": null,
                                    "jumlah_dana_bank": _idJumlahPinjaman,
                                    "jangka_waktu_bank": _idJangkaWaktu
                                  })),
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
