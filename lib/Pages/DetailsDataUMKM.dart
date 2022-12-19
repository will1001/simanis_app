import 'dart:async';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/FilterButton.dart';
import 'package:appsimanis/Widget/ListDataIKMWidget.dart';
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
  String _storageUrl = "https://simanis.ntbprov.go.id";
  // var _kGooglePlex;
  String _foto = "Alat";
  List _slideFoto = [];

  initialMap() async {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
  }

  nullHandler(var field) {
    return (field == null ? "" : field.toString());
  }

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
      setState(() {
        args = arguments;
        arguments == null
            ? _slideFoto = [
                'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png',
                'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
              ]
            : _slideFoto = [
                arguments['produk'] == null
                    ? 'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
                    : _storageUrl + arguments['produk'],
                arguments['produk'] == null
                    ? 'https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png'
                    : _storageUrl + arguments['produk']
              ];
      });
      if (arguments["lat"] != null && arguments["lng"] != null) {
        setState(() {
          _kGooglePlex = CameraPosition(
            target: LatLng(double.parse(arguments["lat"].toString()),
                double.parse(arguments["lng"].toString())),
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
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              aspectRatio: 1 / 1,
              viewportFraction: 1,
              height: 300.0,
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
                                    color: Colors.black
                                        .withOpacity(0.25) // 0: Light, 1: Dark
                                    ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 24.0),
                            //   child: Stack(
                            //     alignment: Alignment.center,
                            //     children: [
                            //       Opacity(
                            //         opacity: 0.4,
                            //         child: Container(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 8, vertical: 4),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             color: Color(0xffE4E5E7),
                            //           ),
                            //           child: Opacity(
                            //             opacity: 0,
                            //             child: customText(
                            //                 context,
                            //                 Color(0xffFDFDFD),
                            //                 i == 0
                            //                     ? 'Ruang Produksi'
                            //                     : 'Alat Poduksi',
                            //                 TextAlign.left,
                            //                 12,
                            //                 FontWeight.w400),
                            //           ),
                            //         ),
                            //       ),
                            //       customText(
                            //           context,
                            //           Color(0xffFDFDFD),
                            //           i == 0
                            //               ? 'Ruang Produksi'
                            //               : 'Alat Poduksi',
                            //           TextAlign.left,
                            //           12,
                            //           FontWeight.w400)
                            //     ],
                            //   ),
                            // )
                          ],
                        );
                      },
                    )))
                .values
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: customText(
                  context,
                  Color(0xff242F43),
                  args == null ? "" : nullHandler(args['nama_usaha']),
                  TextAlign.left,
                  24,
                  FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: customText(
                  context,
                  Colors.blue,
                  args == null ? "" : nullHandler(args['nama_direktur']),
                  TextAlign.left,
                  16,
                  FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: customText(context, Color(0xff242F43), "Detail IKM",
                  TextAlign.left, 18, FontWeight.w500),
            ),
          ),
          // ListDataIKMWidget(
          //     context, "NIK", args == null ? "" : nullHandler(args['nik'])),
          ListDataIKMWidget(context, "Nama",
              args == null ? "" : nullHandler(args['nama_direktur'])),
          // ListDataIKMWidget(context, "Kab/Kota",
          //     args == null ? "" : nullHandler(args['kabupaten'])),
          // ListDataIKMWidget(context, "Kecamatan",
          //     args == null ? "" : nullHandler(args['kecamatan'])),
          // ListDataIKMWidget(context, "Kelurahan/Desa",
          //     args == null ? "" : nullHandler(args['kelurahan'])),
          ListDataIKMWidget(context, "Alamat Lengkap",
              args == null ? "" : nullHandler(args['alamat_lengkap'])),
          ListDataIKMWidget(
              context, "No Hp", args == null ? "" : nullHandler(args['no_hp'])),
          ListDataIKMWidget(context, "Nama Usaha",
              args == null ? "" : nullHandler(args['nama_usaha'])),
          // ListDataIKMWidget(context, "Bentuk Usaha",
          //     args == null ? "" : nullHandler(args['bentuk_usaha'])),
          // ListDataIKMWidget(context, "Tahun Berdiri",
          //     args == null ? "" : nullHandler(args['tahun_berdiri'])),
          // ListDataIKMWidget(context, "Legalitas Usaha",
          //     args == null ? "" : nullHandler(args[''])),
          // ListDataIKMWidget(context, "NIB Tahun",
          //     args == null ? "" : nullHandler(args['nib_tahun'])),
          // ListDataIKMWidget(
          //     context,
          //     "No Sertifikat Halal Tahun",
          //     args == null
          //         ? ""
          //         : nullHandler(args['nomor_sertifikat_halal_tahun'])),
          // ListDataIKMWidget(context, "SNI Tahun",
          //     args == null ? "" : nullHandler(args['sni_tahun'])),
          ListDataIKMWidget(context, "Jenis Usaha",
              args == null ? "" : nullHandler(args['jenis_usaha'])),
          // ListDataIKMWidget(context, "Cabang Industri",
          //     args == null ? "" : nullHandler(args['cabang_industri'])),
          // ListDataIKMWidget(context, "Sub Cabang Industri",
          //     args == null ? "" : nullHandler(args['sub_cabang_industri'])),
          // ListDataIKMWidget(context, "ID KBLI",
          //     args == null ? "" : nullHandler(args['id_kbli'])),
          // ListDataIKMWidget(context, "Investasi Modal",
          //     args == null ? "" : nullHandler(args['investasi_modal'])),
          // ListDataIKMWidget(
          //     context,
          //     "Jumlah Tenaga Kerja Pria",
          //     args == null
          //         ? ""
          //         : nullHandler(args['jumlah_tenaga_kerja_pria'])),
          // ListDataIKMWidget(
          //     context,
          //     "Jumlah Tenaga Kerja Wanita",
          //     args == null
          //         ? ""
          //         : nullHandler(args['jumlah_tenaga_kerja_wanita'])),
          // ListDataIKMWidget(
          //     context,
          //     "Kapasitas Produksi ",
          //     args == null
          //         ? ""
          //         : nullHandler(args['kapasitas_produksi_perbulan'])),
          // ListDataIKMWidget(context, "Nilai Produksi",
          //     args == null ? "" : nullHandler(args['nilai_produksi_perbulan'])),
          // ListDataIKMWidget(
          //     context,
          //     "Nilai Bahan Baku",
          //     args == null
          //         ? ""
          //         : nullHandler(args['nilai_bahan_baku_perbulan'])),
          // ListDataIKMWidget(context, "Latitude",
          //     args == null ? "" : nullHandler(args['lat'])),
          // ListDataIKMWidget(context, "Longitude",
          //     args == null ? "" : nullHandler(args['lng'])),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: GestureDetector(
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
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: GoogleMap(
                        markers: Set.from(allMarkers),
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                    )
                  ],
                ),
              ),
            ),
          ),
          ListDataIKMWidget(context, "Media Sosial",
              args == null ? "" : nullHandler(args['media_sosial'])),
          Container(
            height: 100,
          )
        ],
      ),
    );
  }
}
