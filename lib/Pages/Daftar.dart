import 'dart:async';
import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/DropDownString.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Daftar extends StatefulWidget {
  const Daftar({Key? key}) : super(key: key);

  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  FunctionGroup functionGroup = new FunctionGroup();
  late Position position;
  CRUD crud = new CRUD();
  final _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  List<Marker> allMarkers = [];
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
  TextEditingController _namaPemilikController = new TextEditingController();
  TextEditingController _namaPerusahaanController = new TextEditingController();
  TextEditingController _nikController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _nomorTelponController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          "Daftar",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          gradientBg(),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  inputForm(null, "Nama Pemilik", "Nama Pemilik",
                      "Tidak Boleh Kosong", _namaPemilikController, false),
                  inputForm(null, "Nama Perusahaan", "Nama Perusahaan",
                      "Tidak Boleh Kosong", _namaPerusahaanController, false),
                  inputForm(null, "NIK", "NIK", "Tidak Boleh Kosong",
                      _nikController, false),
                  dropDownString(_provinsi, 'Provinsi', _listProvinsi,
                      (newValue) {
                    setState(() {
                      _provinsi = newValue!;
                    });
                  }),
                  dropDownString(_kabupaten, 'Kabupaten', _listKabupaten,
                      (newValue) {
                    crud
                        .getData("/kabupaten/" + newValue + "/kecamatan")
                        .then((data) {
                      setState(() {
                        _listKecamatan = jsonDecode(data.body);
                        _kabupaten = newValue;
                      });
                    });
                  }),
                  // Text(_listKabupaten[0].toString()),
                  dropDownString(_kecamatan, 'Kecamatan', _listKecamatan,
                      (newValue) {
                    crud
                        .getData("/kecamatan/" + newValue + "/kelurahan")
                        .then((data) {
                      setState(() {
                        _listKelurahan = jsonDecode(data.body);
                        _kecamatan = newValue;
                      });
                    });
                  }),
                  dropDownString(_kelurahan, 'Kelurahan', _listKelurahan,
                      (newValue) {
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
                  inputForm(null, "Nomor Telpon", "Nomor Telpon",
                      "Tidak Boleh Kosong", _nomorTelponController, false),
                  inputForm(null, "Email", "Email", "Tidak Boleh Kosong",
                      _emailController, false),
                  inputForm(null, "Password", "Password", "Tidak Boleh Kosong",
                      _passwordController, true),
                  inputForm(null, "Confirm Password", "Confirm Password",
                      "Tidak Boleh Kosong", _confirmPasswordController, true),
                  Container(
                    width: double.infinity,
                    child: button1("Daftar", themeProvider.buttonColor, context,
                        () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, String> dataUsers = {
                          "nama": _namaPemilikController.text,
                          "nama_perusahaan": _namaPerusahaanController.text,
                          "nik": _nikController.text,
                          "id_provinsi": _provinsi,
                          "id_kabupaten": _kabupaten,
                          "id_kecamatan": _kecamatan,
                          "id_kelurahan": _kelurahan,
                          "lat": "37.42796133580664",
                          "lng": "-122.085749655962",
                          "alamat": _alamatController.text,
                          "nomor_telpon": _nomorTelponController.text,
                          "tipe_user": "Pengusaha",
                          "email": _emailController.text,
                          "password": _passwordController.text,
                        };
                        crud.postData("/users", dataUsers).then((res) {
                          if (res.statusCode == 201) {
                            functionGroup.saveCache(dataUsers);
                            Navigator.pushNamed(context, '/homeLayoutPage',
                              arguments: <String, dynamic>{"selectedIndex": 3});
                          } else {
                            print("error");
                          }
                        });
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
