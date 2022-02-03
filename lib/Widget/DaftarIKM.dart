import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/DropDownString.dart';
import 'package:appsimanis/Widget/Dropdown3.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'InputFormImage.dart';
import 'PanelPopUp.dart';

// Widget daftarIKM(String _a,List _listCabangIndustri,var _daftarIKMOnchanged) {
//   return Scaffold(
//     body: ListView(
//       children: [dropDown3(_a, "nama", "cabang industri", _listCabangIndustri, _daftarIKMOnchanged)],
//     ),
//   );
// }

class DaftarIKM extends StatefulWidget {
  const DaftarIKM({Key? key}) : super(key: key);

  @override
  _DaftarIKMState createState() => _DaftarIKMState();
}

class _DaftarIKMState extends State<DaftarIKM> {
  List _listCabangIndustri = [];
  Completer<GoogleMapController> _controller = Completer();
  String _cabangIndustri = "";
  String _idUser = "";
  String _provinsi = "52";
  String _kabupaten = "";
  String _kecamatan = "";
  String _kelurahan = "";
  File? _fotoAlatProduksiFile;
  File? _fotoRuangProduksiFile;
  PickedFile? _fotoAlatProduksi;
  PickedFile? _fotoRuangProduksi;
  String? _fotoAlatProduksiUrl = "";
  String? _fotoRuangProduksiUrl = "";
  bool _showPopUp = false;

  Future<void> uploadImage(String _foto) async {
    var request = http.MultipartRequest('POST',
        Uri.parse("https://simanis.ntbprov.go.id/api/badan_usaha/uploadgbr"));
    request.files.add(http.MultipartFile(
        'file',
        File(_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .readAsBytes()
            .asStream(),
        File(_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .lengthSync(),
        filename: (_foto == "Alat"
                ? _fotoAlatProduksi!.path
                : _fotoRuangProduksi!.path)
            .toString()
            .split('.')
            .last));
    request.fields['audio'] = 'value';
    request.fields['name'] = "${_foto == 'Alat' ? 'Alat' : 'Ruang'}_$_idUser." +
        (_foto == "Alat" ? _fotoAlatProduksi!.path : _fotoRuangProduksi!.path)
            .toString()
            .split('.')
            .last;
    request.fields['tipe_foto'] = _foto == "Alat" ? "Alat" : "Ruang";
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {
      // print(value);
    });
  }

  List _listProvinsi = [
    {'id': '52', 'name': 'Nusa Tenggara Barat'}
  ];
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List<Marker> allMarkers = [];
  String _nilaiInvest = "";
  String _jenisBadanUsaha = "";
  String _lat = "";
  String _tahunBerdiri = "";
  String _lng = "";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _namaPerusahaanController = new TextEditingController();
  TextEditingController _namaPemilikController = new TextEditingController();
  TextEditingController _nomorTeleponController = new TextEditingController();
  TextEditingController _latController = new TextEditingController();
  TextEditingController _lngController = new TextEditingController();
  TextEditingController _lkController = new TextEditingController();
  TextEditingController _prController = new TextEditingController();

  Future<void> selectdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        _tahunBerdiri = picked.toString();
      });
  }

  getCabangIndsutri() {
    crud.getData("/cabang_industri").then((res) {
      if (mounted) {
        setState(() {
          _listCabangIndustri = jsonDecode(res.body);
        });
      }
    });
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    crud.getData("/usersEmail/$email").then((res) async {
      // print(res.statusCode);
      if (res.statusCode == 200) {
        await prefs.setString('idUser', jsonDecode(res.body)[0]["id"] ?? "");
        if (mounted) {
          setState(() {
            _idUser = jsonDecode(res.body)[0]["id"] ?? "";
          });
        }
      }
    });
  }

  getAlamat() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    CameraPosition _currentPosition = CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        tilt: 0,
        zoom: 16.5);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
    String alamat = placemarks[0].street.toString() +
        " " +
        placemarks[0].subLocality.toString() +
        " " +
        placemarks[0].locality.toString() +
        " " +
        placemarks[0].subAdministrativeArea.toString() +
        " " +
        placemarks[0].administrativeArea.toString();
    if (mounted) {
      setState(() {
        _alamatController.text = alamat;
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        // String _getkabupaten =
        //     placemarks[0].subAdministrativeArea.toString().toUpperCase();
        // String _getkecamatan = placemarks[0].locality.toString().toUpperCase();
        // String _getkelurahan = placemarks[0].subLocality.toString().toUpperCase();
        // _listKabupaten.add(_getkabupaten);
        // _listKecamatan.add(_getkecamatan);
        // _listKelurahan.add(_getkelurahan);
        // _kabupaten = _getkabupaten;
        // _kecamatan = _getkecamatan;
        // _kelurahan = _getkelurahan;
        allMarkers.add(Marker(
            markerId: MarkerId("marker1"),
            draggable: false,
            onTap: () {},
            position: LatLng(position.latitude, position.longitude)));
      });
    }
    // print(placemarks);
  }

  @override
  void initState() {
    super.initState();
    getCabangIndsutri();
    getIdUser();
    crud.getData("/provinsi/52/kabupaten").then((data) {
      // print(jsonDecode(data.body));
      if (mounted) {
        setState(() {
          _listKabupaten = jsonDecode(data.body);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: textLabel("Daftar IKM", 15, Colors.black, "", FontWeight.w400),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 50,
                  width: 1000,
                  child: dropDown3(_cabangIndustri, "nama", "cabang industri",
                      _listCabangIndustri, (newValue) {
                    if (mounted) {
                      setState(() {
                        _cabangIndustri = newValue!;
                      });
                    }
                  }),
                ),
              ),
              // Text("$_idUser"),
              dropDownString(_provinsi, 'Provinsi', _listProvinsi, (newValue) {
                if (mounted) {
                  setState(() {
                    _provinsi = newValue!;
                  });
                }
              }),
              dropDownString(_kabupaten, 'Kabupaten', _listKabupaten,
                  (newValue) {
                crud
                    .getData("/kabupaten/" + newValue + "/kecamatan")
                    .then((data) {
                  if (mounted) {
                    setState(() {
                      _kecamatan = "";
                      _kelurahan = "";
                      _listKecamatan.clear();
                      _listKelurahan.clear();
                      _listKecamatan = jsonDecode(data.body);
                      _kabupaten = newValue;
                    });
                  }
                });
              }),
              dropDownString(_kecamatan, 'Kecamatan', _listKecamatan,
                  (newValue) {
                crud
                    .getData("/kecamatan/" + newValue + "/kelurahan")
                    .then((data) {
                  if (mounted) {
                    setState(() {
                      _kelurahan = "";
                      _listKelurahan.clear();
                      _listKelurahan = jsonDecode(data.body);
                      _kecamatan = newValue;
                    });
                  }
                });
              }),
              dropDownString(_kelurahan, 'Kelurahan', _listKelurahan,
                  (newValue) {
                if (mounted) {
                  setState(() {
                    _kelurahan = newValue;
                  });
                }
              }),
              inputForm(null, "Alamat", "text", "Alamat", "Tidak Boleh Kosong",
                  _alamatController, false),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    markers: Set.from(allMarkers),
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      getAlamat();
                    },
                    icon: Icon(Icons.place),
                    label: Text("Cari Lokasi"),
                    style: ElevatedButton.styleFrom(
                        primary: themeProvider.buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 10)),
                  ),
                ),
              ),
              inputForm(null, "Latitude", "text", "Latitude",
                  "Tidak Boleh Kosong", _latController, false),
              inputForm(null, "Longitude", "text", "Longitude",
                  "Tidak Boleh Kosong", _lngController, false),
              inputForm(null, "Nama Perusahaan", "text", "Nama Perusahaan",
                  "Tidak Boleh Kosong", _namaPerusahaanController, false),
              inputForm(null, "Nama Pemilik", "text", "Nama Pemilik",
                  "Tidak Boleh Kosong", _namaPemilikController, false),
              inputForm(null, "Nomor Telepon", "number", "Nomor Telepon",
                  "Tidak Boleh Kosong", _nomorTeleponController, false),
              dropDown3(_nilaiInvest, "", "Nilai Investasi", [
                'Industri Kecil (< Rp.1.000.000.000)',
                'Industri Menengah (Rp.1.000.000.000 - Rp.15.000.000.000)',
                'Industri Besar (> Rp.15.000.000.000)'
              ], (newValue) {
                setState(() {
                  _nilaiInvest = newValue!;
                });
              }),
              dropDown3(
                  _jenisBadanUsaha, "", "Jenis Badan Usaha", ['UD', 'CV', 'PT'],
                  (newValue) {
                setState(() {
                  _jenisBadanUsaha = newValue!;
                });
              }),
              GestureDetector(
                  onTap: () {
                    selectdate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Tahun Badan Usaha : ${_tahunBerdiri == "" ? "" : dateFormat((_tahunBerdiri))}"),
                        Icon(Icons.calendar_today)
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Jumlah Tenaga Kerja"),
              ),
              inputForm(null, "Laki - Laki", "number", "Laki - Laki",
                  "Tidak Boleh Kosong", _lkController, false),
              inputForm(null, "Perempuan", "number", "Perempuan",
                  "Tidak Boleh Kosong", _prController, false),
              inputFormImage(context, "Foto Alat Produksi :", "",
                  "$_storageUrl" + "", _fotoAlatProduksiFile, () async {
                await Permission.photos.request();
                final picker = ImagePicker();

                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    _fotoAlatProduksi = pickedFile;
                    _fotoAlatProduksiFile = File(pickedFile.path);
                    _fotoAlatProduksiUrl =
                        "foto_alat_produksi/Alat_$_idUser.${pickedFile.path.toString().split('.').last}";
                    // _imagePath = pickedFile.path;
                  } else {
                    print('No image selected.');
                  }
                });
                uploadImage("Alat");
                Map<String, String> data = {
                  'foto_alat_produksi':
                      'foto_alat_produksi/Alat_$_idUser.${pickedFile!.path.toString().split('.').last}'
                };
                // print(data);
                // crud.putData('/badan_usaha/foto_alat_produksi/${_idUser}', data);
              }, () async {
                await Permission.camera.request();
                final picker = ImagePicker();

                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);

                setState(() {
                  if (pickedFile != null) {
                    _fotoAlatProduksi = pickedFile;
                    _fotoAlatProduksiFile = File(pickedFile.path);
                    _fotoAlatProduksiUrl =
                        "foto_alat_produksi/Alat_$_idUser.${pickedFile.path.toString().split('.').last}";
                    // _imagePath = pickedFile.path;
                  } else {
                    print('No image selected.');
                  }
                });
                uploadImage("Alat");
                Map<String, String> data = {
                  'foto_alat_produksi':
                      'foto_alat_produksi/Alat_$_idUser.${pickedFile!.path.toString().split('.').last}'
                };
                // crud.putData('/badan_usaha/foto_alat_produksi/${_idUser}', data);
              }),
              inputFormImage(context, "Foto Ruang Produksi :", "",
                  "$_storageUrl" + "", _fotoRuangProduksiFile, () async {
                await Permission.photos.request();
                final picker = ImagePicker();

                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    _fotoRuangProduksi = pickedFile;
                    _fotoRuangProduksiFile = File(pickedFile.path);
                    _fotoRuangProduksiUrl =
                        'foto_ruang_produksi/Ruang_$_idUser.${pickedFile.path.toString().split('.').last}';
                    // _imagePath = pickedFile.path;
                  } else {
                    print('No image selected.');
                  }
                });
                uploadImage("Ruang");
                Map<String, String> data = {
                  'foto_ruang_produksi':
                      'foto_ruang_produksi/Ruang_$_idUser.${pickedFile!.path.toString().split('.').last}'
                };
                // crud.putData('/badan_usaha/foto_ruang_produksi/${_idUser}', data);
              }, () async {
                await Permission.camera.request();
                final picker = ImagePicker();

                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);

                setState(() {
                  if (pickedFile != null) {
                    _fotoRuangProduksi = pickedFile;
                    _fotoRuangProduksiFile = File(pickedFile.path);
                    _fotoRuangProduksiUrl =
                        'foto_ruang_produksi/Ruang_$_idUser.${pickedFile.path.toString().split('.').last}';
                    // _imagePath = pickedFile.path;
                  } else {
                    print('No image selected.');
                  }
                });
                uploadImage("Ruang");
                // Map<String, String> data = {
                //   'foto_ruang_produksi':
                //       'foto_ruang_produksi/Ruang_$_idUser.${pickedFile!.path.toString().split('.').last}'
                // };
                // crud.putData('/badan_usaha/foto_ruang_produksi/$_idUser', data);
              }),
              button1("Simpan", themeProvider.buttonColor, context, () {
                if (_cabangIndustri == "" ||
                    _tahunBerdiri == "" ||
                    _kabupaten == "" ||
                    _kecamatan == "" ||
                    _kelurahan == "" ||
                    _namaPerusahaanController.text == "" ||
                    _namaPemilikController.text == "" ||
                    _alamatController.text == "" ||
                    _lkController.text == "" ||
                    _prController.text == "" ||
                    _jenisBadanUsaha == "" ||
                    _latController.text == "" ||
                    _lngController.text == "" ||
                    _fotoAlatProduksiUrl.toString() == "" ||
                    _fotoRuangProduksiUrl.toString() == "" ||
                    _nomorTeleponController.text == "") {
                  // print("kosong");
                  setState(() {
                    _showPopUp = true;
                  });
                } else {
                  // print(_cabangIndustri);
                  // print(_tahunBerdiri);
                  // print(_kabupaten);
                  // print(_kecamatan);
                  // print(_kelurahan);
                  // print(_namaPerusahaanController.text);
                  // print(_namaPemilikController.text);
                  // print(_alamatController.text);
                  // print(_lkController.text);
                  // print(_prController.text);
                  // print(_jenisBadanUsaha);
                  // print(_latController.text);
                  // print(_lngController.text);
                  // print(_fotoAlatProduksiUrl.toString());
                  // print(_fotoRuangProduksiUrl.toString());
                  // print(_nomorTeleponController.text);
                  Map<String, String> data = {
                    'id_cabang_industri': _cabangIndustri,
                    'tahun_badan_usaha': dateFormat(_tahunBerdiri),
                    'id_user': _idUser,
                    'id_provinsi': _provinsi,
                    'id_kabupaten': _kabupaten,
                    'id_kecamatan': _kecamatan,
                    'id_kelurahan': _kelurahan,
                    'nama_perusahaan': _namaPerusahaanController.text,
                    'nama_pemilik': _namaPemilikController.text,
                    'alamat': _alamatController.text,
                    'bentuk_badan_usaha': "",
                    'kbli_2019': "",
                    'male': _lkController.text,
                    'famale': _prController.text,
                    'nilai_investasi': _nilaiInvest,
                    'kapasitas_produksi': "",
                    'satuan_produksi': "",
                    'nilai_produksi': "",
                    'nilai_bb_bp': "",
                    'jenis_ikm': _jenisBadanUsaha,
                    'status_verifikasi': "Belum diverifikasi",
                    'catatan_verifikasi': "",
                    'lat': _latController.text,
                    'lng': _lngController.text,
                    'foto_alat_produksi': _fotoAlatProduksiUrl.toString(),
                    'foto_ruang_produksi': _fotoRuangProduksiUrl.toString(),
                    'tanggal_verifikasi': "",
                    'nomor_telpon': _nomorTeleponController.text,
                    'media_sosial': "",
                  };
                  // print(data);
                  crud.postData("/badan_usaha", data);
                  // Navigator.pushNamed(context, '/informasiIKM');
                  Navigator.pop(context);
                }
              })
            ],
          ),
          _showPopUp
              ? panelPopUp(context, "Mohon isi semua Data", () {}, () {
                  setState(() {
                    _showPopUp = false;
                  });
                })
              : Container()
        ],
      ),
    );
  }
}
