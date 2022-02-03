import 'dart:async';
import 'dart:convert';

import 'package:appsimanis/Model/CRUD.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/DropDownString.dart';
import 'package:appsimanis/Widget/DropDownStringStyle2.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/InputForm.dart';
import 'package:appsimanis/Widget/InputFormStyle3.dart';
import 'package:appsimanis/Widget/PanelPopUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // late Position position;
  CRUD crud = new CRUD();
  final _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  List<Marker> allMarkers = [];
  bool _showPopUp = false;
  bool _namaPemilikError = false;
  bool _nikError = false;
  bool _alamatError = false;
  bool _latError = false;
  bool _lngError = false;
  bool _nomorTelponError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

  String _message = "";
  String _provinsi = "52";
  String _kabupaten = "";
  String _kecamatan = "";
  String _kelurahan = "";
  String _lat = "";
  String _lng = "";
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
  TextEditingController _latController = new TextEditingController();
  TextEditingController _lngController = new TextEditingController();

  getAlamat() async {
    // LocationPermission permission = await Geolocator.requestPermission();
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
      backgroundColor: Color(0xff2BA33A),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            )),
        title: customText(context, Colors.white, "Daftar Akun", TextAlign.left,
            20, FontWeight.w600),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
        child: ListView(
          children: [
            customText(context, Colors.white, "Nama Pemilik", TextAlign.left,
                14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Nama Pemilik",
                  "text",
                  "Nama Pemilik",
                  "Nama Pemilik Tidak Boleh Kosong",
                  _namaPemilikError,
                  _namaPemilikController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "NIK", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "NIK",
                  "number",
                  "NIK",
                  "NIK Tidak Boleh Kosong",
                  _nikError,
                  _nikController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Provinsi", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: dropDownStringStyle2(
                  _provinsi, 'Provinsi', _listProvinsi, Colors.white,
                  (newValue) {
                setState(() {
                  _provinsi = newValue!;
                });
              }),
            ),
            customText(context, Colors.white, "Kabupaten", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: dropDownStringStyle2(
                  _kabupaten, 'Kabupaten', _listKabupaten, Colors.white,
                  (newValue) {
                crud
                    .getData("/kabupaten/" + newValue + "/kecamatan")
                    .then((data) {
                  setState(() {
                    _kecamatan = "";
                    _kelurahan = "";
                    _listKecamatan.clear();
                    _listKelurahan.clear();
                    _listKecamatan = jsonDecode(data.body);
                    _kabupaten = newValue;
                  });
                });
              }),
            ),
            customText(context, Colors.white, "Kecamatan", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: dropDownStringStyle2(
                  _kecamatan, 'Kecamatan', _listKecamatan, Colors.white,
                  (newValue) {
                crud
                    .getData("/kecamatan/" + newValue + "/kelurahan")
                    .then((data) {
                  setState(() {
                    _kelurahan = "";
                    _listKelurahan.clear();
                    _listKelurahan = jsonDecode(data.body);
                    _kecamatan = newValue;
                  });
                });
              }),
            ),
            customText(context, Colors.white, "Kelurahan", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: dropDownStringStyle2(
                  _kelurahan, 'Kelurahan', _listKelurahan, Colors.white,
                  (newValue) {
                setState(() {
                  _kelurahan = newValue;
                });
              }),
            ),
            customText(context, Colors.white, "Alamat", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Alamat",
                  "text",
                  "Alamat",
                  "Alamat Tidak Boleh Kosong",
                  _alamatError,
                  _alamatController,
                  false,
                  () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
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
              padding: const EdgeInsets.all(0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    getAlamat();
                  },
                  icon: Icon(
                    Icons.place,
                    color: Color(0xff2BA33A),
                  ),
                  label: customText(context, Color(0xff2BA33A), "Cari Lokasi",
                      TextAlign.left, 20, FontWeight.w500),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ),
            customText(context, Colors.white, "Latitude", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Latitude",
                  "number",
                  "Latitude",
                  "Latitude Tidak Boleh Kosong",
                  _latError,
                  _latController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Longitude", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Longitude",
                  "number",
                  "Longitude",
                  "Longitude Tidak Boleh Kosong",
                  _lngError,
                  _lngController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Nomor Telpon", TextAlign.left,
                14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Nomor Telpon",
                  "number",
                  "Nomor Telpon",
                  "Nomor Telpon Tidak Boleh Kosong",
                  _nomorTelponError,
                  _nomorTelponController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Email", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Email",
                  "text",
                  "Email",
                  "Email Tidak Boleh Kosong",
                  _emailError,
                  _emailController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Password", TextAlign.left, 14,
                FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Password",
                  "text",
                  "Password",
                  "Password Tidak Boleh Kosong",
                  _passwordError,
                  _passwordController,
                  false,
                  () {}),
            ),
            customText(context, Colors.white, "Confirm Password",
                TextAlign.left, 14, FontWeight.w400),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16),
              child: inputFormStyle3(
                  null,
                  "Confirm Password",
                  "text",
                  "Confirm Password",
                  "Confirm Password Tidak Boleh Kosong",
                  _confirmPasswordError,
                  _confirmPasswordController,
                  false,
                  () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 40),
              child: button2("Daftar", Colors.white, Color(0xff2BA33A), context,
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
                    "lat": _latController.text,
                    "lng": _lngController.text,
                    "alamat": _alamatController.text,
                    "nomor_telpon": _nomorTelponController.text,
                    "tipe_user": "Pengusaha",
                    "email": _emailController.text,
                    "password": _passwordController.text,
                  };

                  Map<String, String> checkData = {
                    "email": _emailController.text,
                    "password": _passwordController.text,
                  };

                  crud.checkLogin(checkData).then((res) {
                    var data = jsonDecode(res.body);
                    // print(data['message']);
                    if (data['message'] == 'data ada' ||
                        data['message'] == 'Password Salah') {
                      setState(() {
                        _showPopUp = true;
                        _message = "Email sudah Terdaftar";
                      });
                    } else {
                      crud.postData("/users", dataUsers).then((res) {
                        if (res.statusCode == 201) {
                          functionGroup.saveCache(dataUsers);
                          Navigator.pushNamed(context, '/homeLayoutPage',
                              arguments: <String, dynamic>{"selectedIndex": 4});
                        } else {
                          print("error");
                        }
                      });
                    }
                  });
                }
              }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 65),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Sudah punya akun?",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: " Login disini",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
