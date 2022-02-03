import 'dart:async';
import 'dart:convert';

import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button2.dart';
import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsProduk extends StatefulWidget {
  const DetailsProduk({Key? key}) : super(key: key);

  @override
  _DetailsProdukState createState() => _DetailsProdukState();
}

class _DetailsProdukState extends State<DetailsProduk> {
  var args;
  List<Marker> allMarkers = [];
  List _listcabangIndustri = [];
  Completer<GoogleMapController> _controller = Completer();
  var _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";

  getCabangIndustri(String id) {
    crud.getData("/cabang_industri/$id").then((res) {
      setState(() {
        _listcabangIndustri.addAll(jsonDecode(res.body));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      setState(() {
        args = arguments;
      });
      if (arguments["lat"] != null && arguments["lng"] != null) {
        setState(() {
          _kGooglePlex = CameraPosition(
            target: LatLng(
                double.parse(arguments["lat"]), double.parse(arguments["lng"])),
            zoom: 14.4746,
          );
        });
      }
      getCabangIndustri(arguments["id_cabang_industri"]);
    });
  }

  dateFormat(String date) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String formatted = formatter.format(DateTime.parse(date));
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    // print(args);
    // print('args');
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      body: ListView(
        children: [
          Container(
            // color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      args != null
                          ? args['foto'] == null
                              ? ""
                              : _storageUrl + args['foto']
                          : "https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ),
                    ColoredBox(
                        color:
                            Colors.black.withOpacity(0.4) // 0: Light, 1: Dark
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 132,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                          context,
                          Color(0xff242F43),
                          args == null ? "" : args['nama'],
                          TextAlign.left,
                          20,
                          FontWeight.w500),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: customText(
                            context,
                            Color(0xff545C6C),
                            args == null ? "" : args['nama_perusahaan'],
                            TextAlign.left,
                            14,
                            FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/detailsUMKM",
                        arguments: args);
                  },
                  child: Container(
                    width: 100,
                    child: customText(context, Color(0xff2BA33A),
                        'Profil Usaha', TextAlign.left, 14, FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24),
            child: customText(context, Color(0xff000000), 'Deskripsi',
                TextAlign.left, 14, FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: customText(
                context,
                Color(0xff727986),
                args == null ? "" : args['deskripsi'],
                TextAlign.left,
                14,
                FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(context, Color(0xff000000), 'Produk', TextAlign.left,
                    14, FontWeight.w500),
                customText(context, Color(0xff2BA33A), 'Lihat Lainnya',
                    TextAlign.left, 12, FontWeight.w400)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                args == null ? "" : args['foto'] ?? "",
                args == null ? "" : args['foto'] ?? "",
                args == null ? "" : args['foto'] ?? ""
              ]
                  .map((e) => Container(
                        padding: const EdgeInsets.only(right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          child: Image.network(
                            _storageUrl + e,
                            fit: BoxFit.fill,
                            width: 120,
                            height: 80,
                          ),
                        ),
                      ))
                  .toList(),
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
