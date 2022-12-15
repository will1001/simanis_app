import 'dart:convert';
import 'dart:io';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/ThemeProvider.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/DropDownStringStyle2.dart';
import '../Widget/Dropdown4.dart';
import '../Widget/inputFormStyle4.dart';

class DetailUsaha extends StatefulWidget {
  const DetailUsaha({Key? key}) : super(key: key);

  @override
  _DetailUsahaState createState() => _DetailUsahaState();
}

class _DetailUsahaState extends State<DetailUsaha> {
  TextEditingController _nikController = new TextEditingController();
  TextEditingController _namaController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _noHpController = new TextEditingController();
  TextEditingController _namaUsahaController = new TextEditingController();
  TextEditingController _tahunBerdiriController = new TextEditingController();
  TextEditingController _nibController = new TextEditingController();
  TextEditingController _sertHalalController = new TextEditingController();
  TextEditingController _sertMerekController = new TextEditingController();
  TextEditingController _noTestController = new TextEditingController();
  TextEditingController _sniController = new TextEditingController();
  TextEditingController _jenisUsahaController = new TextEditingController();
  TextEditingController _merekUsahaController = new TextEditingController();
  TextEditingController _investController = new TextEditingController();
  TextEditingController _tenkerPriaController = new TextEditingController();
  TextEditingController _tenkerWanitaController = new TextEditingController();
  TextEditingController _kapProdController = new TextEditingController();
  TextEditingController _satProdController = new TextEditingController();
  TextEditingController _nilProdController = new TextEditingController();
  TextEditingController _nilBahanController = new TextEditingController();
  TextEditingController _omsetController = new TextEditingController();
  TextEditingController _latController = new TextEditingController();
  TextEditingController _longController = new TextEditingController();
  TextEditingController _medsosController = new TextEditingController();
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
  String? _bentukUsaha = null;
  String? _cabangIndustri = null;
  String? _subCabangIndustri = null;
  String? _kbli = null;
  String? _pendidikan = null;

  String _idUser = "";
  String _storageUrl = "https://simanis.ntbprov.go.id";

  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List _listBadanUsaha = [];

  List _listBentukUsaha = [
    {"id": "PT", "nama": "PT"},
    {"id": "CV", "nama": "CV"},
    {"id": "UD", "nama": "UD"},
    {"id": "PO", "nama": "PO"},
    {"id": "Lainnya", "nama": "Lainnya"},
    {"id": "Belum Ada", "nama": "Belum Ada"}
  ];
  List _listPendidikan = [
    {"id": "SD", "nama": "SD"},
    {"id": "SMP", "nama": "SMP"},
    {"id": "SMA", "nama": "SMA"},
    {"id": "S1", "nama": "S1"},
    {"id": "S2", "nama": "S2"},
    {"id": "S3", "nama": "S3"},
  ];

  Map<String, dynamic> _file = {
    "bentuk_usaha_file": null,
    "nib_file": null,
    "sertifikat_halal_file": null,
    "sertifikat_merek_file": null,
    "sertifikat_sni_file": null,
    "foto_alat_produksi": null,
    "foto_ruang_produksi": null,
    "ktp": null,
    "kk": null,
    "ktp_pasangan": null,
  };

  Map<String, dynamic> _fileString = {
    "bentuk_usaha_file": null,
    "nib_file": null,
    "sertifikat_halal_file": null,
    "sertifikat_merek_file": null,
    "sertifikat_sni_file": null,
    "foto_alat_produksi": null,
    "foto_ruang_produksi": null,
    "ktp": null,
    "kk": null,
    "ktp_pasangan": null,
  };

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

  getKBLIQuery() {
    return '''
      query{
       Kbli{
          id
          name
        }
      }
    ''';
  }

  String getBadanUsahaByIDQuery = r'''
     query($idUser: String!){
        BadanUsahaByID(user_id:$idUser){
          id
          nik
          nama_direktur
          id_kabupaten
          kabupaten
          id_kecamatan
          kecamatan
          id_kelurahan
          kelurahan
          alamat_lengkap
          no_hp
          nama_usaha
          bentuk_usaha
          tahun_berdiri
          nib_tahun
          nomor_sertifikat_halal_tahun
          sertifikat_merek_tahun
          nomor_test_report_tahun
          sni_tahun
          jenis_usaha
          merek_usaha
          id_cabang_industri
          cabang_industri
          id_sub_cabang_industri
          sub_cabang_industri
          id_kbli
          kbli
          investasi_modal
          jumlah_tenaga_kerja_pria
          jumlah_tenaga_kerja_wanita
          rata_rata_pendidikan_tenaga_kerja
          kapasitas_produksi_perbulan
          satuan_produksi
          nilai_produksi_perbulan
          nilai_bahan_baku_perbulan
          nib_file
          bentuk_usaha_file
          sertifikat_halal_file
          sertifikat_sni_file
          sertifikat_merek_file
          foto_alat_produksi
          foto_ruang_produksi
          lat
          lng
          media_sosial
          produk
          ktp
          kk
          ktp_pasangan
          omset
        }
      }
    ''';

  String badanUsahaMutation = r'''
      mutation(
        $user_id: String!,
        $nik: String,
        $nama_direktur: String,
        $id_kabupaten: String,
        $kecamatan: String,
        $kelurahan: String,
        $no_hp: String,
        $alamat_lengkap: String,
        $nama_usaha: String,
        $bentuk_usaha: String,
        $tahun_berdiri: String,
        $nib_tahun: String,
        $nomor_sertifikat_halal_tahun: String,
        $sertifikat_merek_tahun: String,
        $nomor_test_report_tahun: String,
        $sni_tahun: String,
        $jenis_usaha: String,
        $merek_usaha: String,
        $cabang_industri: String,
        $sub_cabang_industri: String,
        $id_kbli: String,
        $investasi_modal: String,
        $jumlah_tenaga_kerja_pria: String,
        $jumlah_tenaga_kerja_wanita: String,
        $rata_rata_pendidikan_tenaga_kerja: String,
        $kapasitas_produksi_perbulan: String,
        $satuan_produksi: String,
        $nilai_produksi_perbulan: String,
        $nilai_bahan_baku_perbulan: String,
        $lat: String,
        $lng: String,
        $media_sosial: String,
        $bentuk_usaha_file: Upload,
        $sertifikat_halal_file: Upload,
        $sertifikat_merek_file: Upload,
        $sertifikat_sni_file: Upload,
        $nib_file: Upload,
        $foto_alat_produksi_file: Upload,
        $foto_ruang_produksi_file: Upload,
        $ktp: Upload,
        $kk: Upload,
        $ktp_pasangan: Upload,
        ){
        BadanUsaha(
          user_id:$user_id,
          nik:$nik,
          nama_direktur:$nama_direktur,
          id_kabupaten:$id_kabupaten,
          kecamatan:$kecamatan,
          kelurahan:$kelurahan,
          no_hp:$no_hp,
          alamat_lengkap:$alamat_lengkap,
          nama_usaha:$nama_usaha,
          bentuk_usaha:$bentuk_usaha,
          tahun_berdiri:$tahun_berdiri,
          nib_tahun:$nib_tahun,
          nomor_sertifikat_halal_tahun:$nomor_sertifikat_halal_tahun,
          sertifikat_merek_tahun:$sertifikat_merek_tahun,
          nomor_test_report_tahun:$nomor_test_report_tahun,
          sni_tahun:$sni_tahun,
          jenis_usaha:$jenis_usaha,
          merek_usaha:$merek_usaha,
          cabang_industri:$cabang_industri,
          sub_cabang_industri:$sub_cabang_industri,
          id_kbli:$id_kbli,
          investasi_modal:$investasi_modal,
          jumlah_tenaga_kerja_pria:$jumlah_tenaga_kerja_pria,
          jumlah_tenaga_kerja_wanita:$jumlah_tenaga_kerja_wanita,
          rata_rata_pendidikan_tenaga_kerja:$rata_rata_pendidikan_tenaga_kerja,
          kapasitas_produksi_perbulan:$kapasitas_produksi_perbulan,
          satuan_produksi:$satuan_produksi,
          nilai_produksi_perbulan:$nilai_produksi_perbulan,
          nilai_bahan_baku_perbulan:$nilai_bahan_baku_perbulan,
          lat:$lat,
          lng:$lng,
          media_sosial:$media_sosial,
          bentuk_usaha_file:$bentuk_usaha_file,
          sertifikat_halal_file:$sertifikat_halal_file,
          sertifikat_merek_file:$sertifikat_merek_file,
          sertifikat_sni_file:$sertifikat_sni_file,
          nib_file:$nib_file,
          foto_alat_produksi_file:$foto_alat_produksi_file,
          foto_ruang_produksi_file:$foto_ruang_produksi_file,
          ktp:$ktp,
          kk:$kk,
          ktp_pasangan:$ktp_pasangan,
          ){
          messagges
        }
      }
    ''';

  uploadfile(String _fileString) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path.toString());
      setState(() {
        _file['${_fileString}'] = file;
      });
    } else {
      // User canceled the picker
    }
  }

  formInputGroupWidget(String _title, Color _fontColor,
      TextEditingController _controller, var _initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: customText(context, _fontColor, _title, TextAlign.left, 17,
              FontWeight.normal),
        ),
        inputFormStyle4(
            null,
            "${_title}",
            "text",
            "${_title}",
            "${_title} Tidak Boleh Kosong",
            false,
            _controller,
            false,
            _initialValue,
            () {})
      ],
    );
  }

  formFileGroupWidget(String _title, String? _varName, Color _fontColor,
      String? current_value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: customText(context, _fontColor, _title, TextAlign.left, 17,
              FontWeight.normal),
        ),
        GestureDetector(
          onTap: () {
            uploadfile("${_varName}");
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                children: [
                  SvgPicture.asset("assets/images/file.svg"),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 24),
                    child: Container(),
                  ),
                  customText(
                      context,
                      Colors.black,
                      "Click here to Upload a file",
                      TextAlign.left,
                      14,
                      FontWeight.w400),
                  customText(context, Colors.black, "UPLOAD FILE (MAX : 5MB)",
                      TextAlign.left, 14, FontWeight.w400),
                ],
              ),
            ),
          ),
        ),
        current_value == null
            ? Container()
            : current_value == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(
                      _storageUrl + current_value,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _file['${_varName}'] == null
              ? Container()
              : Text(_file['${_varName}'].toString()),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // ...
    _nikController.addListener(() {});
    _namaController.addListener(() {});
    _alamatController.addListener(() {});
    _noHpController.addListener(() {});
    _namaUsahaController.addListener(() {});
    _tahunBerdiriController.addListener(() {});
    _nibController.addListener(() {});
    _sertHalalController.addListener(() {});
    _sertMerekController.addListener(() {});
    _noTestController.addListener(() {});
    _sniController.addListener(() {});
    _jenisUsahaController.addListener(() {});
    _merekUsahaController.addListener(() {});
    _investController.addListener(() {});
    _tenkerPriaController.addListener(() {});
    _tenkerWanitaController.addListener(() {});
    _kapProdController.addListener(() {});
    _satProdController.addListener(() {});
    _nilProdController.addListener(() {});
    _nilBahanController.addListener(() {});
    _latController.addListener(() {});
    _longController.addListener(() {});
    getIdUser();
  }

  getBadanUsaha(idUser) {
    var data = client.value.query(QueryOptions(
      document: gql(getBadanUsahaByIDQuery),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'idUser': idUser},
      // pollInterval: const Duration(seconds: 10),
    ));
    data.then(
        (value) => {loadRecentBadanUsahaData(value.data?['BadanUsahaByID'])});
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUser');

    setState(() {
      _idUser = idUser!;
    });
    getBadanUsaha(idUser);
  }

  loadRecentBadanUsahaData(datas) {
    print(datas[0]['ktp']);
    setState(() {
      _nikController.text = datas[0]['nik'] ?? "";
      _namaController.text = datas[0]['nama_direktur'] ?? "";

      _alamatController.text = datas[0]['alamat_lengkap'] ?? "";
      _noHpController.text = datas[0]['no_hp'] ?? "";
      _namaUsahaController.text = datas[0]['nama_usaha'] ?? "";
      _tahunBerdiriController.text = datas[0]['tahun_berdiri'] != null
          ? datas[0]['tahun_berdiri'].toString()
          : '';
      _nibController.text = datas[0]['nib_tahun'] ?? "";
      _sertHalalController.text =
          datas[0]['nomor_sertifikat_halal_tahun'] ?? "";
      _sertMerekController.text = datas[0]['sertifikat_merek_tahun'] ?? "";
      _noTestController.text = datas[0]['nomor_test_report_tahun'] ?? "";
      _sniController.text = datas[0]['sni_tahun'] ?? "";
      _jenisUsahaController.text = datas[0]['jenis_usaha'] ?? "";
      _merekUsahaController.text = datas[0]['merek_usaha'] ?? "";
      _investController.text = datas[0]['investasi_modal'] ?? "";
      _tenkerPriaController.text = datas[0]['jumlah_tenaga_kerja_pria'] ?? "";
      _tenkerWanitaController.text =
          datas[0]['jumlah_tenaga_kerja_wanita'] ?? "";
      _kapProdController.text = datas[0]['kapasitas_produksi_perbulan'] ?? "";
      _satProdController.text = datas[0]['satuan_produksi'] ?? "";
      _nilProdController.text = datas[0]['nilai_produksi_perbulan'] ?? "";
      _nilBahanController.text = datas[0]['nilai_bahan_baku_perbulan'] ?? "";
      _omsetController.text = datas[0]['omset'] ?? "";
      _latController.text = datas[0]['lat'] ?? "";
      _longController.text = datas[0]['lng'] ?? "";
      _medsosController.text = datas[0]['media_sosial'] ?? "";
      _kabupaten = datas[0]['id_kabupaten']
          ? ""
          : datas[0]['id_kabupaten'] == 0
              ? null
              : datas[0]['id_kabupaten'];
      _kecamatan = datas[0]['id_kecamatan'] ?? "";
      _kelurahan = datas[0]['id_kelurahan'] ?? "";
      _bentukUsaha = datas[0]['bentuk_usaha'] ?? "";
      _cabangIndustri = datas[0]['id_cabang_industri'] ?? "";
      _subCabangIndustri = datas[0]['id_sub_cabang_industri'] ?? "";
      _kbli = datas[0]['id_kbli'] != null ? datas[0]['id_kbli'].toString() : '';
      _pendidikan = datas[0]['rata_rata_pendidikan_tenaga_kerja'] ?? "";
      _latController.text = datas[0]['lat'] ?? "";
      _longController.text = datas[0]['lng'] ?? "";
      _medsosController.text = datas[0]['media_sosial'] ?? "";
      _fileString['bentuk_usaha_file'] = datas[0]['bentuk_usaha_file'] ?? "";
      _fileString['nib_file'] = datas[0]['nib_file'] ?? "";
      _fileString['sertifikat_halal_file'] =
          datas[0]['sertifikat_halal_file'] ?? "";
      _fileString['sertifikat_merek_file'] =
          datas[0]['sertifikat_merek_file'] ?? "";
      _fileString['sertifikat_sni_file'] =
          datas[0]['sertifikat_sni_file'] ?? "";
      _fileString['foto_alat_produksi'] = datas[0]['foto_alat_produksi'] ?? "";
      _fileString['foto_ruang_produksi'] =
          datas[0]['foto_ruang_produksi'] ?? "";
      _fileString['ktp'] = datas[0]['ktp'] ?? "";
      _fileString['kk'] = datas[0]['kk'] ?? "";
      _fileString['ktp_pasangan'] = datas[0]['ktp_pasangan'] ?? "";
    });
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
            formInputGroupWidget(
                "NIK", themeProvider.fontColor1, _nikController, null),
            formInputGroupWidget(
                "Nama", themeProvider.fontColor1, _namaController, null),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "Kabupaten",
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
                  final _dataList = result.data?['Kabupaten'];
                  return dropDownStringStyle2(_kabupaten, 'Pilih Kabupaten',
                      _dataList, Color(0xffE4E5E7), (newValue) {
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
            formInputGroupWidget("Alamat Lengkap", themeProvider.fontColor1,
                _alamatController, null),
            formInputGroupWidget(
                "No Hp", themeProvider.fontColor1, _noHpController, null),
            formInputGroupWidget("Nama Usaha", themeProvider.fontColor1,
                _namaUsahaController, null),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Bentuk Usaha", TextAlign.left, 17, FontWeight.normal),
            ),
            dropDown4(_bentukUsaha, 'nama', 'id', 'Pilih Bentuk Usaha',
                _listBentukUsaha, Color(0xffE4E5E7), (newValue) {
              setState(() {
                _bentukUsaha = newValue;
              });
            }),
            formFileGroupWidget(
                "File Dokumen Bentuk Usaha",
                "bentuk_usaha_file",
                themeProvider.fontColor1,
                _fileString['bentuk_usaha_file']),
            formInputGroupWidget("Tahun Berdiri", themeProvider.fontColor1,
                _tahunBerdiriController, null),
            formInputGroupWidget(
                "NIB/Tahun", themeProvider.fontColor1, _nibController, null),
            formFileGroupWidget("File Dokumen NIB", "nib_file",
                themeProvider.fontColor1, _fileString['nib_file']),
            formInputGroupWidget("Nomor Sertifikat Halal/Tahun",
                themeProvider.fontColor1, _sertHalalController, null),
            formFileGroupWidget(
                "File Sertifikat Halal",
                "sertifikat_halal_file",
                themeProvider.fontColor1,
                _fileString['sertifikat_halal_file']),
            formInputGroupWidget("Sertifikat Merek/Tahun",
                themeProvider.fontColor1, _sertMerekController, null),
            formFileGroupWidget(
                "File Sertifikat Merek",
                "sertifikat_merek_file",
                themeProvider.fontColor1,
                _fileString['sertifikat_merek_file']),
            formInputGroupWidget("Nomor Test Report/Tahun",
                themeProvider.fontColor1, _noTestController, null),
            formInputGroupWidget(
                "SNI/Tahun", themeProvider.fontColor1, _sniController, null),
            formFileGroupWidget("File Sertifikat SNI", "sertifikat_sni_file",
                themeProvider.fontColor1, _fileString['sertifikat_sni_file']),
            formInputGroupWidget("Jenis Usaha", themeProvider.fontColor1,
                _jenisUsahaController, null),
            formInputGroupWidget("Merek Usaha", themeProvider.fontColor1,
                _merekUsahaController, null),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Cabang Industri", TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options: QueryOptions(document: gql(getCabangIndustriQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _dataList = result.data?['cabangIndustri'];
                  return dropDownStringStyle2(
                      _cabangIndustri,
                      'Pilih Cabang Industri',
                      _dataList,
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
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1,
                  "Sub Cabang Industri", TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options:
                    QueryOptions(document: gql(getSubCabangIndustriQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _dataList = result.data?['SubCabangIndustri'];
                  return dropDownStringStyle2(
                      _subCabangIndustri,
                      'Pilih Sub Cabang Industri',
                      _cabangIndustri == null ? [] : _dataList,
                      Color(0xffE4E5E7), (newValue) {
                    setState(() {
                      _subCabangIndustri = newValue;
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(context, themeProvider.fontColor1, "KBLI",
                  TextAlign.left, 17, FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: Query(
                options: QueryOptions(document: gql(getKBLIQuery())),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Text("");
                  }
                  final _dataList = result.data?['Kbli'];
                  return dropDownStringStyle2(
                      _kbli, 'Pilih KBLI', _dataList, Color(0xffE4E5E7),
                      (newValue) {
                    setState(() {
                      _kbli = newValue;
                    });
                  });
                },
              ),
            ),
            formInputGroupWidget("Investasi/Modal", themeProvider.fontColor1,
                _investController, null),
            formInputGroupWidget("Jumlah Tenaga Kerja Pria",
                themeProvider.fontColor1, _tenkerPriaController, null),
            formInputGroupWidget("Jumlah Tenaga Kerja Wanita",
                themeProvider.fontColor1, _tenkerWanitaController, null),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: customText(
                  context,
                  themeProvider.fontColor1,
                  "Rata-Rata Pendidikan Tenaga Kerja",
                  TextAlign.left,
                  17,
                  FontWeight.normal),
            ),
            dropDown4(_pendidikan, 'nama', 'id', 'Pilih Rata-Rata Pendidikan',
                _listPendidikan, Color(0xffE4E5E7), (newValue) {
              setState(() {
                _pendidikan = newValue;
              });
            }),
            formInputGroupWidget("Kapasitas Produksi / Tahun",
                themeProvider.fontColor1, _kapProdController, null),
            formInputGroupWidget("Satuan Produksi", themeProvider.fontColor1,
                _satProdController, null),
            formInputGroupWidget("Nilai Produksi", themeProvider.fontColor1,
                _nilProdController, null),
            formInputGroupWidget("Nilai Bahan Baku", themeProvider.fontColor1,
                _nilBahanController, null),
            formInputGroupWidget(
                "Omset", themeProvider.fontColor1, _omsetController, null),
            formInputGroupWidget(
                "Latitude", themeProvider.fontColor1, _latController, null),
            formInputGroupWidget(
                "Longitude", themeProvider.fontColor1, _longController, null),
            formInputGroupWidget("Media sosial", themeProvider.fontColor1,
                _medsosController, null),
            formFileGroupWidget("Foto Alat Produksi", "foto_alat_produksi",
                themeProvider.fontColor1, _fileString['foto_alat_produksi']),
            formFileGroupWidget("Foto Ruang Produksi", "foto_ruang_produksi",
                themeProvider.fontColor1, _fileString['foto_ruang_produksi']),
            formFileGroupWidget(
                "KTP", "ktp", themeProvider.fontColor1, _fileString['ktp']),
            formFileGroupWidget(
                "KK", "kk", themeProvider.fontColor1, _fileString['kk']),
            formFileGroupWidget("KTP PASANGAN", "ktp_pasangan",
                themeProvider.fontColor1, _fileString['ktp_pasangan']),
            Mutation(
              options: MutationOptions(
                document: gql(badanUsahaMutation),
                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  FocusManager.instance.primaryFocus?.unfocus();

                  Navigator.popAndPushNamed(context, '/detailUsaha');
                },
                onError: (err) {
                  print(err);
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return button2("Simpan Perubahan", Colors.blue.shade600,
                    Color.fromARGB(255, 255, 255, 255), context, () {
                  var byteData1 = null;
                  var byteData2 = null;
                  var byteData3 = null;
                  var byteData4 = null;
                  var byteData5 = null;
                  var byteData6 = null;
                  var byteData7 = null;
                  var byteData8 = null;
                  var byteData9 = null;
                  var byteData10 = null;

                  if (_file['bentuk_usaha_file'] != null) {
                    byteData1 = _file['bentuk_usaha_file']!.readAsBytesSync();
                  }
                  if (_file['sertifikat_halal_file'] != null) {
                    byteData2 =
                        _file['sertifikat_halal_file']!.readAsBytesSync();
                  }
                  if (_file['sertifikat_merek_file'] != null) {
                    byteData3 =
                        _file['sertifikat_merek_file']!.readAsBytesSync();
                  }
                  if (_file['sertifikat_sni_file'] != null) {
                    byteData4 = _file['sertifikat_sni_file']!.readAsBytesSync();
                  }
                  if (_file['nib_file'] != null) {
                    byteData5 = _file['nib_file']!.readAsBytesSync();
                  }
                  if (_file['foto_alat_produksi_file'] != null) {
                    byteData6 =
                        _file['foto_alat_produksi_file']!.readAsBytesSync();
                  }
                  if (_file['foto_ruang_produksi_file'] != null) {
                    byteData7 =
                        _file['foto_ruang_produksi_file']!.readAsBytesSync();
                  }
                  if (_file['ktp'] != null) {
                    byteData8 = _file['ktp']!.readAsBytesSync();
                  }
                  if (_file['kk'] != null) {
                    byteData9 = _file['kk']!.readAsBytesSync();
                  }
                  if (_file['ktp_pasangan'] != null) {
                    byteData10 = _file['ktp_pasangan']!.readAsBytesSync();
                  }

                  var multipartFile1 = null;
                  var multipartFile2 = null;
                  var multipartFile3 = null;
                  var multipartFile4 = null;
                  var multipartFile5 = null;
                  var multipartFile6 = null;
                  var multipartFile7 = null;
                  var multipartFile8 = null;
                  var multipartFile9 = null;
                  var multipartFile10 = null;

                  if (byteData1 != null) {
                    multipartFile1 = MultipartFile.fromBytes(
                      'bentuk_usaha_file',
                      byteData1,
                      filename:
                          '${DateTime.now().second}.${_file['bentuk_usaha_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData2 != null) {
                    multipartFile2 = MultipartFile.fromBytes(
                      'sertifikat_halal_file',
                      byteData2,
                      filename:
                          '${DateTime.now().second}.${_file['sertifikat_halal_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData3 != null) {
                    multipartFile3 = MultipartFile.fromBytes(
                      'sertifikat_merek_file',
                      byteData3,
                      filename:
                          '${DateTime.now().second}.${_file['sertifikat_merek_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData4 != null) {
                    multipartFile4 = MultipartFile.fromBytes(
                      'sertifikat_sni_file',
                      byteData4,
                      filename:
                          '${DateTime.now().second}.${_file['sertifikat_sni_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData5 != null) {
                    multipartFile5 = MultipartFile.fromBytes(
                      'nib_file',
                      byteData5,
                      filename:
                          '${DateTime.now().second}.${_file['nib_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData6 != null) {
                    multipartFile6 = MultipartFile.fromBytes(
                      'foto_alat_produksi_file',
                      byteData6,
                      filename:
                          '${DateTime.now().second}.${_file['foto_alat_produksi_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData7 != null) {
                    multipartFile7 = MultipartFile.fromBytes(
                      'foto_ruang_produksi_file',
                      byteData7,
                      filename:
                          '${DateTime.now().second}.${_file['foto_ruang_produksi_file'].toString().split(".").last}',
                    );
                  }
                  if (byteData8 != null) {
                    multipartFile8 = MultipartFile.fromBytes(
                      'ktp',
                      byteData8,
                      filename:
                          '${DateTime.now().second}.${_file['ktp'].toString().split(".").last}',
                    );
                  }
                  if (byteData9 != null) {
                    multipartFile9 = MultipartFile.fromBytes(
                      'kk',
                      byteData9,
                      filename:
                          '${DateTime.now().second}.${_file['kk'].toString().split(".").last}',
                    );
                  }
                  if (byteData10 != null) {
                    multipartFile10 = MultipartFile.fromBytes(
                      'ktp_pasangan',
                      byteData10,
                      filename:
                          '${DateTime.now().second}.${_file['ktp_pasangan'].toString().split(".").last}',
                    );
                  }

                  runMutation(<String, dynamic>{
                    'user_id': _idUser,
                    'nik': _nikController.text,
                    'nama_direktur': _namaController.text,
                    'id_kabupaten': _kabupaten,
                    'kecamatan': _kecamatan,
                    'kelurahan': _kelurahan,
                    'alamat_lengkap': _alamatController.text,
                    'no_hp': _noHpController.text,
                    'nama_usaha': _namaUsahaController.text,
                    'bentuk_usaha': _bentukUsaha,
                    'tahun_berdiri': _tahunBerdiriController.text == ""
                        ? null
                        : _tahunBerdiriController.text,
                    'nib_tahun': _nibController.text,
                    'nomor_sertifikat_halal_tahun': _sertHalalController.text,
                    'sertifikat_merek_tahun': _sertMerekController.text,
                    'nomor_test_report_tahun': _noTestController.text,
                    'sni_tahun': _sniController.text,
                    'jenis_usaha': _jenisUsahaController.text,
                    'merek_usaha': _merekUsahaController.text,
                    'cabang_industri': _cabangIndustri,
                    'sub_cabang_industri': _subCabangIndustri,
                    'id_kbli': _kbli,
                    'investasi_modal': _investController.text,
                    'jumlah_tenaga_kerja_pria': _tenkerPriaController.text,
                    'jumlah_tenaga_kerja_wanita': _tenkerWanitaController.text,
                    'rata_rata_pendidikan_tenaga_kerja': _pendidikan,
                    'kapasitas_produksi_perbulan': _kapProdController.text,
                    'satuan_produksi': _satProdController.text,
                    'nilai_produksi_perbulan': _nilProdController.text,
                    'nilai_bahan_baku_perbulan': _nilBahanController.text,
                    'lat':
                        _latController.text == "" ? null : _latController.text,
                    'lng': _longController.text == ""
                        ? null
                        : _longController.text,
                    'media_sosial': _medsosController.text,
                    'bentuk_usaha_file': multipartFile1,
                    'sertifikat_halal_file': multipartFile2,
                    'sertifikat_merek_file': multipartFile3,
                    'sertifikat_sni_file': multipartFile4,
                    'nib_file': multipartFile5,
                    'foto_alat_produksi_file': multipartFile6,
                    'foto_ruang_produksi_file': multipartFile7,
                    'ktp': multipartFile8,
                    'kk': multipartFile9,
                    'ktp_pasangan': multipartFile10,
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
