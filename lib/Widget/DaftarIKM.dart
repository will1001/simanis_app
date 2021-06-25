import 'dart:async';
import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/DropDownString.dart';
import 'package:appsimanis/Widget/Dropdown3.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List _listProvinsi = [
    {'id': '52', 'name': 'Nusa Tenggara Barat'}
  ];
  List _listKabupaten = [];
  List _listKecamatan = [];
  List _listKelurahan = [];
  List<Marker> allMarkers = [];
  String _lat = "";
  String _lng = "";
   static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _namaPerusahaanController = new TextEditingController();
  TextEditingController _namaPemilikController = new TextEditingController();
  TextEditingController _nomorTeleponController = new TextEditingController();

  getCabangIndsutri() {
    crud.getData("/cabang_industri").then((res) {
      setState(() {
        _listCabangIndustri = jsonDecode(res.body);
      });
    });
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUserCache = prefs.getString('idUser');
    setState(() {
      _idUser = idUserCache!;
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
    setState(() {
      _alamatController.text = alamat;
      _lat = position.latitude.toString();
      _lng = position.longitude.toString();
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
    // print(placemarks);
  }

  @override
  void initState() {
    super.initState();
    getCabangIndsutri();
    getIdUser();
    crud.getData("/provinsi/52/kabupaten").then((data) {
      // print(jsonDecode(data.body));
      setState(() {
        _listKabupaten = jsonDecode(data.body);
      });
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
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 50,
              width: 1000,
              child: dropDown3(_cabangIndustri, "nama", "cabang industri",
                  _listCabangIndustri, (newValue) {
                setState(() {
                  _cabangIndustri = newValue!;
                });
              }),
            ),
          ),
          // Text("$_idUser"),
          dropDownString(_provinsi, 'Provinsi', _listProvinsi, (newValue) {
            setState(() {
              _provinsi = newValue!;
            });
          }),
          dropDownString(_kabupaten, 'Kabupaten', _listKabupaten, (newValue) {
            crud.getData("/kabupaten/" + newValue + "/kecamatan").then((data) {
              setState(() {
                _listKecamatan = jsonDecode(data.body);
                _kabupaten = newValue;
              });
            });
          }),
          dropDownString(_kecamatan, 'Kecamatan', _listKecamatan, (newValue) {
            crud.getData("/kecamatan/" + newValue + "/kelurahan").then((data) {
              setState(() {
                _listKelurahan = jsonDecode(data.body);
                _kecamatan = newValue;
              });
            });
          }),
          dropDownString(_kelurahan, 'Kelurahan', _listKelurahan, (newValue) {
            setState(() {
              _kelurahan = newValue;
            });
          }),
          inputForm(null, "Alamat", "Alamat", "Tidak Boleh Kosong",
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
          inputForm(null, "Nama Perusahaan", "Nama Perusahaan",
              "Tidak Boleh Kosong", _namaPerusahaanController, false),
          inputForm(null, "Nama Pemilik", "Nama Pemilik", "Tidak Boleh Kosong",
              _namaPemilikController, false),
          inputForm(null, "Nomor Telepon", "Nomor Telepon",
              "Tidak Boleh Kosong", _nomorTeleponController, false),
          button1("Simpan", themeProvider.buttonColor, context, () {
            Map<String, String> data = {
              'id_cabang_industri': _cabangIndustri,
              'tahun_badan_usaha': "",
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
              'male': "",
              'famale': "",
              'nilai_investasi': "",
              'kapasitas_produksi': "",
              'satuan_produksi': "",
              'nilai_produksi': "",
              'nilai_bb_bp': "",
              'jenis_ikm': "",
              'status_verifikasi': "Belum diverifikasi",
              'catatan_verifikasi': "",
              'lat': _lat,
              'lng': _lng,
              'foto_alat_produksi': "",
              'foto_ruang_produksi': "",
              'tanggal_verifikasi': "",
              'nomor_telpon': _nomorTeleponController.text,
              'media_sosial': "",
            };
            // print(data);
            crud.postData("/badan_usaha", data);
            // Navigator.pushNamed(context, '/informasiIKM');
            Navigator.popAndPushNamed(context, '/informasiIKM');
          })
        ],
      ),
    );
  }
}
