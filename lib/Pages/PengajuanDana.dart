import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class PengajuanDana extends StatefulWidget {
  const PengajuanDana({Key? key}) : super(key: key);

  @override
  _PengajuanDanaState createState() => _PengajuanDanaState();
}

class _PengajuanDanaState extends State<PengajuanDana> {
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  String _idUser = "";

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

  getPengajuanDanaQuery() {
    return '''
      query{
        PengajuanDana(user_id:"${_idUser}"){
          id
          created_at
          jumlah_dana
          waktu_pinjaman
          status
          alasan
        }
      }
    ''';
  }

  getDataPendukungQuery() {
    return '''
      query{
        DataPendukung(user_id:"${_idUser}"){
          id
          id_badan_usaha
          ktp
          kk
        }
      }
    ''';
  }

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
        title: customText(context, Colors.black, "Pengajuan Dana",
            TextAlign.left, 18, FontWeight.normal),
      ),
      backgroundColor: Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Query(
          options: QueryOptions(document: gql(getPengajuanDanaQuery())),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Text("");
            }
            final _pengajuanDanaList = result.data?['PengajuanDana'];
            return ListView(
              children: _pengajuanDanaList.map<Widget>((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(context, Colors.black26, "Tanggal Pengajuan",
                            TextAlign.left, 18, FontWeight.normal),
                        customText(context, Colors.black, e['created_at'],
                            TextAlign.left, 18, FontWeight.normal),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                        ),
                        customText(context, Colors.black26, "Jumlah Dana",
                            TextAlign.left, 18, FontWeight.normal),
                        customText(
                            context,
                            Colors.black,
                            "Rp " + e['jumlah_dana'],
                            TextAlign.left,
                            18,
                            FontWeight.normal),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                        ),
                        customText(context, Colors.black26, "Jangka Waktu",
                            TextAlign.left, 18, FontWeight.normal),
                        customText(
                            context,
                            Colors.black,
                            e['waktu_pinjaman'] + " Bulan",
                            TextAlign.left,
                            18,
                            FontWeight.normal),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                        ),
                        customText(context, Colors.black26, "Status Pengajuan",
                            TextAlign.left, 18, FontWeight.normal),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: e['status'] == "Ditolak"
                                  ? Colors.red.shade100
                                  : e['status'] == "Menunggu"
                                      ? Colors.yellow.shade100
                                      : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: customText(
                              context,
                              e['status'] == "Ditolak"
                                  ? Colors.red
                                  : e['status'] == "Menunggu"
                                      ? Colors.orange
                                      : Colors.blue,
                              e['status'],
                              TextAlign.left,
                              18,
                              FontWeight.normal),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                        ),
                        customText(context, Colors.black26, "Keterangan",
                            TextAlign.left, 18, FontWeight.normal),
                        customText(context, Colors.black, e['alasan'],
                            TextAlign.left, 18, FontWeight.normal),
                        e['alasan'].toString().contains("Dinas Perindustrian")
                            ? Query(
                                options: QueryOptions(
                                    document: gql(getDataPendukungQuery())),
                                builder: (QueryResult result,
                                    {fetchMore, refetch}) {
                                  if (result.hasException) {
                                    return Text(result.exception.toString());
                                  }
                                  if (result.isLoading) {
                                    return Text("");
                                  }
                                  final _dataList =
                                      result.data?['DataPendukung'];

                                  // print(result.data?['DataPendukung'].length !=
                                  //     0);

                                  if (result.data?['DataPendukung'].length !=
                                      0) {
                                    return Container();
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: button2(
                                        "Lengkapi Data",
                                        Colors.blue.shade600,
                                        Color.fromARGB(255, 255, 255, 255),
                                        context, () {
                                      Navigator.pushNamed(
                                          context, '/dataTambahan');
                                    }),
                                  );
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/formPengajuanDana');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
