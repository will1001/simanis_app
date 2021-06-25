import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/CardProduk.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/KategoriButton.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/SearchInput.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String _keyword = "";
  String _kategori = "";
  String _iDkategori = "";
  List _listCabangIndustri = [];
  List _listBadanUsaha = [];
  List _listBadanUsahaNotNullFoto = [];
  List _listBadanUsahaCabangIndustri = [];
  bool _loading = true;
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";

  getCabangIndsutri() {
    crud.getData("/cabang_industri").then((res) {
      setState(() {
        _listCabangIndustri = jsonDecode(res.body);
        _iDkategori = _listCabangIndustri[0]["id"];
        _kategori = _listCabangIndustri[0]["nama"];
        getBadanUsaha();
      });
    });
  }

  getBadanUsaha() {
    crud.getData("/badan_usaha").then((res) {
      setState(() {
        _listBadanUsaha = jsonDecode(res.body);
        _listBadanUsahaNotNullFoto = jsonDecode(res.body)
            .where((el) =>
                el["foto_alat_produksi"] != null &&
                el["foto_alat_produksi"] != "")
            .toList();
        _listBadanUsahaCabangIndustri = _listBadanUsahaNotNullFoto
            .where((el) => el["id_cabang_industri"] == _iDkategori)
            .toList();
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCabangIndsutri();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: textLabel("Produk", 15, Colors.black, "", FontWeight.w400),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? loadingWidget(context)
          : Stack(
              children: [
                gradientBg(),
                ListView(
                  children: [
                    searchInput(context),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: textLabel(
                          "Cabang Industri",
                          22,
                          themeProvider.fontColor1,
                          themeProvider.fontFamily,
                          FontWeight.bold),
                    ),
                    SizedBox(
                      height: 70,
                      // width: 100,
                      child: Container(
                        // color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 11, right: 16, bottom: 10),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _listCabangIndustri.map((e) {
                              return kategoriButton(
                                  context, e["nama"], _kategori, () {
                                setState(() {
                                  _kategori = e["nama"];
                                  _iDkategori = e["id"];
                                  _listBadanUsahaCabangIndustri =
                                      _listBadanUsahaNotNullFoto
                                          .where((el) =>
                                              el["id_cabang_industri"] ==
                                              _iDkategori)
                                          .toList();
                                });
                              });
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.amber,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1 / 1.3,
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        primary: true,
                        children: _listBadanUsahaCabangIndustri.map((e) {
                          return cardProduk(
                              e["nama_perusahaan"],
                              e["nama_pemilik"],
                              _storageUrl + e["foto_alat_produksi"],
                              context,
                              () {});
                        }).toList(),
                        
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
