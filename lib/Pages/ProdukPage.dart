import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CardProduk4.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/DropDown3Style2.dart';
import 'package:appsimanis/Widget/DropDownStringStyle3.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/FilterButton.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/SearchButton1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../Widget/CardUMKM3.dart';

class ProdukPage extends StatefulWidget {
  final String kategoriID;
  final String aksesLink;
  final int loginCache;

  const ProdukPage(
      {Key? key,
      required this.kategoriID,
      required this.aksesLink,
      required this.loginCache})
      : super(key: key);
  // const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _keywordController = new TextEditingController();
  String _iDkategori = "null";
  int _dataLoaded = 0;
  String? _kabupaten;
  String? _kecamatan;
  String? _kelurahan;
  bool _filterTerdekat = false;
  List _listCabangIndustri = [];
  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List _listBadanUsaha = [];
  List _listProduk = [];
  List _listBadanUsahaCabangIndustri = [
    {'id': 'null', 'deskripsi': 'Semua'},
    {'id': '006c4210-7806-11eb-9b1b-81d2fad81425', 'deskripsi': 'Pangan'},
    {'id': '006d2610-7806-11eb-ab4c-a1abd6abcd37', 'deskripsi': 'Hulu Agro'},
    {
      'id': '006d8f20-7806-11eb-9444-bd238317ed47',
      'deskripsi': 'Permesinan, Alat Transportasi & Energi Terbarukan'
    },
    {
      'id': '006e3bd0-7806-11eb-a766-e1c38c7e931e',
      'deskripsi': 'Hasil Pertambangan'
    },
    {
      'id': '006f3b70-7806-11eb-ae50-d1725dc37289',
      'deskripsi': 'Ekonomi Kreatif'
    },
    {
      'id': '006eb850-7806-11eb-87a5-6fa3dfe46649',
      'deskripsi': 'Kimia , Farmasi, Kosmetik & Kesehatan'
    },
  ];
  bool _loading = true;
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  bool _openFilterMenu = false;

  getCabangIndsutri() {
    crud.getData("/cabang_industri").then((res) {
      // print(jsonDecode(res.body));
      setState(() {
        _listCabangIndustri.add({'id': '212', 'nama': 'Semua'});
        _listCabangIndustri.addAll(jsonDecode(res.body));
        // _iDkategori = _listCabangIndustri[0]["id"];
        getBadanUsaha(10, "null");
      });
    });
  }

  getLatLng(int _limit) async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _filterTerdekat = true;
    });
    getBadanUsahaTerdekat(_limit, position.latitude.toString(),
        position.longitude.toString(), "Sudah diverifikasi");
  }

  getBadanUsahaTerdekat(int _limit, String lat, String lng, String status) {
    // print("/badan_usaha/terdekat/$lat/$lng/$_limit/$status");
    crud.getData("/badan_usaha/terdekat/$lat/$lng/$_limit/$status").then((res) {
      setState(() {
        if (_limit == 10) {
          _listBadanUsaha.clear();
          _loading = true;
        }
        _listBadanUsaha.addAll(jsonDecode(res.body));
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  getProduk(int _limit) {
    crud.getData("/produk/limit/$_limit").then((res) {
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
  }

  clearFilter() {
    setState(() {
      _iDkategori = "Semua";
      _kabupaten = null;
      _kecamatan = null;
      _kelurahan = null;
    });
  }

  // getBadanUsaha() {
  //   crud.getData("/badan_usaha").then((res) {
  //     setState(() {
  //       _listBadanUsaha = jsonDecode(res.body);
  //       // _listBadanUsahaNotNullFoto = jsonDecode(res.body)
  //       //     .where((el) =>
  //       //         el["foto_alat_produksi"] != null &&
  //       //         el["foto_alat_produksi"] != "")
  //       //     .toList();
  //       // _listBadanUsahaCabangIndustri = _listBadanUsahaNotNullFoto
  //       //     .where((el) => el["id_cabang_industri"] == _iDkategori)
  //       //     .toList();
  //       _loading = false;
  //     });
  //   });
  // }
  getBadanUsaha(int _limit, String status) {
    if (_limit == 10) {
      _listBadanUsaha.clear();
    }
    // print("/badan_usaha/limit/$_limit/$status");
    crud.getData("/badan_usaha/limit/$_limit/$status").then((res) {
      // print(res.statusCode);
      setState(() {
        _listBadanUsaha = jsonDecode(res.body);
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  convertIdKategori(String _idCabangIndustri) {
    switch (_idCabangIndustri) {
      case "null":
        return "Semua";
      case "006c4210-7806-11eb-9b1b-81d2fad81425":
        return "Pangan";

      case "006d2610-7806-11eb-ab4c-a1abd6abcd37":
        return "Hulu Agro";
      case "006d8f20-7806-11eb-9444-bd238317ed47":
        return "Permesinan, Alat Transportasi & Energi Terbarukan";
      case "006e3bd0-7806-11eb-a766-e1c38c7e931e":
        return "Hasil Pertambangan";
      case "006f3b70-7806-11eb-ae50-d1725dc37289":
        return "Ekonomi Kreatif";
      case "006eb850-7806-11eb-87a5-6fa3dfe46649":
        return "Kimia , Farmasi, Kosmetik & Kesehatan";
      default:
        return "";
    }
  }

  getBadanUsahaFilter(
      String? _idCabangIndustri,
      String status,
      String? idKabupaten,
      String? idKecamatan,
      String? idKelurahan,
      int _limit) {
    // print(
    //     "/badan_usaha/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan");

    switch (_idCabangIndustri) {
      case "Semua":
        _idCabangIndustri = null;
        break;
      case "Pangan":
        _idCabangIndustri = "006c4210-7806-11eb-9b1b-81d2fad81425";
        break;
      case "Hulu Agro":
        _idCabangIndustri = "006d2610-7806-11eb-ab4c-a1abd6abcd37";
        break;
      case "Permesinan, Alat Transportasi & Energi Terbarukan":
        _idCabangIndustri = "006d8f20-7806-11eb-9444-bd238317ed47";
        break;
      case "Hasil Pertambangan":
        _idCabangIndustri = "006e3bd0-7806-11eb-a766-e1c38c7e931e";
        break;
      case "Ekonomi Kreatif":
        _idCabangIndustri = "006f3b70-7806-11eb-ae50-d1725dc37289";
        break;
      case "Kimia , Farmasi, Kosmetik & Kesehatan":
        _idCabangIndustri = "006eb850-7806-11eb-87a5-6fa3dfe46649";
        break;
      default:
    }
    if (_limit == 10) {
      _listBadanUsaha.clear();
    }
    crud
        .getData(
            "/badan_usaha/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan")
        .then((res) {
      // print(jsonDecode(res.body));
      setState(() {
        _listBadanUsaha.addAll(jsonDecode(res.body));
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  getProdukFilter(String? _idCabangIndustri, String status, String? idKabupaten,
      String? idKecamatan, String? idKelurahan, int _limit) {
    // switch (_idCabangIndustri) {
    //   case "Semua":
    //     _idCabangIndustri = null;
    //     break;
    //   case "Pangan":
    //     _idCabangIndustri = "006c4210-7806-11eb-9b1b-81d2fad81425";
    //     break;
    //   case "Hulu Agro":
    //     _idCabangIndustri = "006d2610-7806-11eb-ab4c-a1abd6abcd37";
    //     break;
    //   case "Permesinan, Alat Transportasi & Energi Terbarukan":
    //     _idCabangIndustri = "006d8f20-7806-11eb-9444-bd238317ed47";
    //     break;
    //   case "Hasil Pertambangan":
    //     _idCabangIndustri = "006e3bd0-7806-11eb-a766-e1c38c7e931e";
    //     break;
    //   case "Ekonomi Kreatif":
    //     _idCabangIndustri = "006f3b70-7806-11eb-ae50-d1725dc37289";
    //     break;
    //   case "Kimia , Farmasi, Kosmetik & Kesehatan":
    //     _idCabangIndustri = "006eb850-7806-11eb-87a5-6fa3dfe46649";
    //     break;
    //   default:
    // }
    if (_limit == 10) {
      _listProduk.clear();
    }
    // print(
    //     '/produk/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan');
    crud
        .getData(
            "/produk/filter/$status/$_limit/$_idCabangIndustri/$idKabupaten/$idKecamatan/$idKelurahan")
        .then((res) {
      setState(() {
        _listProduk.addAll(jsonDecode(res.body));
        _loading = false;
        _dataLoaded = _limit;
      });
    });
  }

  cariBadanUsaha(String keyword) {
    crud.getData("/badan_usaha/cari/$keyword").then((res) {
      setState(() {
        _listBadanUsaha.clear();
        _listBadanUsaha.addAll(jsonDecode(res.body));
        _loading = false;
        // _keywordController.text = "";
      });
    });
  }

  cariProduk(String keyword) {
    if (keyword == "") {
      getProduk(10);
    } else {
      crud.getData("/produk/cari/$keyword").then((res) {
        setState(() {
          _listProduk.clear();
          _listProduk.addAll(jsonDecode(res.body));
          _loading = false;
          // _keywordController.text = "";
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.loginCache == 3) {
      crud.getData("/provinsi/52/kabupaten").then((data) {
        // print(jsonDecode(data.body));
        // print("nmnmnmnmnmm");
        // print(widget.kategoriID);
        //print(data.statusCode);
        setState(() {
          _listKabupaten = jsonDecode(data.body);
          _iDkategori = widget.kategoriID;
        });
      });
      getCabangIndsutri();
      if (widget.kategoriID == "null" &&
          _kabupaten == null &&
          _kecamatan == null &&
          _kelurahan == null &&
          !_filterTerdekat) {
        getProduk(_dataLoaded + 10);
      } else {
        getProdukFilter(widget.kategoriID, 'null', _kabupaten, _kecamatan,
            _kelurahan, _dataLoaded + 10);
      }

      // getBadanUsaha(10, "Sudah diverifikasi");
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_iDkategori == "Semua" &&
              _kabupaten == null &&
              _kecamatan == null &&
              _kelurahan == null &&
              !_filterTerdekat) {
            getProduk(_dataLoaded + 10);
          } else {
            getProdukFilter(widget.kategoriID, 'null', _kabupaten, _kecamatan,
                _kelurahan, _dataLoaded + 10);
          }
        }
      });
      // if (_scrollController.position.pixels >=
      //     _scrollController.position.maxScrollExtent) {
      //   print("object");
      //   // if (_iDkategori == "Semua" &&
      //   //     _kabupaten == null &&
      //   //     _kecamatan == null &&
      //   //     _kelurahan == null &&
      //   //     !_filterTerdekat) {
      //   //   getProduk(_dataLoaded + 10);
      //   // } else {
      //   //   getProdukFilter(_iDkategori, "null", _kabupaten, _kecamatan, _kelurahan,
      //   //       _dataLoaded + 10);
      //   // }
      // }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_iDkategori);
    _listProduk = [
      {
        'nama': "Sepatu",
        'harga': "20.000",
        'deskripsi':
            "Sepatu etnik kain tenun bali Tampil gaya, trendy dengan produk yang dibuat dengan bahan yg nyaman dipakai.Sepatu kain tenun bali tersedia berbagai motif dan warna, bahan kain tenun jepara dilapis spon 2 mm + merymesh Outsole : PPC uk 37 s/d 40",
        'id_cabang_industri': "2",
        'nama_usaha': "PT makmur sejahtera",
        "no_hp": "081703999678",
        "kabupaten": "Kota Mataram",
        "kecamatan": "Mataram",
        "kelurahan": "Punia",
        "lat": "6.12",
        "lng": "6.12"
      },
      {
        'nama': "Baju",
        'harga': "40.000",
        'deskripsi':
            "Sepatu etnik kain tenun bali Tampil gaya, trendy dengan produk yang dibuat dengan bahan yg nyaman dipakai.Sepatu kain tenun bali tersedia berbagai motif dan warna, bahan kain tenun jepara dilapis spon 2 mm + merymesh Outsole : PPC uk 37 s/d 40",
        'id_cabang_industri': "2",
        'nama_usaha': "PT makmur sejahtera",
        "no_hp": "081703999678",
        "kabupaten": "Kota Mataram",
        "kecamatan": "Mataram",
        "kelurahan": "Punia",
        "lat": "6.12",
        "lng": "6.12"
      },
      {
        'nama': "Kripik",
        'harga': "50.000",
        'deskripsi':
            "Sepatu etnik kain tenun bali Tampil gaya, trendy dengan produk yang dibuat dengan bahan yg nyaman dipakai.Sepatu kain tenun bali tersedia berbagai motif dan warna, bahan kain tenun jepara dilapis spon 2 mm + merymesh Outsole : PPC uk 37 s/d 40",
        'id_cabang_industri': "2",
        'nama_usaha': "PT makmur sejahtera",
        "no_hp": "081703999678",
        "kabupaten": "Kota Mataram",
        "kecamatan": "Mataram",
        "kelurahan": "Punia",
        "lat": "6.12",
        "lng": "6.12"
      },
    ];
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    List<Widget> filterWidget = [
      customText(context, Colors.black, "Filters", TextAlign.left, 21,
          FontWeight.w700),

      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: customText(context, Colors.black, "Sektor Industri",
            TextAlign.left, 14, FontWeight.w500),
      ),

      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 15),
        child: Row(
          children: [
            filterButton(context, 'Semua', _iDkategori == "null" ? "Semua" : "",
                () {
              setState(() {
                _iDkategori = "null";
              });
            }),
            filterButton(context, 'Pangan', _iDkategori, () {
              setState(() {
                _iDkategori = "Pangan";
              });
            }),
            filterButton(context, 'Hulu Agro', _iDkategori, () {
              setState(() {
                _iDkategori = "Hulu Agro";
              });
            }),
          ],
        ),
      ),
      filterButton(context, 'Permesinan, Alat Transportasi & Energi Terbarukan',
          _iDkategori, () {
        setState(() {
          _iDkategori = "Permesinan, Alat Transportasi & Energi Terbarukan";
        });
      }),
      Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
        child: Row(
          children: [
            filterButton(context, 'Hasil Pertambangan', _iDkategori, () {
              setState(() {
                _iDkategori = "Hasil Pertambangan";
              });
            }),
            filterButton(context, 'Ekonomi Kreatif', _iDkategori, () {
              setState(() {
                _iDkategori = "Ekonomi Kreatif";
              });
            }),
          ],
        ),
      ),

      filterButton(
          context, 'Kimia , Farmasi, Kosmetik & Kesehatan', _iDkategori, () {
        setState(() {
          _iDkategori = "Kimia , Farmasi, Kosmetik & Kesehatan";
        });
      }),

      // dropDown3(_iDkategori, "nama", "Cabang Industri", _listCabangIndustri,
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
      //   crud.getData("/kabupaten/" + newValue + "/kecamatan").then((data) {
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
          crud.getData("/kabupaten/" + newValue + "/kecamatan").then((data) {
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
            context, _kabupaten, 'name', 'Pilih', 'Kecamatan :', _listKecamatan,
            (newValue) {
          // getBadanUsahaFilter(
          //     _iDkategori, args.toString(), _kabupaten, newValue, null, 10);
          crud.getData("/kecamatan/" + newValue + "/kelurahan").then((data) {
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
            context, _kabupaten, 'name', 'Pilih', 'Kelurahan :', _listKelurahan,
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
      //   crud.getData("/kecamatan/" + newValue + "/kelurahan").then((data) {
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

      // button1("Terapkan filter", themeProvider.buttonColor, context, () {
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
          Navigator.pop(context);
          setState(() {
            _loading = true;
            _filterTerdekat = false;
          });
          if (_iDkategori == "Semua" &&
              _kabupaten == null &&
              _kecamatan == null &&
              _kelurahan == null) {
            getProduk(10);
            Navigator.pop(context);
          } else {
            getProdukFilter(_iDkategori, "Sudah diverifikasi", _kabupaten,
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
                  // getBadanUsahaFilter(
                  //     null, "Sudah diverifikasi", null, null, null, 10);
                },
                child: Text("Reset"))
          ],
        ),
      ),
    ];
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SearchButton1(
                              context, "Cari Produk", _keywordController, () {
                            setState(() {
                              _loading = true;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                            cariBadanUsaha(_keywordController.text);
                          }, () {
                            _keywordController.text = "";
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _listBadanUsaha.clear();
                              _loading = true;
                            });
                            getBadanUsaha(10, "null");
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
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12)),
                                    child: SvgPicture.asset(
                                      "assets/images/filter.svg",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView(
                        controller: _scrollController,
                        children: _listProduk
                            .map((e) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: cardProduk4(context, e),
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                    Container(
                                      color: Colors.black12,
                                      height: 1,
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
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
                            customText(context, Color(0xff242F43), "Filters",
                                TextAlign.left, 14, FontWeight.w500),
                            customText(context, Color(0xff545C6C), "Reset",
                                TextAlign.left, 12, FontWeight.w400),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16, bottom: 4),
                        child: customText(context, Color(0xff242F43),
                            "Kabupaten", TextAlign.left, 14, FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: dropDownStringStyle3(
                            _kabupaten, 'Pilih kabupaten', _listKabupaten,
                            (newValue) {
                          crud
                              .getData("/kabupaten/" + newValue + "/kecamatan")
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
                            "Kecamatan", TextAlign.left, 14, FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: dropDownStringStyle3(
                            _kecamatan, 'Pilih kcamatan', _listKecamatan,
                            (newValue) {
                          crud
                              .getData("/kecamatan/" + newValue + "/kelurahan")
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
                            "Kelurahan", TextAlign.left, 14, FontWeight.w400),
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
                        child: button2("Terapkan", Color(0xff2BA33A),
                            Colors.white, context, () {
                          //  Navigator.pop(context);
                          setState(() {
                            _loading = true;
                            _filterTerdekat = false;
                          });
                          if (_iDkategori == "Semua" &&
                              _kabupaten == null &&
                              _kecamatan == null &&
                              _kelurahan == null) {
                            getProduk(10);
                            // Navigator.pop(context);
                          } else {
                            getProdukFilter(_iDkategori, "Sudah diverifikasi",
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
        // _loading ? loadingWidget(context) : Container()
      ],
    );
  }
}
