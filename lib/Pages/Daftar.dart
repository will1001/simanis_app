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
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../Widget/inputFormStyle4.dart';

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
  bool _obscPass = true;
  String _errMsg = "";
  Color _colorMsg = Colors.red;

  String _message = "";
  String _provinsi = "52";
  String? _kabupaten = null;
  String? _kecamatan = null;
  String? _kelurahan = null;
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

  registerMutation(nik, pass, nama, no_hp) {
    return '''
      mutation{
        register(nik:"${nik}",password:"${pass}",nama_direktur:"${nama}",no_hp:"${no_hp}"){
          messagges
        }
      }
    ''';
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
      _latController.text = position.latitude.toString();
      _lngController.text = position.longitude.toString();
      allMarkers.add(Marker(
          markerId: MarkerId("marker1"),
          draggable: false,
          onTap: () {},
          position: LatLng(position.latitude, position.longitude)));
    });
  }

  @override
  void initState() {
    super.initState();
    _nikController.addListener(() {});
    _passwordController.addListener(() {});
    _namaPemilikController.addListener(() {});
    _nomorTelponController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: customText(context, themeProvider.fontColor1,
                "Pendaftaran Simanis", TextAlign.center, 30, FontWeight.bold),
          ),
          customText(
              context,
              themeProvider.fontColor1,
              "Dinas Perindustrian Prov. NTB",
              TextAlign.center,
              17,
              FontWeight.normal),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: customText(context, themeProvider.fontColor1, "NIK",
                TextAlign.left, 17, FontWeight.normal),
          ),
          inputFormStyle4(null, "Nomor Induk Kependudukan", "text", "NIK",
              "NIK Tidak Boleh Kosong", false, _nikController, false, () {}),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: customText(context, themeProvider.fontColor1, "Nama",
                TextAlign.left, 17, FontWeight.normal),
          ),
          inputFormStyle4(
              null,
              "Nama Anda",
              "text",
              "Nama",
              "Nama Tidak Boleh Kosong",
              false,
              _namaPemilikController,
              false,
              () {}),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: customText(context, themeProvider.fontColor1, "No HP",
                TextAlign.left, 17, FontWeight.normal),
          ),
          inputFormStyle4(
              null,
              "No HP Anda",
              "text",
              "No HP",
              "No HP Tidak Boleh Kosong",
              false,
              _passwordController,
              false,
              () {}),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: customText(context, themeProvider.fontColor1, "Password",
                TextAlign.left, 17, FontWeight.normal),
          ),
          inputFormStyle3(
              Icons.remove_red_eye,
              "Tulis Password Baru",
              "text",
              "Password",
              "No HP Tidak Boleh Kosong",
              false,
              _nomorTelponController,
              _obscPass, () {
            setState(() {
              _obscPass = !_obscPass;
            });
          }),
          Padding(padding: const EdgeInsets.only(bottom: 26)),
          _errMsg != ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          _errMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _colorMsg),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Mutation(
            options: MutationOptions(
              document: gql(registerMutation(
                  _nikController.text,
                  _passwordController.text,
                  _namaPemilikController.text,
                  _nomorTelponController.text)),

              // or do something with the result.data on completion
              onCompleted: (dynamic resultData) {
                // print(_nikController.text == "");
                if (_nikController.text == "" &&
                    _passwordController.text == "" &&
                    _namaPemilikController.text == "" &&
                    _nomorTelponController.text == "") {
                  setState(() {
                    _errMsg = "Mohon Lengkapi Semua Data";
                  });
                }
                // String msg = resultData['login']['messagges'];

                // if (msg != "success") {
                //   setState(() {
                //     _errMsg = msg;
                //   });
                // } else {
                //   // Map<String, String> data = {
                //   //   "id": resultData['login']['id'],
                //   //   "nama": resultData['login']['nama'],
                //   //   "foto": resultData['login']['foto'],
                //   // };
                //   // functionGroup.saveCache(data);
                //   // Navigator.pushNamed(context, '/homeLayoutPage');
                //   setState(() {
                //     _errMsg = "Pendaftaran Berhasil, Silahkan Login";
                //     _colorMsg = Colors.green;
                //   });
                // }
                FocusManager.instance.primaryFocus?.unfocus();

                // print(data);
              },
              onError: (err) {
                print(err);
              },
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
              return button2(
                  "Register",
                  Colors.blue.shade600,
                  Colors.white,
                  context,
                  () => runMutation({
                        'nik': _nikController.text,
                        'password': _passwordController.text,
                        'nama_direktur': _namaPemilikController.text,
                        'no_hp': _nomorTelponController.text,
                      }));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 45),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Sudah punya akun?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: " Login disini",
                        style: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600),
                      )
                    ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
