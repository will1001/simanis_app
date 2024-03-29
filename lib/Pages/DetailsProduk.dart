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
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widget/ListDataIKMWidget.dart';

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
  String _storageUrl = "https://simanis.ntbprov.go.id";

  getCabangIndustri(String id) {
    crud.getData("/cabang_industri/$id").then((res) {
      setState(() {
        _listcabangIndustri.addAll(jsonDecode(res.body));
      });
    });
  }

  nullHandler(var field) {
    return (field == null ? "" : field.toString());
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

  getDetailsProdukQuery() {
    return '''
      query(\$id: String!){
        Produk(id:\$id){
          id
          id_badan_usaha
          nama
          harga
          nama_usaha
          nama_direktur
          no_hp
          alamat_lengkap
          deskripsi
          foto
          sertifikat_halal
          sertifikat_haki
          sertifikat_sni
        }
      }
    ''';
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
      body: Query(
        options: QueryOptions(
            document: gql(getDetailsProdukQuery()),
            variables: {'id': args['id']},
            fetchPolicy: FetchPolicy.networkOnly),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Text("");
          }
          final _dataList = result.data?['Produk'][0];
          return ListView(
            children: [
              Container(
                // color: Colors.amber,
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          args != null
                              ? _dataList['foto'] == null
                                  ? "https://www.btklsby.go.id/images/placeholder/basic.png"
                                  : _storageUrl + _dataList['foto']
                              : "https://www.btklsby.go.id/images/placeholder/basic.png",
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        ColoredBox(
                            color: Colors.black
                                .withOpacity(0.4) // 0: Light, 1: Dark
                            ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: customText(
                      context,
                      Color(0xff242F43),
                      args == null ? "" : nullHandler(_dataList['nama']),
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
                      args == null
                          ? ""
                          : "Rp. " + nullHandler(_dataList['harga']),
                      TextAlign.left,
                      16,
                      FontWeight.w300),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: customText(context, Color(0xff242F43), "Detail Produk",
                      TextAlign.left, 18, FontWeight.w500),
                ),
              ),
              ListDataIKMWidget(context, "Nama Usaha",
                  args == null ? "" : nullHandler(args['nama_usaha'])),
              ListDataIKMWidget(context, "Nama Pemilik",
                  args == null ? "" : nullHandler(args['nama_direktur'])),
              ListDataIKMWidget(context, "no Hp",
                  args == null ? "" : nullHandler(args['no_hp'])),
              ListDataIKMWidget(context, "alamat",
                  args == null ? "" : nullHandler(args['alamat_lengkap'])),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: customText(context, Color(0xff242F43), "Deskripsi",
                      TextAlign.left, 18, FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: customText(
                      context,
                      Color(0xff9CA3AF),
                      args == null ? "" : nullHandler(args['deskripsi']),
                      TextAlign.left,
                      16,
                      FontWeight.w500),
                ),
              ),
              Container(
                height: 50,
              )
            ],
          );
        },
      ),
    );
  }
}
