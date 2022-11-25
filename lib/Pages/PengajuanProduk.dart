import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class PengajuanProduk extends StatefulWidget {
  const PengajuanProduk({Key? key}) : super(key: key);

  @override
  _PengajuanProdukState createState() => _PengajuanProdukState();
}

class _PengajuanProdukState extends State<PengajuanProduk> {
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

  getPengajuanProdukQuery() {
    return '''
      query{
        Produk(user_id:"${_idUser}"){
          id
          id_badan_usaha
          nama
          deskripsi
          foto
          sertifikat_halal
          sertifikat_haki
          sertifikat_sni
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
        title: customText(context, Colors.black, "Pengajuan Produk",
            TextAlign.left, 18, FontWeight.normal),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Query(
          options: QueryOptions(document: gql(getPengajuanProdukQuery())),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Text("");
            }
            final _PengajuanProdukList = result.data?['Produk'];
            return ListView(
              children: _PengajuanProdukList.map<Widget>((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    // padding: const EdgeInsets.all(16),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(16.0),
                    // ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                'https://simanis.ntbprov.go.id' + e['foto'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                      context,
                                      Colors.black,
                                      "Miniatur Kayu - Becak",
                                      TextAlign.left,
                                      18,
                                      FontWeight.bold),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SvgPicture.asset(
                                            "assets/images/tas_icon.svg",
                                          ),
                                        ),
                                        customText(
                                            context,
                                            Colors.black38,
                                            "Mataram Craft Shop",
                                            TextAlign.left,
                                            14,
                                            FontWeight.normal)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // SvgPicture.asset(
                              //   "assets/images/delete_icon.svg",
                              // )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        )
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
          Navigator.pushNamed(context, '/formPengajuanProduk');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
