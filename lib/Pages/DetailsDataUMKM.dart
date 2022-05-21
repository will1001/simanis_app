import 'dart:async';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/FilterButton.dart';
import 'package:appsimanis/Widget/ListLabel2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsDataUMKM extends StatefulWidget {
  const DetailsDataUMKM({Key? key}) : super(key: key);

  @override
  _DetailsDataUMKMState createState() => _DetailsDataUMKMState();
}

class _DetailsDataUMKMState extends State<DetailsDataUMKM> {
  var args;
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  int _subMenu = 0;
  List<Marker> allMarkers = [];
  var _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  // var _kGooglePlex;
  String _foto = "Alat";
  List _slideFoto = [];

  // initialMap()async{
  //   CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  // }

  convertIdCabangIndustri(String? _idCabangIndustri) {
    String result = "";
    switch (_idCabangIndustri) {
      case "006c4210-7806-11eb-9b1b-81d2fad81425":
        result = "Pangan";
        break;
      case "006d2610-7806-11eb-ab4c-a1abd6abcd37":
        result = "Hulu Agro";
        break;
      case "006d8f20-7806-11eb-9444-bd238317ed47":
        result = "Permesinan, Alat Transportasi & Energi Terbarukan";
        break;
      case "006e3bd0-7806-11eb-a766-e1c38c7e931e":
        result = "Hasil Pertambangan";
        break;
      case "006f3b70-7806-11eb-ae50-d1725dc37289":
        result = "Ekonomi Kreatif";
        break;
      case "006eb850-7806-11eb-87a5-6fa3dfe46649":
        result = "Kimia , Farmasi, Kosmetik & Kesehatan";
        break;
      default:
        result = "";
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      // print(arguments);
      setState(() {
        args = arguments;
        arguments == null
            ? _slideFoto = [
                'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png',
                'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
              ]
            : _slideFoto = [
                arguments['foto_ruang_produksi'] == null
                    ? 'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
                    : _storageUrl + arguments['foto_alat_produksi'],
                arguments['foto_alat_produksi'] == null
                    ? 'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
                    : _storageUrl + arguments['foto_ruang_produksi']
              ];
      });
      if (arguments["lat"] != null && arguments["lng"] != null) {
        setState(() {
          _kGooglePlex = CameraPosition(
            target: LatLng(
                double.parse(arguments["lat"].toString()), double.parse(arguments["lng"].toString())),
            zoom: 14.4746,
          );
        });
      }
    });
    // initialMap();
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    // print('_slideFoto');
    // print(_slideFoto);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      aspectRatio: 1 / 1,
                      viewportFraction: 1,
                      height: 200.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: _slideFoto
                        .asMap()
                        .map((i, e) => MapEntry(i, Builder(
                              builder: (BuildContext context) {
                                return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          e,
                                          fit: BoxFit.fill,
                                        ),
                                        ColoredBox(
                                            color: Colors.black.withOpacity(
                                                0.25) // 0: Light, 1: Dark
                                            ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Opacity(
                                            opacity: 0.4,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                color: Color(0xffE4E5E7),
                                              ),
                                              child: Opacity(
                                                opacity: 0,
                                                child: customText(
                                                    context,
                                                    Color(0xffFDFDFD),
                                                    i == 0
                                                        ? 'Ruang Produksi'
                                                        : 'Alat Poduksi',
                                                    TextAlign.left,
                                                    12,
                                                    FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                          customText(
                                              context,
                                              Color(0xffFDFDFD),
                                              i == 0
                                                  ? 'Ruang Produksi'
                                                  : 'Alat Poduksi',
                                              TextAlign.left,
                                              12,
                                              FontWeight.w400)
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            )))
                        .values
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _slideFoto.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            buttonCarouselController.animateToPage(entry.key),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key
                                  ? Color(0xffFAFBFB)
                                  : Color(0xff848A95)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff848A95), shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: customText(
                  context,
                  Color(0xff242F43),
                  args == null ? "" : args['nama_perusahaan'],
                  TextAlign.left,
                  20,
                  FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: customText(
                  context,
                  Color(0xff545C6C),
                  args == null ? "" : args['nama_pemilik'],
                  TextAlign.left,
                  14,
                  FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Deskripsi', 'Lokasi']
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _subMenu = i;
                              if (i == 1) {
                                _kGooglePlex = CameraPosition(
                                  target: LatLng(
                                      args != null
                                          ? double.parse(args['lat'].toString())
                                          : 37.42796133580664,
                                      args != null
                                          ? double.parse(args['lng'].toString())
                                          : -122.085749655962),
                                  zoom: 14.4746,
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 4),
                            width: MediaQuery.of(context).size.width * 0.5 - 32,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 4,
                                        color: _subMenu == i
                                            ? Color(0xff2BA33A)
                                            : Colors.transparent))),
                            child: Center(
                              child: customText(
                                  context,
                                  _subMenu == i
                                      ? Color(0xff2BA33A)
                                      : Color(0xffB2B5BC),
                                  e,
                                  TextAlign.left,
                                  14,
                                  FontWeight.w500),
                            ),
                          ),
                        )))
                    .values
                    .toList()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: _subMenu == 0
                  ? ListView(
                      children: [
                        listLabel2(context,
                            "Bentuk Badan Usaha : ${args == null ? "" : args['bentuk_badan_usaha']}"),
                        listLabel2(context,
                            "Tahun Berdiri Badan Usaha : ${args == null ? "" : args['tahun_badan_usaha']}"),
                        listLabel2(context,
                            "Kapasitas Produksi : ${args == null ? "" : args['kapasitas_produksi']}"),
                        listLabel2(context,
                            "Satuan Produksi : ${args == null ? "" : args['satuan_produksi']}"),
                        listLabel2(context,
                            "Nilai Investasi : ${args == null ? "" : args['nilai_produksi']}"),
                        listLabel2(context,
                            "Nilai Bahan Baku / Bahan Penolong : ${args == null ? "" : args['nilai_bb_bp']}"),
                        listLabel2(context,
                            "Alamat : ${args == null ? "" : args['alamat']}"),
                      ],
                    )
                  : GestureDetector(
                      onTap: () async {
                        String url =
                            "http://maps.google.com/maps?q=${args == null ? "" : args['lat']},${args == null ? "" : args['lng']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                          return;
                        }
                        print("couldn't launch $url");
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GoogleMap(
                            markers: Set.from(allMarkers),
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                          Container(
                            color: Colors.transparent,
                          )
                        ],
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: button2(
                "Hubungi UMKM", Color(0xff2BA33A), Colors.white, context,
                () async {
              String url =
                  "https://api.whatsapp.com/send?phone=62${args == null ? "" : args['nomor_telpon'].toString().substring(1, args == null ? "" : args['nomor_telpon'].length)}";
              if (await canLaunch(url)) {
                await launch(url);
                return;
              }
              print("couldn't launch $url");
            }),
          )
        ],
      ),
    );
  }
}
