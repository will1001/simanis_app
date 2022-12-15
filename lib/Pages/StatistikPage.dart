import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:appsimanis/Pages/DetailsStatistik.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/ButtonStyle1.dart';
import 'package:appsimanis/Widget/CardProduk.dart';
import 'package:appsimanis/Widget/CardProdukHome.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/DropDown3Style2.dart';
import 'package:appsimanis/Widget/DropDownStringStyle2.dart';
import 'package:appsimanis/Widget/Dropdown2Style2.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/HomeCardMenu.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/StatistikBox.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'StatistikPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({Key? key}) : super(key: key);

  @override
  _StatistikPageState createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  String _storageUrl = 'https://simanis.ntbprov.go.id/storage/';
  late DateTime currentBackPressTime;
  FunctionGroup functionGroup = new FunctionGroup();
  List _listBadanUsaha = [];
  List _listProduk = [];
  List _listBadanUsahaNotNullFoto = [];
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
  String? _cabangIndustri = null;
  String? _subCabangIndustri = null;

  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];

  String _subPage = "chart";

  String _dataIKM = '';
  String _dataIKMTerferivikasi = '';
  // String _dataIKMBelumTerferivikasi = '';
  bool _loading = false;
  int touchedIndex = -1;
  double _maxY = 0;
  List _dataBarChart = [7, 4, 5, 6, 7, 8, 9, 10, 3, 5, 7, 4];
  List _dataPieChart = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List _dataPieChart2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // List _dataPieChart2 = [0, 0];
  List _dataPieChart3 = [0, 0];
  List _dataPieChart4 = [0, 0];
  Object? args = {};
  String? _nilaiInvestasiFilter;
  String? _cabangIndustriFilter;
  bool? _sertifikatHalal = false;
  String? _sertifikatHalalFilter;
  bool? _sertifikatHaki = false;
  String? _sertifikatHakiFilter;
  bool? _sertifikatSNI = false;
  String? _sertifikatSNIFilter;

  List _klarifikasiIKM = [
    'Industri Kecil (< Rp.1.000.000.000)',
    'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
    'Industri Besar (> Rp.15.000.000.000)'
  ];

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

  List _indicatorDiagram1 = [];
  List _indicatorDiagram2 = [];

  updatePieChartbyLocation() {
    setDataIndustriLokasi('null');
    setDataIndustriLokasi('Industri Kecil (< Rp.1.000.000.000)');
    setDataIndustriLokasi(
        'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)');
    setDataIndustriLokasi('Industri Besar (> Rp.15.000.000.000)');
    setDataIKMBaruLokasi();
    setDataSertifikatLokasi('{}', 'null', 'null');
    setDataSertifikatLokasi('null', '{}', 'null');
    setDataSertifikatLokasi('null', 'null', '{}');
    setDataSektorIndustriLokasi('006c4210-7806-11eb-9b1b-81d2fad81425');
    setDataSektorIndustriLokasi('006d2610-7806-11eb-ab4c-a1abd6abcd37');
    setDataSektorIndustriLokasi('006d8f20-7806-11eb-9444-bd238317ed47');
    setDataSektorIndustriLokasi('006e3bd0-7806-11eb-a766-e1c38c7e931e');
    setDataSektorIndustriLokasi('006eb850-7806-11eb-87a5-6fa3dfe46649');
    setDataSektorIndustriLokasi('006f3b70-7806-11eb-ae50-d1725dc37289');
  }

  getCabangIndustri() {
    crud.getData('/cabang_industri').then((res) {
      // print(res.statusCode);
      setState(() {
        _cabangIndustri = jsonDecode(res.body);
      });
    });
  }

  getProduk(int _limit) {
    crud.getData('/produk/limit/$_limit').then((res) {
      setState(() {
        if (_limit == 10) {
          _listProduk.clear();
          // _loading = true;
        }
        _listProduk.addAll(jsonDecode(res.body));
        _loading = false;
      });
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogBox('', 'Keluar dari App ?', [
            AlertButton('Ya', Colors.blue, null, () async {
              SystemNavigator.pop();
            }, context),
            AlertButton('tidak', Colors.blue, null, () {
              Navigator.pop(context);
            }, context),
          ]);
        });
    return Future.value(true);
  }

  getBadanUsaha(int _limit) {
    crud.getData('/badan_usaha/limit/$_limit').then((res) {
      setState(() {
        _listBadanUsaha = jsonDecode(res.body);
        _listBadanUsahaNotNullFoto = jsonDecode(res.body)
            .where((el) =>
                el['foto_alat_produksi'] != null &&
                el['foto_alat_produksi'] != '')
            .toList();
        _loading = false;
      });
    });
  }

  getStatistik() {
    crud.getData('/badan_usaha/statistik/totalIKM').then((res) {
      setState(() {
        _dataIKM = jsonDecode(res.body)['total'].toString();
      });
    });

    crud.getData('/badan_usaha/statistik/totalIKMTerverifikasi').then((res) {
      setState(() {
        _dataIKMTerferivikasi = jsonDecode(res.body)['total'].toString();
      });
    });
  }

  getDataBelumTerverifikasi(String _totalData, String _dataTerverifikasi) {
    return (int.parse(_dataIKM) - int.parse(_dataIKMTerferivikasi)).toString();
  }

  setDataSertifikat(String _halal, _haki, _sni) {
    if (_sertifikatHalalFilter == 'null' &&
        _sertifikatHakiFilter == 'null' &&
        _sertifikatSNIFilter == 'null') {
      return 0;
    } else {
      crud
          .getData(
              '/badan_usaha/statistik/totalTenagaKerja/sertifikatFilter/$_halal/$_haki/$_sni')
          .then((res) {
        // print(res.body);
        List _dataRes = jsonDecode(res.body.toString());
        // print(_dataRes.length == 0);
        int _totalTenagaKerja = 0;
        int _totalIkm = 0;
        // print('_totalTenagaKerja');
        // print(_totalTenagaKerja);
        // print(_dataRes);
        // print(_dataRes[0]['male']);
        // print(_dataRes[0]['famale']);
        if (_dataRes.length == 0) {
          setState(() {
            _dataPieChart[6] = 0;
            _dataPieChart[7] = 0;
            _dataPieChart[8] = 0;
          });
        } else {
          for (var i = 0; i < _dataRes.length; i++) {
            var a = _dataRes[i]['male'] == null
                ? 0
                : int.parse(_dataRes[i]['male'].toString());
            var a1 = _dataRes[i]['totalIKM'] == null
                ? 0
                : int.parse(_dataRes[i]['totalIKM'].toString());
            var b = _dataRes[i]['famale'] == null
                ? 0
                : int.parse(_dataRes[i]['famale'].toString());

            var c = a + b;

            _totalTenagaKerja += c;
            _totalIkm += a1;
          }
          setState(() {
            if (_halal != 'null' && _haki == 'null' && _sni == 'null') {
              _dataPieChart[6] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            } else if (_halal == 'null' && _haki != 'null' && _sni == 'null') {
              _dataPieChart[7] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            } else {
              _dataPieChart[8] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            }
            // _dataPieChart3[0] =
            //     _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            // _dataPieChart3[1] = _totalTenagaKerja == null
            //     ? 0
            //     : int.parse(_totalTenagaKerja.toString());
          });
        }
      });
    }
  }

  setDataSertifikatLokasi(String _halal, _haki, _sni) {
    if (_sertifikatHalalFilter == 'null' &&
        _sertifikatHakiFilter == 'null' &&
        _sertifikatSNIFilter == 'null') {
      return 0;
    } else {
      crud
          .getData(
              '/badan_usaha/statistik/totalTenagaKerja/sertifikatFilterLokasi/$_halal/$_haki/$_sni/$_kabupaten/$_kecamatan/$_kelurahan')
          .then((res) {
        // print(res.body);
        List _dataRes = jsonDecode(res.body);
        // print(_dataRes.length == 0);
        int _totalTenagaKerja = 0;
        int _totalIkm = 0;
        // print('_totalTenagaKerja');
        // print(_totalTenagaKerja);
        // print(_dataRes);
        // print(_dataRes[0]['male']);
        // print(_dataRes[0]['famale']);
        if (_dataRes.length == 0) {
          setState(() {
            _dataPieChart[6] = 0;
            _dataPieChart[7] = 0;
            _dataPieChart[8] = 0;
          });
        } else {
          for (var i = 0; i < _dataRes.length; i++) {
            var a = _dataRes[i]['male'] == null
                ? 0
                : int.parse(_dataRes[i]['male'].toString());
            var a1 = _dataRes[i]['totalIKM'] == null
                ? 0
                : int.parse(_dataRes[i]['totalIKM'].toString());
            var b = _dataRes[i]['famale'] == null
                ? 0
                : int.parse(_dataRes[i]['famale'].toString());

            var c = a + b;

            _totalTenagaKerja += c;
            _totalIkm += a1;
          }
          setState(() {
            if (_halal != 'null' && _haki == 'null' && _sni == 'null') {
              _dataPieChart[6] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            } else if (_halal == 'null' && _haki != 'null' && _sni == 'null') {
              _dataPieChart[7] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            } else {
              _dataPieChart[8] =
                  _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            }
            // _dataPieChart3[0] =
            //     _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
            // _dataPieChart3[1] = _totalTenagaKerja == null
            //     ? 0
            //     : int.parse(_totalTenagaKerja.toString());
          });
        }
      });
    }
  }

  void setDataIndustri(String _klasifikasi, String _sektorIndustri) {
    crud
        .getData(
            "/badan_usaha/statistik/totalTenagaKerja/klasifikasiFilter/$_klasifikasi/$_sektorIndustri")
        .then((res) {
      // print(jsonDecode(res.body)[0]['totalIKM'] == null
      //     ? 0
      //     : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString()));
      // print(
      //     "/badan_usaha/statistik/totalTenagaKerja/klasifikasiFilter/$_klasifikasi/$_sektorIndustri");
      // print(res.statusCode);

      var dataRes = jsonDecode(res.body.toString());
      // print("abbik");/
      // print(dataRes);
      setState(() {
        switch (_klasifikasi) {
          case 'Industri Kecil (< Rp.1.000.000.000)':
            _dataPieChart[2] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());
            break;
          case 'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)':
            _dataPieChart[3] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());
            break;
          case 'Industri Besar (> Rp.15.000.000.000)':
            _dataPieChart[4] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());
            break;
          default:
        }
        switch (_sektorIndustri) {
          case '006c4210-7806-11eb-9b1b-81d2fad81425':
            _dataPieChart2[0] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          case '006d2610-7806-11eb-ab4c-a1abd6abcd37':
            _dataPieChart2[1] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          case '006d8f20-7806-11eb-9444-bd238317ed47':
            _dataPieChart2[2] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          case '006e3bd0-7806-11eb-a766-e1c38c7e931e':
            _dataPieChart2[3] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          case '006eb850-7806-11eb-87a5-6fa3dfe46649':
            _dataPieChart2[4] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          case '006f3b70-7806-11eb-ae50-d1725dc37289':
            _dataPieChart2[5] = dataRes[0]['totalIKM'] == null
                ? 0
                : int.parse(dataRes[0]['totalIKM'].toString());

            break;
          default:
        }
        // _dataPieChart2[0] = jsonDecode(res.body)[0]['totalIKM'] == null
        //     ? 0
        //     : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());
        // _dataPieChart2[1] = jsonDecode(res.body)[0]['tenagaKerja'] == null
        //     ? 0
        //     : int.parse(jsonDecode(res.body)[0]['tenagaKerja'].toString());
      });
    });
  }

  setDataIndustriLokasi(String _klasifikasi) {
    crud
        .getData(
            '/badan_usaha/statistik/kabkot/$_kabupaten/$_kecamatan/$_kelurahan/$_klasifikasi')
        .then((res) {
      // print(jsonDecode(res.body)[0]['totalIKM'] == null
      //     ? 0
      //     : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString()));
      setState(() {
        switch (_klasifikasi) {
          case 'Industri Kecil (< Rp.1.000.000.000)':
            _dataPieChart[2] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());
            break;
          case 'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)':
            _dataPieChart[3] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());
            break;
          case 'Industri Besar (> Rp.15.000.000.000)':
            _dataPieChart[4] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());
            break;
          default:
            _dataPieChart[0] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());
            _dataPieChart[1] = jsonDecode(res.body)[0]['tenagaKerja'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['tenagaKerja'].toString());
            break;
        }
      });
    });
  }

  setDataSektorIndustriLokasi(String _sektorIndustri) {
    crud
        .getData(
            '/badan_usaha/statistik/kabkotsektorIndustri/$_kabupaten/$_kecamatan/$_kelurahan/$_sektorIndustri')
        .then((res) {
      // print(jsonDecode(res.body)[0]['totalIKM'] == null
      //     ? 0
      //     : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString()));
      setState(() {
        switch (_sektorIndustri) {
          case '006c4210-7806-11eb-9b1b-81d2fad81425':
            _dataPieChart2[0] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          case '006d2610-7806-11eb-ab4c-a1abd6abcd37':
            _dataPieChart2[1] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          case '006d8f20-7806-11eb-9444-bd238317ed47':
            _dataPieChart2[2] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          case '006e3bd0-7806-11eb-a766-e1c38c7e931e':
            _dataPieChart2[3] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          case '006eb850-7806-11eb-87a5-6fa3dfe46649':
            _dataPieChart2[4] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          case '006f3b70-7806-11eb-ae50-d1725dc37289':
            _dataPieChart2[5] = jsonDecode(res.body)[0]['totalIKM'] == null
                ? 0
                : int.parse(jsonDecode(res.body)[0]['totalIKM'].toString());

            break;
          default:
        }
      });
    });
  }

  void setDataIKMBaru() {
    crud.getData('/badan_usaha/statistik/IKMBaru').then((res) {
      setState(() {
        // List _dataRes = jsonDecode(res.body);
        // int _totalTenagaKerja = 0;
        // int _totalIkm = _dataRes.length;
        // print('_totalTenagaKerja');
        // print(_totalTenagaKerja);
        // print( _dataRes[0]['totalIKM']);
        // print(_dataRes.length == 0);
        // print(_dataRes[0]_dataRes.length == 0['male']);
        // print(_dataRes[0]['famale']);
        // if (_dataRes.length == 0) {
        //   setState(() {
        //     _dataPieChart[5] = 0;
        //     // _dataPieChart[1] = 0;
        //   });
        // } else {
        // for (var i = 0; i < _dataRes.length; i++) {
        //   var a = _dataRes[i]['male'] == null
        //       ? 0
        //       : int.parse(_dataRes[i]['male'].toString());
        //   var b = _dataRes[i]['famale'] == null
        //       ? 0
        //       : int.parse(_dataRes[i]['famale'].toString());

        //   var c = a + b;

        //   _totalTenagaKerja += c;
        // }
        setState(() {
          // _dataPieChart[5] =
          //     _totalIkm == null ? 0 : int.parse(_totalIkm.toString());
          // _dataPieChart3[1] = _totalTenagaKerja == null
          //     ? 0
          //     : int.parse(_totalTenagaKerja.toString());
          _dataPieChart[5] = int.parse(res.body.toString());
        });
        // }
      });
    });
  }

  setDataIKMBaruLokasi() {
    crud
        .getData(
            '/badan_usaha/statistik/IKMBaruLokasi/$_kabupaten/$_kecamatan/$_kelurahan')
        .then((res) {
      setState(() {
        // List _dataRes = [];
        // int _totalTenagaKerja = 0;
        // int _totalIkm = _dataRes.length;
        // print('_totalTenagaKerja');
        // print(_dataRes[0]['male']);
        // print(_dataRes[0]['famale']);
        // if (_dataRes.length == 0) {
        //   setState(() {
        //     _dataPieChart4[0] = 0;
        //     _dataPieChart4[1] = 0;
        //   });
        // } else {
        //   for (var i = 0; i < _dataRes.length; i++) {
        //     var a = _dataRes[i]['male'] == null
        //         ? 0
        //         : int.parse(_dataRes[i]['male'].toString());
        //     var b = _dataRes[i]['famale'] == null
        //         ? 0
        //         : int.parse(_dataRes[i]['famale'].toString());

        //     var c = a + b;

        //     _totalTenagaKerja += c;
        //   }
        setState(() {
          _dataPieChart[5] = int.parse(res.body.toString());
          // _dataPieChart3[1] = _totalTenagaKerja == null
          //     ? 0
          //     : int.parse(_totalTenagaKerja.toString());
        });
        // }
      });
    });
  }

  void setData(String status) {
    crud.getData('/badan_usaha/statistik/totalIKM').then((res) {
      setState(() {
        _dataPieChart[0] = jsonDecode(res.body)['total'];
      });
    });

    crud.getData('/badan_usaha/statistik/totalTenagaKerja/$status').then((res) {
      setState(() {
        _dataPieChart[1] = jsonDecode(res.body)['total'];
        _loading = false;
      });
    });
  }

  getKabupatenList() {
    crud.getData('/provinsi/52/kabupaten').then((data) {
      // print(jsonDecode(data.body));
      setState(() {
        _listKabupaten = jsonDecode(data.body);
      });
    });
  }

  getStatistikQuery() {
    return '''
     query{
      Statistik(kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}"){
        total_ikm
        total_tenaga_kerja
        total_industri_kecil
        total_industri_menengah
        total_industri_besar
        total_ikm_baru
        total_ikm_sertifikat_halal
        total_ikm_sertifikat_haki
        total_ikm_sertifikat_sni
        total_ikm_sertifikat_test_report
        total_ikm_formal
        total_ikm_informal
      }
    }
    ''';
  }

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

  getCabangIndustriQuery() {
    return '''
      query{
        cabangIndustri{
          id
          name
        }
      }
    ''';
  }

  getSubCabangIndustriQuery() {
    return '''
      query{
        SubCabangIndustri(id_cabang_industri:"${_cabangIndustri}"){
          id
          name
        }
      }
    ''';
  }

  pushToDetailsPage(
      String _title,
      String _jenisIndustri,
      String _ikmBaru,
      String _halal,
      String _haki,
      String _sni,
      String _kabupaten,
      String _kecamatan,
      String _kelurahan) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DetailsStatistik(
    //         title: _title,
    //         kabupaten: _kabupaten,
    //         kecamatan: _kecamatan,
    //         kelurahan: _kelurahan,
    //         industri: _jenisIndustri,
    //       ),
    //     ));
  }

  setStateMenuChart() {
    setState(() {
      _indicatorDiagram1 = [
        {
          'color': Color(0xff4930C5),
          'title': 'Total IKM',
          'onTap': () {}
          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',
          // 'value': _dataPieChart[0],
        },
        {
          'color': Color(0xfff41AAC9),
          'title': 'Tenaga Kerja',
          'onTap': () {}

          // 'param1': 'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)'
          // 'value': _dataPieChart[1],
        },
        {
          'color': Colors.lime,
          'title': 'IKM Baru',
          'onTap': () {
            pushToDetailsPage(
                'IKM Baru',
                "",
                "true",
                "",
                "",
                "",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }

          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',

          // 'value': _dataPieChart[5],
        },
        {
          'color': Colors.blueAccent,
          'title': 'Industri Kecil',
          'onTap': () {
            pushToDetailsPage(
                'Industri Kecil (< Rp.1.000.000.000)',
                'Industri Kecil (< Rp.1.000.000.000)',
                "",
                "",
                "",
                "",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }

          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',
          // 'value': _dataPieChart[2],
        },
        {
          'color': Colors.amber,
          'title': 'Industri Menengah',
          'onTap': () {
            pushToDetailsPage(
                'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
                'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
                "",
                "",
                "",
                "",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }
          // 'param1': 'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)'

          // 'value': _dataPieChart[3],
        },
        {
          'color': Colors.green,
          'title': 'Industri Besar',
          'onTap': () {
            pushToDetailsPage(
                'Industri Besar (> Rp.15.000.000.000)',
                'Industri Besar (> Rp.15.000.000.000)',
                "",
                "",
                "",
                "",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }
          // 'param1': 'Industri Besar (> Rp.15.000.000.000)'

          // 'value': _dataPieChart[4],
        },
        {
          'color': Colors.teal,
          'title': 'Sertifikat Halal',
          'onTap': () {
            pushToDetailsPage(
                'IKM yang Memiliki Sertifikat Halal',
                "",
                "true",
                "{}",
                "null",
                "null",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }
          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',

          // 'value': _dataPieChart[6],
        },
        {
          'color': Colors.brown,
          'title': 'Sertifikat HAKI',
          'onTap': () {
            pushToDetailsPage(
                'IKM yang Memiliki Sertifikat HAKI',
                "",
                "true",
                "null",
                "{}",
                "null",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }
          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',

          // 'value': _dataPieChart[7],
        },
        {
          'color': Colors.pink,
          'title': 'Sertifikat SNI',
          'onTap': () {
            pushToDetailsPage(
                'IKM yang Memiliki Sertifikat SNI',
                "",
                "true",
                "null",
                "null",
                "{}",
                _kabupaten.toString(),
                _kecamatan.toString(),
                _kelurahan.toString());
          }
          // 'param1': 'Industri Kecil (< Rp.1.000.000.000)',

          // 'value': _dataPieChart[8],
        },
      ];
      _indicatorDiagram2 = [
        {
          'color': Color(0xff4930C5),
          'title': 'Pangan',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006c4210-7806-11eb-9b1b-81d2fad81425",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Color(0xfff41AAC9),
          'title': 'Farmasi',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006d2610-7806-11eb-ab4c-a1abd6abcd37",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.blueAccent,
          'title': 'Tekstil',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006d8f20-7806-11eb-9444-bd238317ed47",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.amber,
          'title': 'Alat Transportasi',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006e3bd0-7806-11eb-a766-e1c38c7e931e",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.green,
          'title': 'Elektronika dan Telematika',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006f3b70-7806-11eb-ae50-d1725dc37289",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.lime,
          'title': 'Pembangkit Energi',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006eb850-7806-11eb-87a5-6fa3dfe46649",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.deepPurpleAccent,
          'title': 'Barang Modal',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006eb850-7806-11eb-87a5-6fa3dfe46649",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.pinkAccent,
          'title': 'Hulu Agro',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006eb850-7806-11eb-87a5-6fa3dfe46649",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Colors.lightGreenAccent,
          'title': 'Logam Dasar',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006eb850-7806-11eb-87a5-6fa3dfe46649",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
        {
          'color': Color(0xfff395B64),
          'title': 'Kimia Dasar',
          'ontap': () {
            Navigator.pushNamed(context, '/homeLayoutPage',
                arguments: <String, dynamic>{
                  "selectedIndex": 3,
                  "kategori": "006eb850-7806-11eb-87a5-6fa3dfe46649",
                  "aksesLink": "home"
                });
          }
          // 'value': _dataPieChart[0],
        },
      ];
    });
  }

  intNullChecker(int? data) {
    if (data == null) {
      return 0;
    }
    ;
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.loginCache == 2) {
    //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(context, Color(0xff000000), 'Statistik',
                          TextAlign.center, 24, FontWeight.bold)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    color: Colors.black12,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => {
                            setState(() {
                              _subPage = "table";
                            })
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: _subPage == "chart"
                                    ? Colors.white
                                    : Color(0xff374151),
                                border: Border.all(
                                    color: Color(0xff374151), width: 1)),
                            child: Text("Data Table",
                                style: TextStyle(
                                    color: _subPage == "chart"
                                        ? Color(0xff374151)
                                        : Colors.white)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            _subPage = "chart";
                          })
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              color: _subPage == "table"
                                  ? Colors.white
                                  : Color(0xff374151),
                              border: Border.all(
                                  color: Color(0xff374151), width: 1)),
                          child: Text(
                            "Pie Chart",
                            style: TextStyle(
                                color: _subPage == "table"
                                    ? Color(0xff374151)
                                    : Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: customText(context, Color(0xff242F43), 'Kabupaten',
                      TextAlign.left, 14, FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
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
                      return dropDownStringStyle2(_kabupaten, 'Kabupaten',
                          _kabupatenList, Color(0xffE4E5E7), (newValue) {
                        setState(() {
                          _kabupaten = newValue;
                          _kecamatan = null;
                          _kelurahan = null;
                        });
                        // });
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: customText(context, Color(0xff242F43), 'Kecamatan',
                      TextAlign.left, 14, FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4, right: 16),
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
                          'Kecamatan',
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
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: customText(context, Color(0xff242F43), 'Kelurahan',
                      TextAlign.left, 14, FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4, right: 16),
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
                          'Kelurahan',
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
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: customText(context, Color(0xff242F43),
                      'Cabang Industri', TextAlign.left, 14, FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4, right: 16),
                  child: Query(
                    options:
                        QueryOptions(document: gql(getCabangIndustriQuery())),
                    builder: (QueryResult result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return Text("");
                      }
                      final _CabangIndustriList =
                          result.data?['cabangIndustri'];
                      return dropDownStringStyle2(
                          _cabangIndustri,
                          'Cabang Industri',
                          _CabangIndustriList == null
                              ? []
                              : _CabangIndustriList,
                          Color(0xffE4E5E7), (newValue) {
                        setState(() {
                          _cabangIndustri = newValue;
                          _subCabangIndustri = null;
                        });
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: customText(
                      context,
                      Color(0xff242F43),
                      'Sub Cabang Industri',
                      TextAlign.left,
                      14,
                      FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4, right: 16),
                  child: Query(
                    options: QueryOptions(
                        document: gql(getSubCabangIndustriQuery())),
                    builder: (QueryResult result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return Text("");
                      }
                      final _subCabangIndustriList =
                          result.data?['SubCabangIndustri'];

                      return dropDownStringStyle2(
                          _subCabangIndustri,
                          'SubCabang Industri',
                          _subCabangIndustriList == null
                              ? []
                              : _subCabangIndustriList,
                          Color(0xffE4E5E7), (newValue) {
                        setState(() {
                          _subCabangIndustri = newValue;
                        });
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16.0, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonStyle1(context, 'Reset', Colors.white, () {
                        setState(() {
                          _kabupaten = null;
                          _kecamatan = null;
                          _kelurahan = null;
                          _cabangIndustri = null;
                        });
                        setData('null');
                        setDataIKMBaru();
                        setDataIndustri(
                            'Industri Kecil (< Rp.1.000.000.000)', 'null');
                        setDataIndustri(
                            'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
                            'null');
                        setDataIndustri(
                            'Industri Besar (> Rp.15.000.000.000)', 'null');
                        setDataSertifikat('{}', 'null', 'null');
                        setDataSertifikat('null', '{}', 'null');
                        setDataSertifikat('null', 'null', '{}');
                        setDataIndustri(
                            'null', '006c4210-7806-11eb-9b1b-81d2fad81425');
                        setDataIndustri(
                            'null', '006d2610-7806-11eb-ab4c-a1abd6abcd37');
                        setDataIndustri(
                            'null', '006d8f20-7806-11eb-9444-bd238317ed47');
                        setDataIndustri(
                            'null', '006e3bd0-7806-11eb-a766-e1c38c7e931e');
                        setDataIndustri(
                            'null', '006eb850-7806-11eb-87a5-6fa3dfe46649');
                        setDataIndustri(
                            'null', '006f3b70-7806-11eb-ae50-d1725dc37289');
                      }),
                    ],
                  ),
                ),
                _subPage == "table"
                    ? (Container(
                        child: Query(
                          options:
                              QueryOptions(document: gql(getStatistikQuery())),
                          builder: (QueryResult result, {fetchMore, refetch}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.isLoading) {
                              return Text("");
                            }

                            final data = result.data?['Statistik'][0];
                            final _totalIkm = data['total_ikm'];
                            final _totalTenagaKerja =
                                data['total_tenaga_kerja'];
                            final _industriKecil = data['total_industri_kecil'];
                            final _industriMenengah =
                                data['total_industri_menengah'];
                            final _industriBesar = data['total_industri_besar'];
                            final _ikmBaru = data['total_ikm_baru'];
                            final _sertifikatHalal =
                                data['total_ikm_sertifikat_halal'];
                            final _sertifikatHaki =
                                data['total_ikm_sertifikat_haki'];
                            final _sertifikatSni =
                                data['total_ikm_sertifikat_sni'];
                            final _sertifikatTestReport =
                                data['total_ikm_sertifikat_test_report'];
                            final _ikmFormal = data['total_ikm_formal'];
                            final _ikmInformal = data['total_ikm_informal'];

                            List indicatorDiagramList = [
                              {
                                'color': Color(0xff4930C5),
                                'title': 'Total IKM',
                                'value': _totalIkm,
                                'icon': "total_ikm.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                                    media_sosial id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Color(0xfff41AAC9),
                                'title': 'Tenaga Kerja',
                                'icon': "tenaga_kerja.svg",
                                'value': _totalTenagaKerja,
                                'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.lime,
                                'title': 'IKM Baru',
                                'value': _ikmBaru,
                                'icon': "ikm_baru.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"2",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.blueAccent,
                                'title': 'Industri Kecil',
                                'value': _industriKecil,
                                'icon': "industri_kecil.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"3",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.amber,
                                'title': 'Industri Menengah',
                                'value': _industriMenengah,
                                'icon': "industri_menengah.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"4",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.green,
                                'title': 'Industri Besar',
                                'value': _industriBesar,
                                'icon': "industri_besar.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"5",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.teal,
                                'title': 'Sertifikat Halal',
                                'value': _sertifikatHalal,
                                'icon': "sert_halal.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"6",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"halal"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.brown,
                                'title': 'Sertifikat HAKI',
                                'value': _sertifikatHaki,
                                'icon': "sert_haki.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"7",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"haki"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Colors.pink,
                                'title': 'Sertifikat SNI',
                                'value': _sertifikatSni,
                                'icon': "sert_sni.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"8",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"sni"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Color(0xff151D3B),
                                'title': 'Sert. Test Report',
                                'value': _sertifikatTestReport,
                                'icon': "sert_test_report.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"9",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"test_report"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Color(0xffF76E11),
                                'title': 'Formal',
                                'value': _ikmFormal,
                                'icon': "formal.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"10",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                              {
                                'color': Color(0xff4C0027),
                                'title': 'Informal',
                                'value': _ikmInformal,
                                'icon': "informal.svg",
                                'query': '''
                                query{
                                  badanUsaha(page:1,filter:"11",kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                              },
                            ];

                            return GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 1 / 0.25,
                              crossAxisCount: 1,
                              shrinkWrap: true,
                              primary: true,
                              children: indicatorDiagramList
                                  .asMap()
                                  .map((i, e) => MapEntry(
                                      i,
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsStatistik(
                                                  title: e['title'],
                                                  graphqlQuery: e['query'],
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: e['color'],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40,
                                                          right: 25.0),
                                                  child: SvgPicture.asset(
                                                    "assets/images/" +
                                                        e['icon'],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e['value'].toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      e['title'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )))
                                  .values
                                  .toList(),
                            );
                          },
                        ),
                      ))
                    : (Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: Query(
                                      options: QueryOptions(
                                          document: gql(getStatistikQuery())),
                                      builder: (QueryResult result,
                                          {fetchMore, refetch}) {
                                        if (result.hasException) {
                                          return Text(
                                              result.exception.toString());
                                        }
                                        if (result.isLoading) {
                                          return Text("");
                                        }
                                        final data =
                                            result.data?['Statistik'][0];
                                        final _totalIkm = data['total_ikm'];
                                        final _totalTenagaKerja =
                                            data['total_tenaga_kerja'];
                                        final _industriKecil =
                                            data['total_industri_kecil'];
                                        final _industriMenengah =
                                            data['total_industri_menengah'];
                                        final _industriBesar =
                                            data['total_industri_besar'];
                                        final _ikmBaru = data['total_ikm_baru'];
                                        final _sertifikatHalal =
                                            data['total_ikm_sertifikat_halal'];
                                        final _sertifikatHaki =
                                            data['total_ikm_sertifikat_haki'];
                                        final _sertifikatSni =
                                            data['total_ikm_sertifikat_sni'];

                                        return PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                setState(() {
                                                  final desiredTouch =
                                                      pieTouchResponse
                                                                  .touchInput
                                                              is! PointerExitEvent &&
                                                          pieTouchResponse
                                                                  .touchInput
                                                              is! PointerUpEvent;
                                                  if (desiredTouch &&
                                                      pieTouchResponse
                                                              .touchedSection !=
                                                          null) {
                                                    touchedIndex =
                                                        pieTouchResponse
                                                            .touchedSection!
                                                            .touchedSectionIndex;
                                                  } else {
                                                    touchedIndex = -1;
                                                  }
                                                });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 80,
                                              sections: showingSections(
                                                intNullChecker(_totalIkm),
                                                intNullChecker(
                                                    _totalTenagaKerja),
                                                intNullChecker(_industriKecil),
                                                intNullChecker(
                                                    _industriMenengah),
                                                intNullChecker(_industriBesar),
                                                intNullChecker(_ikmBaru),
                                                intNullChecker(
                                                    _sertifikatHalal),
                                                intNullChecker(_sertifikatHaki),
                                                intNullChecker(_sertifikatSni),
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.blue.shade50,
                                    child: Text(
                                        "Klik Jenis Data Untuk Melihat Lebih Detail",
                                        style: TextStyle(color: Colors.blue))),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, top: 16.0, right: 32),
                              child: Container(
                                child: Query(
                                  options: QueryOptions(
                                      document: gql(getStatistikQuery())),
                                  builder: (QueryResult result,
                                      {fetchMore, refetch}) {
                                    if (result.hasException) {
                                      return Text(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      return Text("");
                                    }

                                    final data = result.data?['Statistik'][0];
                                    final _totalIkm = data['total_ikm'];
                                    final _totalTenagaKerja =
                                        data['total_tenaga_kerja'];
                                    final _industriKecil =
                                        data['total_industri_kecil'];
                                    final _industriMenengah =
                                        data['total_industri_menengah'];
                                    final _industriBesar =
                                        data['total_industri_besar'];
                                    final _ikmBaru = data['total_ikm_baru'];
                                    final _sertifikatHalal =
                                        data['total_ikm_sertifikat_halal'];
                                    final _sertifikatHaki =
                                        data['total_ikm_sertifikat_haki'];
                                    final _sertifikatSni =
                                        data['total_ikm_sertifikat_sni'];
                                    final _sertifikatTestReport = data[
                                        'total_ikm_sertifikat_test_report'];
                                    final _ikmFormal = data['total_ikm_formal'];
                                    final _ikmInformal =
                                        data['total_ikm_informal'];

                                    List indicatorDiagramList = [
                                      {
                                        'color': Color(0xff4930C5),
                                        'title': 'Total IKM',
                                        'value': _totalIkm,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Color(0xfff41AAC9),
                                        'title': 'Tenaga Kerja',
                                        'value': _totalTenagaKerja,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.lime,
                                        'title': 'IKM Baru',
                                        'value': _ikmBaru,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.blueAccent,
                                        'title': 'Industri Kecil',
                                        'value': _industriKecil,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.amber,
                                        'title': 'Industri Menengah',
                                        'value': _industriMenengah,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.green,
                                        'title': 'Industri Besar',
                                        'value': _industriBesar,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.teal,
                                        'title': 'Sertifikat Halal',
                                        'value': _sertifikatHalal,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"halal"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.brown,
                                        'title': 'Sertifikat HAKI',
                                        'value': _sertifikatHaki,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"haki"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Colors.pink,
                                        'title': 'Sertifikat SNI',
                                        'value': _sertifikatSni,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"sni"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Color(0xff151D3B),
                                        'title': 'Sert. Test Report',
                                        'value': _sertifikatTestReport,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}",sertifikat:"test_report"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Color(0xffF76E11),
                                        'title': 'Formal',
                                        'value': _ikmFormal,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                      {
                                        'color': Color(0xff4C0027),
                                        'title': 'Informal',
                                        'value': _ikmInformal,
                                        'query': '''
                                query{
                                  badanUsaha(page:1,kabupaten:"${_kabupaten != null ? _kabupaten : ''}",kecamatan:"${_kecamatan != null ? _kecamatan : ''}",kelurahan:"${_kelurahan != null ? _kelurahan : ''}",cabang_industri:"${_cabangIndustri != null ? _cabangIndustri : ''}",sub_cabang_industri:"${_subCabangIndustri != null ? _subCabangIndustri : ''}"){
                                    id
                                    nik
                                    kabupaten
                                    kecamatan
                                    kelurahan
                                    produk
                                    nama_direktur
                                    alamat_lengkap
                                    no_hp
                                    nama_usaha
                                    bentuk_usaha
                                    tahun_berdiri
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
                              '''
                                      },
                                    ];

                                    return GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      childAspectRatio: 1 / 0.25,
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      primary: true,
                                      children: indicatorDiagramList
                                          .asMap()
                                          .map((i, e) => MapEntry(
                                              i,
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsStatistik(
                                                          title: e['title'],
                                                          graphqlQuery:
                                                              e['query'],
                                                        ),
                                                      ));
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 32,
                                                          height: 16,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            color: e['color'],
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4),
                                                          width: 120,
                                                          child: customText(
                                                              context,
                                                              Color(0xff242F43),
                                                              e['title'],
                                                              TextAlign.left,
                                                              12,
                                                              FontWeight.w400),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )))
                                          .values
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 32.0, top: 40),
                            //   child: customText(
                            //       context,
                            //       Color(0xff242F43),
                            //       'Statistik Berdasarkan Sektor Industri',
                            //       TextAlign.left,
                            //       14,
                            //       FontWeight.w500),
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: AspectRatio(
                            //         aspectRatio: 1.3,
                            //         child: PieChart(
                            //           PieChartData(
                            //               pieTouchData: PieTouchData(
                            //                   touchCallback: (pieTouchResponse) {
                            //                 setState(() {
                            //                   final desiredTouch = pieTouchResponse
                            //                           .touchInput is! PointerExitEvent &&
                            //                       pieTouchResponse.touchInput
                            //                           is! PointerUpEvent;
                            //                   if (desiredTouch &&
                            //                       pieTouchResponse.touchedSection != null) {
                            //                     touchedIndex = pieTouchResponse
                            //                         .touchedSection!.touchedSectionIndex;
                            //                   } else {
                            //                     touchedIndex = -1;
                            //                   }
                            //                 });
                            //               }),
                            //               borderData: FlBorderData(
                            //                 show: false,
                            //               ),
                            //               sectionsSpace: 0,
                            //               centerSpaceRadius: 30,
                            //               sections: showingSections2()),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, top: 16.0, right: 32),
                              child: Container(
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  childAspectRatio: 1 / 1,
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  primary: true,
                                  children: _indicatorDiagram2
                                      .asMap()
                                      .map((i, e) => MapEntry(
                                          i,
                                          GestureDetector(
                                            onTap: e['ontap'],
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customText(
                                                    context,
                                                    Color(0xff242F43),
                                                    _dataPieChart2[i]
                                                        .toString(),
                                                    TextAlign.left,
                                                    20,
                                                    FontWeight.w500),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: e['color'],
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      width: 80,
                                                      child: customText(
                                                          context,
                                                          Color(0xff242F43),
                                                          e['title'],
                                                          TextAlign.left,
                                                          12,
                                                          FontWeight.w400),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )))
                                      .values
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ),
          _loading ? loadingWidget(context) : Container()
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    int _totalIkm,
    int _totalTenagaKerja,
    int _industriKecil,
    int _industriMenengah,
    int _industriBesar,
    int _ikmBaru,
    int _sertifikatHalal,
    int _sertifikatHaki,
    int _sertifikatSni,
  ) {
    return List.generate(9, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final widgetSize = isTouched ? 55.0 : 35.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff4930C5),
            value: _totalIkm.toDouble(),
            title: '${_totalIkm}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff41AAC9),
            value: _totalTenagaKerja.toDouble(),
            title: '${_totalTenagaKerja}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: _industriKecil.toDouble(),
            title: '${_industriKecil}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.amber,
            value: _industriMenengah.toDouble(),
            title: '${_industriMenengah}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.green,
            value: _industriBesar.toDouble(),
            title: '${_industriBesar}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: Colors.lime,
            value: _ikmBaru.toDouble(),
            title: '${_ikmBaru}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 6:
          return PieChartSectionData(
            color: Colors.teal,
            value: _sertifikatHalal.toDouble(),
            title: '${_sertifikatHalal}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 7:
          return PieChartSectionData(
            color: Colors.brown,
            value: _sertifikatHaki.toDouble(),
            title: '${_sertifikatHaki}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 8:
          return PieChartSectionData(
            color: Colors.pink,
            value: _sertifikatSni.toDouble(),
            title: '${_sertifikatSni}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

//   List<PieChartSectionData> showingSections2(List dataPie) {
//     return List.generate(6, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 25.0 : 16.0;
//       final radius = isTouched ? 60.0 : 50.0;
//       final widgetSize = isTouched ? 55.0 : 35.0;
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: const Color(0xff4930C5),
//             value: dataPie2[0].toDouble(),
//             title: '${dataPie2[0]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: const Color(0xfff41AAC9),
//             value: dataPie2[1].toDouble(),
//             title: '${dataPie2[1]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: Colors.blueAccent,
//             value: dataPie2[2].toDouble(),
//             title: '${dataPie2[2]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: Colors.amber,
//             value: dataPie2[3].toDouble(),
//             title: '${dataPie2[3]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 4:
//           return PieChartSectionData(
//             color: Colors.green,
//             value: dataPie2[4].toDouble(),
//             title: '${dataPie2[4]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         case 5:
//           return PieChartSectionData(
//             color: Colors.lime,
//             value: dataPie2[5].toDouble(),
//             title: '${dataPie2[5]}',
//             radius: radius,
//             titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xffffffff)),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
