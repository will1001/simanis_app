import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CardUMKM.dart';
import 'package:appsimanis/Widget/CardUMKM2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/DropDown3Style2.dart';
import 'package:appsimanis/Widget/DropDownString.dart';
import 'package:appsimanis/Widget/DropDownStringStyle3.dart';
import 'package:appsimanis/Widget/Dropdown2Style2.dart';
import 'package:appsimanis/Widget/Dropdown3.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/FilterButton.dart';
import 'package:appsimanis/Widget/FilterDrawer.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/SearchButton1.dart';
import 'package:appsimanis/Widget/SearchInput.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ListDataIKM extends StatefulWidget {
  final int loginCache;

  const ListDataIKM({Key? key, required this.loginCache}) : super(key: key);

  @override
  _ListDataIKMState createState() => _ListDataIKMState();
}

class _ListDataIKMState extends State<ListDataIKM> {
  final globalKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

  int _subMenu = 0;
  int _page = 1;
  List _listBadanUsaha = [];
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
  String? _cabangIndustri = null;
  String _lat = '';
  String _lng = '';
  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List _listCabangIndustri = [];
  List _listBadanUsahaNotNullFoto = [];
  bool _loading = true;
  bool _filterTerdekat = false;
  bool _openFilterMenu = false;
  Object? args = {};
  int _dataLoaded = 0;
  String _iDkategori = 'Semua';
  TextEditingController _keywordController = new TextEditingController();
  List _tabStatusVerikasi = [
    'Semua',
    'Sudah diverifikasi',
    'Belum diverifikasi'
  ];
  String _statusVerifikasi = 'null';

  var HeadTable = [
    'No',
    'Nama Perusahaan',
    'Nama Pemilik',
    'Alamat',
    'Status Verifikasi',
    'Nomor Telepon',
    // 'male',
    // 'famale',
    // 'nilai_investasi',
    // 'kapasitas_produksi',
  ];

  getBadanUsahaFilter(
      String? _idCabangIndustri,
      String status,
      String? idKabupaten,
      String? idKecamatan,
      String? idKelurahan,
      int _limit) {
    // print(
    //     '/badan_usaha/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan');

    switch (_idCabangIndustri) {
      case 'Semua':
        _idCabangIndustri = null;
        break;
      case 'Pangan':
        _idCabangIndustri = '006c4210-7806-11eb-9b1b-81d2fad81425';
        break;
      case 'Hulu Agro':
        _idCabangIndustri = '006d2610-7806-11eb-ab4c-a1abd6abcd37';
        break;
      case 'Permesinan, Alat Transportasi & Energi Terbarukan':
        _idCabangIndustri = '006d8f20-7806-11eb-9444-bd238317ed47';
        break;
      case 'Hasil Pertambangan':
        _idCabangIndustri = '006e3bd0-7806-11eb-a766-e1c38c7e931e';
        break;
      case 'Ekonomi Kreatif':
        _idCabangIndustri = '006f3b70-7806-11eb-ae50-d1725dc37289';
        break;
      case 'Kimia , Farmasi, Kosmetik & Kesehatan':
        _idCabangIndustri = '006eb850-7806-11eb-87a5-6fa3dfe46649';
        break;
      default:
    }
    if (_limit == 10) {
      _listBadanUsaha.clear();
    }
    crud
        .getData(
            '/badan_usaha/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan')
        .then((res) {
      // print(jsonDecode(res.body));
      setState(() {
        _listBadanUsaha.addAll(jsonDecode(res.body));
        _listBadanUsahaNotNullFoto = jsonDecode(res.body)
            .where((el) =>
                el['foto_alat_produksi'] != null &&
                el['foto_alat_produksi'] != '')
            .toList();
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  cariBadanUsaha(String keyword) {
    // print('keyword');
    // print(keyword);
    if (keyword == '') {
      getBadanUsaha();
    } else {
      getBadanUsaha();
    }
  }

  // getBadanUsaha() {
  //   crud.getData('/badan_usaha/limit/10').then((res) {
  //     // print(jsonDecode(res.body));
  //     setState(() {
  //       _listBadanUsaha = jsonDecode(res.body);
  //       _loading = false;
  //     });
  //   });
  // }

  getBadanUsaha() {
    var data = client.value
        .query(QueryOptions(document: gql(getBadanUsahaQuery(_page))));
    data.then((value) => {
          setState(() {
            _listBadanUsaha.addAll(value.data?['badanUsaha']);
            _loading = false;
          })
        });
  }

  getBadanUsahaTerdekat(int _limit, String lat, String lng, String status) {
    // print('/badan_usaha/terdekat/$lat/$lng/$_limit/$status');
    crud.getData('/badan_usaha/terdekat/$lat/$lng/$_limit/$status').then((res) {
      setState(() {
        if (_limit == 10) {
          _listBadanUsaha.clear();
          _loading = true;
        }
        _listBadanUsaha.addAll(jsonDecode(res.body));
        _listBadanUsahaNotNullFoto = jsonDecode(res.body)
            .where((el) =>
                el['foto_alat_produksi'] != null &&
                el['foto_alat_produksi'] != '')
            .toList();
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  getCabangIndsutri() {
    crud.getData('/cabang_industri').then((res) {
      setState(() {
        _listCabangIndustri.add({'id': '212', 'nama': 'Semua'});
        _listCabangIndustri.addAll(jsonDecode(res.body));
        // getBadanUsaha(10, _statusVerifikasi);
      });
    });
  }

  getLatLng(int _limit) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _lat = position.latitude.toString();
      _lng = position.longitude.toString();
      _filterTerdekat = true;
    });
    getBadanUsahaTerdekat(_limit, position.latitude.toString(),
        position.longitude.toString(), _statusVerifikasi);
  }

  getBadanUsahaQuery(int page) {
    return '''
     query{
                                  badanUsaha(page:${page},kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}"){
                                    id
                                    nik
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
                                    formal_informal
                                    nib_tahun
                                    nomor_sertifikat_halal_tahun
                                    sertifikat_merek_tahun
                                    nomor_test_report_tahun
                                    jenis_usaha
                                    cabang_industri
                                    sub_cabang_industri
                                    id_kbli
                                    investasi_modal
                                    jumlah_tenaga_kerja_pria
                                    jumlah_tenaga_kerja_wanita
                                    kapasitas_produksi_perbulan
                                    lat
                                    lng
                                    foto_alat_produksi
                                    foto_ruang_produksi
                                    media_sosial
                                  }
                                }
    ''';
  }

  _getMoreData() {
    setState(() {
      _page += 1;
    });
    getBadanUsaha();
  }

  @override
  void initState() {
    super.initState();

    if (widget.loginCache == 1) {
      getBadanUsaha();
      // getCabangIndsutri();
      // getBadanUsaha(10, _statusVerifikasi);
      // crud.getData('/provinsi/52/kabupaten').then((data) {
      //   //print(data.statusCode);
      //   setState(() {
      //     _listKabupaten = jsonDecode(data.body);
      //   });
      // });
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();

          // if (_iDkategori == 'Semua' &&
          //     _kabupaten == null &&
          //     _kecamatan == null &&
          //     _kelurahan == null &&
          //     !_filterTerdekat) {
          //   // getBadanUsaha(_dataLoaded + 10, _statusVerifikasi);
          // } else if (_filterTerdekat) {
          //   getLatLng(_dataLoaded + 10);
          // } else {
          //   getBadanUsahaFilter(_iDkategori, _statusVerifikasi, _kabupaten,
          //       _kecamatan, _kelurahan, _dataLoaded + 10);
          // }

        }
      });
    }
  }

  clearFilter() {
    setState(() {
      _iDkategori = 'Semua';
      _kabupaten = null;
      _kecamatan = null;
      _kelurahan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    List<Widget> filterWidget = [
      customText(context, Colors.black, 'Filters', TextAlign.left, 21,
          FontWeight.w700),

      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: customText(context, Colors.black, 'Sektor Industri',
            TextAlign.left, 14, FontWeight.w500),
      ),

      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 15),
        child: Row(
          children: [
            filterButton(context, 'Semua', _iDkategori, () {
              setState(() {
                _iDkategori = 'Semua';
              });
            }),
            filterButton(context, 'Pangan', _iDkategori, () {
              setState(() {
                _iDkategori = 'Pangan';
              });
            }),
            filterButton(context, 'Hulu Agro', _iDkategori, () {
              setState(() {
                _iDkategori = 'Hulu Agro';
              });
            }),
          ],
        ),
      ),
      filterButton(context, 'Permesinan, Alat Transportasi & Energi Terbarukan',
          _iDkategori, () {
        setState(() {
          _iDkategori = 'Permesinan, Alat Transportasi & Energi Terbarukan';
        });
      }),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
        child: Row(
          children: [
            filterButton(context, 'Hasil Pertambangan', _iDkategori, () {
              setState(() {
                _iDkategori = 'Hasil Pertambangan';
              });
            }),
            filterButton(context, 'Ekonomi Kreatif', _iDkategori, () {
              setState(() {
                _iDkategori = 'Ekonomi Kreatif';
              });
            }),
          ],
        ),
      ),

      filterButton(
          context, 'Kimia , Farmasi, Kosmetik & Kesehatan', _iDkategori, () {
        setState(() {
          _iDkategori = 'Kimia , Farmasi, Kosmetik & Kesehatan';
        });
      }),

      // dropDown3(_iDkategori, 'nama', 'Cabang Industri', _listCabangIndustri,
      //     (newValue) {
      //   setState(() {
      //     _iDkategori = newValue!;
      //     // setState(() {
      //     //   _loading = true;
      //     // });
      //     // if (newValue == '212') {
      //     //   getBadanUsaha(10, args.toString());
      //     // } else {
      //     //   getBadanUsahaFilter(_iDkategori, args.toString(), _kabupaten,
      //     //       _kecamatan, _kelurahan, 10);
      //     // }
      //   });
      // }),
      // dropDownString(_kabupaten, 'Kabupaten', _listKabupaten, (newValue) {
      //   // getBadanUsahaFilter(
      //   //     _iDkategori, args.toString(), newValue, null, null, 10);
      //   crud.getData('/kabupaten/' + newValue + '/kecamatan').then((data) {
      //     setState(() {
      //       // _loading = true;
      //       _kecamatan = null;
      //       _kelurahan = null;
      //       _listKecamatan.clear();
      //       _listKelurahan.clear();
      //       _listKecamatan = jsonDecode(data.body);
      //       _kabupaten = newValue;
      //     });
      //   });
      // }),
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: dropDown3style2(
            context, _kabupaten, 'name', 'Pilih', 'Kabupaten :', _listKabupaten,
            (newValue) {
          // getBadanUsahaFilter(
          //     _iDkategori, args.toString(), newValue, null, null, 10);
          crud.getData('/kabupaten/' + newValue + '/kecamatan').then((data) {
            setState(() {
              // _loading = true;
              _kecamatan = null;
              _kelurahan = null;
              _listKecamatan.clear();
              _listKelurahan.clear();
              _listKecamatan = jsonDecode(data.body);
              _kabupaten = newValue;
            });
          });
        }),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: dropDown3style2(
            context, _kecamatan, 'name', 'Pilih', 'Kecamatan :', _listKecamatan,
            (newValue) {
          // getBadanUsahaFilter(
          //     _iDkategori, args.toString(), _kabupaten, newValue, null, 10);
          crud.getData('/kecamatan/' + newValue + '/kelurahan').then((data) {
            setState(() {
              // _loading = true;
              _kelurahan = null;
              _listKelurahan.clear();
              _listKelurahan = jsonDecode(data.body);
              _kecamatan = newValue;
            });
          });
        }),
      ),

      Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: dropDown3style2(
            context, _kelurahan, 'name', 'Pilih', 'Kelurahan :', _listKelurahan,
            (newValue) {
          // getBadanUsahaFilter(
          //     _iDkategori, args.toString(), _kabupaten, _kecamatan, newValue, 10);
          setState(() {
            // _loading = true;
            _kelurahan = newValue;
          });
        }),
      ),
      // Text(_listKabupaten[0].toString()),
      // dropDownString(_kecamatan, 'Kecamatan', _listKecamatan, (newValue) {
      //   // getBadanUsahaFilter(
      //   //     _iDkategori, args.toString(), _kabupaten, newValue, null, 10);
      //   crud.getData('/kecamatan/' + newValue + '/kelurahan').then((data) {
      //     setState(() {
      //       // _loading = true;
      //       _kelurahan = null;
      //       _listKelurahan.clear();
      //       _listKelurahan = jsonDecode(data.body);
      //       _kecamatan = newValue;
      //     });
      //   });
      // }),

      // dropDownString(_kelurahan, 'Kelurahan', _listKelurahan, (newValue) {
      //   // getBadanUsahaFilter(
      //   //     _iDkategori, args.toString(), _kabupaten, _kecamatan, newValue, 10);
      //   setState(() {
      //     // _loading = true;
      //     _kelurahan = newValue;
      //   });
      // }),

      // button1('Terapkan filter', themeProvider.buttonColor, context, () {
      //   setState(() {
      //     _loading = true;
      //     _filterTerdekat = false;
      //   });
      //   if (_iDkategori == null &&
      //       _kabupaten == null &&
      //       _kecamatan == null &&
      //       _kelurahan == null) {
      //     getBadanUsaha(10, args.toString());
      //   } else {
      //     getBadanUsahaFilter(_iDkategori, args.toString(), _kabupaten,
      //         _kecamatan, _kelurahan, 10);
      //   }
      // }),
      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ButtonGradient1(context, 'Terapkan', 10, () {
          setState(() {
            _loading = true;
            _filterTerdekat = false;
          });
          if (_iDkategori == 'Semua' &&
              _kabupaten == null &&
              _kecamatan == null &&
              _kelurahan == null) {
            // getBadanUsaha(10, _statusVerifikasi);
            Navigator.pop(context);
          } else {
            getBadanUsahaFilter(_iDkategori, _statusVerifikasi, _kabupaten,
                _kecamatan, _kelurahan, 10);
            Navigator.pop(context);
          }
        }),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  clearFilter();
                  getBadanUsahaFilter(
                      null, _statusVerifikasi, null, null, null, 10);
                },
                child: customText(context, Color(0xff545C6C), 'Reset',
                    TextAlign.left, 12, FontWeight.w400))
          ],
        ),
      ),
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          // key: globalKey,
          // endDrawer: filterDrawer(context, filterWidget),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                    child: customText(context, Colors.black, 'Data UMKM',
                        TextAlign.left, 16, FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        scrollDirection: Axis.horizontal,
                        children: [
                          SearchButton1(
                              context, 'Cari UMKM', _keywordController, () {
                            setState(() {
                              _loading = true;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                            cariBadanUsaha(_keywordController.text);
                          }, () {
                            _keywordController.text = '';
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _listBadanUsaha.clear();
                              _loading = true;
                            });
                            // getBadanUsaha(10, 'null');
                            clearFilter();
                          }),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _openFilterMenu = true;
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff545C6C),
                                  ),
                                  customText(
                                      context,
                                      Color(0xff242F43),
                                      'Filter',
                                      TextAlign.left,
                                      12,
                                      FontWeight.w500)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 24),
                    child: Container(
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _tabStatusVerikasi
                            .asMap()
                            .map((i, e) => MapEntry(
                                i,
                                Padding(
                                  padding: const EdgeInsets.only(right: 69.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _subMenu = i;
                                        _loading = true;
                                        // _statusVerifikasi =
                                        //     e == 'Semua' ? 'null' : e;
                                      });
                                      // getBadanUsaha(
                                      //     10, (e == 'Semua' ? 'null' : e));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 4,
                                                    color: _subMenu == i
                                                        ? Color(0xff2BA33A)
                                                        : Colors.transparent)),
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: _subMenu == i
                                                    ? Color(0xff2BA33A)
                                                    : Color(0xffB2B5BC)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      controller: _scrollController,
                      children: _listBadanUsaha
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: cardUMKM2(context, e),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              AnimatedOpacity(
                opacity: _openFilterMenu ? 1 : 0,
                duration: Duration(seconds: 2),
                child: Opacity(
                  opacity: 0.38,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _openFilterMenu = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height *
                          (_openFilterMenu ? 1 : 0),
                      color: Color(0xff242F43),
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 1),
                child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *
                      (_openFilterMenu ? 0.6 : 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(context, Color(0xff242F43), 'Filters',
                                TextAlign.left, 14, FontWeight.w500),
                            customText(context, Color(0xff545C6C), 'Reset',
                                TextAlign.left, 12, FontWeight.w400),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 140,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                                // color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                border: Border.all(color: Color(0xffC8CBD0))),
                            child: GestureDetector(
                              onTap: () {
                                clearFilter();
                                getLatLng(10);
                                setState(() {
                                  _openFilterMenu = false;
                                });
                              },
                              child: customText(
                                  context,
                                  Color(0xff545C6C),
                                  'UMKM Terdekat',
                                  TextAlign.left,
                                  14,
                                  FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16, bottom: 4),
                        child: customText(context, Color(0xff242F43),
                            'Kabupaten', TextAlign.left, 14, FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: dropDownStringStyle3(
                            _kabupaten, 'Pilih kabupaten', _listKabupaten,
                            (newValue) {
                          crud
                              .getData('/kabupaten/' + newValue + '/kecamatan')
                              .then((data) {
                            setState(() {
                              _kecamatan = null;
                              _kelurahan = null;
                              _listKecamatan.clear();
                              _listKelurahan.clear();
                              _listKecamatan = jsonDecode(data.body);
                              _kabupaten = newValue;
                            });
                          });
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16, bottom: 4),
                        child: customText(context, Color(0xff242F43),
                            'Kecamatan', TextAlign.left, 14, FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: dropDownStringStyle3(
                            _kecamatan, 'Pilih kcamatan', _listKecamatan,
                            (newValue) {
                          crud
                              .getData('/kecamatan/' + newValue + '/kelurahan')
                              .then((data) {
                            setState(() {
                              _kelurahan = null;
                              _listKelurahan.clear();
                              _listKelurahan = jsonDecode(data.body);
                              _kecamatan = newValue;
                            });
                          });
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16, bottom: 4),
                        child: customText(context, Color(0xff242F43),
                            'Kelurahan', TextAlign.left, 14, FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: dropDownStringStyle3(
                            _kelurahan, 'Pilih Kelurahan', _listKelurahan,
                            (newValue) {
                          setState(() {
                            _kelurahan = newValue;
                          });
                        }),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 24),
                        child: button2('Terapkan', Color(0xff2BA33A),
                            Colors.white, context, () {
                          setState(() {
                            _loading = true;
                            _filterTerdekat = false;
                          });
                          if (_iDkategori == 'Semua' &&
                              _kabupaten == null &&
                              _kecamatan == null &&
                              _kelurahan == null) {
                            // getBadanUsaha(10, _statusVerifikasi);
                            // Navigator.pop(context);

                          } else {
                            getBadanUsahaFilter(_iDkategori, args.toString(),
                                _kabupaten, _kecamatan, _kelurahan, 10);
                            // Navigator.pop(context);

                          }
                          setState(() {
                            _openFilterMenu = false;
                            _loading = true;
                          });
                        }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        _loading ? loadingWidget(context) : Container()
      ],
    );
  }
}
