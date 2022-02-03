import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/CardProduk.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdukPageMember extends StatefulWidget {
  const ProdukPageMember({Key? key}) : super(key: key);

  @override
  _ProdukPageMemberState createState() => _ProdukPageMemberState();
}

class _ProdukPageMemberState extends State<ProdukPageMember> {
  bool _loading = true;
  List _listProduk = [];
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  int _dataLoaded = 0;
  var args;

  getProdukMember(int _limit, String idIKM) {
    crud.getData("/produk/id_ikm/${idIKM}").then((res) {
      // print(res);
      setState(() {
        if (_limit == 10) {
          _listProduk.clear();
          _loading = true;
        }
        _listProduk.addAll(jsonDecode(res.body));
        _loading = false;
        _dataLoaded = _limit;
      });
    });

    Future.delayed(const Duration(milliseconds: 3000), () async {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments =
          (ModalRoute.of(context)!.settings.arguments as Map)["data"];
      setState(() {
        args = arguments;
      });
      // print("asdad");
      // print(arguments[0]["id"]);
      getProdukMember(10, arguments[0]["id"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: Stack(
            children: [
              // gradientBg(),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              color: Colors.black,
                            )),
                        customText(context, Color(0xff242F43), "Produk Saya",
                            TextAlign.left, 20, FontWeight.w600)
                      ],
                    ),
                  ),
                  _listProduk.length == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _loading
                                ? Container()
                                : textLabel(
                                    "Produk Anda Kosong, Tekan Tombol + untuk Menambah Produk Anda",
                                    17,
                                    themeProvider.fontColor2,
                                    themeProvider.fontFamily,
                                    FontWeight.bold),
                          ),
                        )
                      : Container(
                          // color: Colors.amber,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 1 / 0.4,
                            crossAxisCount: 1,
                            shrinkWrap: true,
                            primary: true,
                            children: _listProduk.map((e) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/detailsProduk",
                                      arguments: e);
                                },
                                child: Card(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      children: [
                                        e["foto"] == null || e["foto"] == ""
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    width: 120,
                                                    // height: 100,
                                                    color:
                                                        themeProvider.bgColor,
                                                  ),
                                                  Icon(Icons.image_outlined,
                                                      size: 24,
                                                      color:
                                                          Colors.grey.shade500)
                                                ],
                                              )
                                            : Container(
                                                color: Colors.amber,
                                                // height: 100,
                                                width: 120,
                                                child: Image.network(
                                                  _storageUrl + e["foto"],
                                                  width: 120,
                                                  // height: 100,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    230,
                                                child: customText(
                                                    context,
                                                    Color(0xff242F43),
                                                    e["nama"],
                                                    TextAlign.left,
                                                    14,
                                                    FontWeight.w500),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    230,
                                                child: customText(
                                                    context,
                                                    Color(0xff242F43),
                                                    e["nama_perusahaan"],
                                                    TextAlign.left,
                                                    12,
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AddProduk', arguments: {
                  "data_badan_usaha": args,
                  "jml_produk_yg_dimiliki": _listProduk.length
                });
              },
              child: const Icon(Icons.add),
              backgroundColor: Color(0xff2BA33A)),
        ),
        _loading ? loadingWidget(context) : Container()
      ],
    );
  }
}
