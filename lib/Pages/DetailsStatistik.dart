import 'dart:convert';

import 'package:appsimanis/Widget/CardUMKM2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/SearchButton1.dart';
import 'package:flutter/material.dart';

class DetailsStatistik extends StatefulWidget {
  final String title;
  final String kabupaten;
  final String kecamatan;
  final String kelurahan;
  final String industri;
  final String ikmBaru;
  final String halal;
  final String haki;
  final String sni;
  const DetailsStatistik(
      {Key? key,
      required this.title,
      required this.kabupaten,
      required this.kecamatan,
      required this.kelurahan,
      required this.industri,
      required this.ikmBaru,
      required this.halal,
      required this.haki,
      required this.sni})
      : super(key: key);

  @override
  _DetailsStatistikState createState() => _DetailsStatistikState();
}

class _DetailsStatistikState extends State<DetailsStatistik> {
  TextEditingController _keywordController = new TextEditingController();
  bool _loading = true;
  List _listBadanUsaha = [];
  int _dataLoaded = 10;
  ScrollController _scrollController = new ScrollController();

  cariBadanUsaha(String keyword, int limit, String _indsutri) {
    // print('keyword');
    // print(keyword);

    crud
        .getData(
            '/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/$_indsutri/null/$limit/$keyword')
        .then((res) {
      setState(() {
        _listBadanUsaha.clear();
        _listBadanUsaha = jsonDecode(res.body);
        // _keywordController.text = '';
      });
    });
  }

  getBadanUsaha(String _link) {
    // print(_link);
    crud.getData(_link).then((res) {
      print(jsonDecode(res.body));
      setState(() {
        // _listBadanUsaha.clear();
        _listBadanUsaha.addAll(jsonDecode(res.body));
        // print(jsonDecode(res.body));
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.kabupaten == "null" &&
        widget.kecamatan == "null" &&
        widget.kelurahan == "null") {
      if (widget.industri != "") {
        print(
            "/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/${widget.industri}/null/${_dataLoaded}/");
        getBadanUsaha(
            '/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/${widget.industri}/null/${_dataLoaded}/');
      }
      if (widget.ikmBaru == "true") {
        getBadanUsaha('/badan_usaha/detailsStatistik/IKMBaru/${_dataLoaded}');
      }
      if (widget.halal != "" && widget.haki != "" && widget.sni != "") {
        getBadanUsaha(
            '/badan_usaha/detailsStatistik/totalTenagaKerja/sertifikatFilter/${widget.halal}/${widget.haki}/${widget.sni}/${_dataLoaded}/${_keywordController.text}');
      }
    } else {
      if (widget.industri != "") {
        print(
            "/badan_usaha/detailsStatistik/kabkot/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${widget.industri}/${_dataLoaded}/${_keywordController.text}");
        getBadanUsaha(
            '/badan_usaha/detailsStatistik/kabkot/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${widget.industri}/${_dataLoaded}/${_keywordController.text}');
      }
      if (widget.ikmBaru == "true") {
        print(
            "/badan_usaha/detailsStatistik/IKMBaruLokasi/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${_dataLoaded}/${_keywordController.text}");
        getBadanUsaha(
            '/badan_usaha/detailsStatistik/IKMBaruLokasi/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${_dataLoaded}/${_keywordController.text}');
      }
      if (widget.halal != "" && widget.haki != "" && widget.sni != "") {
        getBadanUsaha(
            '/badan_usaha/detailsStatistik/totalTenagaKerja/sertifikatFilterLokasi/${widget.halal}/${widget.haki}/${widget.sni}/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${_dataLoaded}/{cari?}');
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _dataLoaded += 10;
        });
        if (widget.kabupaten == "null" &&
            widget.kecamatan == "null" &&
            widget.kelurahan == "null") {
          if (widget.industri != "") {
            print(
                "/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/${widget.industri}/null/${_dataLoaded}/");
            getBadanUsaha(
                '/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/${widget.industri}/null/${_dataLoaded}/');
          }
          if (widget.ikmBaru == "true") {
            print('/badan_usaha/detailsStatistik/IKMBaru/${_dataLoaded}');
            getBadanUsaha(
                '/badan_usaha/detailsStatistik/IKMBaru/${_dataLoaded}');
          }
          if (widget.halal != "" && widget.haki != "" && widget.sni != "") {
            getBadanUsaha(
                '/badan_usaha/detailsStatistik/totalTenagaKerja/sertifikatFilter/${widget.halal}/${widget.haki}/${widget.sni}/${_dataLoaded}/${_keywordController.text}');
          }
        } else {
          if (widget.industri != "") {
            print(
                "/badan_usaha/detailsStatistik/kabkot/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${widget.industri}/${_dataLoaded}/${_keywordController.text}");
            getBadanUsaha(
                '/badan_usaha/detailsStatistik/kabkot/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${widget.industri}/${_dataLoaded}/${_keywordController.text}');
          }
          if (widget.ikmBaru == "true") {
            getBadanUsaha(
                '/badan_usaha/detailsStatistik/IKMBaruLokasi/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${_dataLoaded}/${_keywordController.text}');
          }
          if (widget.halal != "" && widget.haki != "" && widget.sni != "") {
            getBadanUsaha(
                '/badan_usaha/detailsStatistik/totalTenagaKerja/sertifikatFilterLokasi/${widget.halal}/${widget.haki}/${widget.sni}/${widget.kabupaten}/${widget.kecamatan}/${widget.kelurahan}/${_dataLoaded}/{cari?}');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                child: customText(context, Colors.black, widget.title,
                    TextAlign.left, 16, FontWeight.w500),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0, right: 16),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 50,
              //     child: ListView(
              //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       scrollDirection: Axis.horizontal,
              //       children: [
              //         SearchButton1(context, 'Cari UMKM', _keywordController,
              //             () {
              //           setState(() {
              //             _loading = true;
              //           });
              //           FocusScope.of(context).requestFocus(FocusNode());
              //           cariBadanUsaha(
              //               _keywordController.text, 10, widget.industri);
              //         }, () {
              //           // _keywordController.text = '';
              //           // FocusScope.of(context).requestFocus(FocusNode());
              //           // setState(() {
              //           //   _listBadanUsaha.clear();
              //           //   _loading = true;
              //           // });
              //           // getBadanUsaha(10, 'null');
              //           // clearFilter();
              //         }),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView(
                  controller: _scrollController,
                  children: _listBadanUsaha
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: cardUMKM2(context, e),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          _loading ? loadingWidget(context) : Container()
        ],
      ),
    );
  }
}
