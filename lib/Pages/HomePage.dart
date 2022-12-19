import 'dart:convert';
import 'dart:ffi';

import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/CardProduk3.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../main.dart';

const slideShowQuery = '''
query{
  SlideShow{
    id
    img
  }
}
''';

const surveiQuery = '''
query{
  Survei{
    id
    link
  }
}
''';

String UserDataProgressMutation = r'''
      mutation($user_id: String!){
        UserDataProgress(user_id: $user_id){
          UserDataProgress
        }
      }
    ''';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
  late DateTime currentBackPressTime;
  int _current = 0;
  String _idUser = "";
  String _namaUser = "";
  String _fotoUser = "";
  bool _accessfeature = false;
  CarouselController buttonCarouselController = CarouselController();
  List _slideShowImg = [
    'assets/images/slideshow1.jpg',
    'assets/images/slideshow2.jpg',
    'assets/images/slideshow3.jpg'
  ];
  List _listProduk = [];
  List _listcma = [];
  // List _listBadanUsaha = [];

  List _kategory = [
    {"image": "assets/images/bg1.png", "title": "Alat Bangunan"},
    {"image": "assets/images/bg1.png", "title": "Fashion"},
  ];

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    // ignore: unnecessary_null_comparison
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogBox("", "Keluar dari App ?", [
            AlertButton("Ya", Colors.blue, null, () async {
              SystemNavigator.pop();
            }, context),
            AlertButton("tidak", Colors.blue, null, () {
              Navigator.pop(context);
            }, context),
          ]);
        });
    return Future.value(true);
  }

  getCma() {
    crud.getData("/getcma").then((res) {
      setState(() {
        _listcma = jsonDecode(res.body);
      });
    });
  }

  getProduk(int _limit) {
    crud.getData("/produk/limit/$_limit").then((res) {
      setState(() {
        if (_limit == 10) {
          _listProduk.clear();
          // _loading = true;
        }
        _listProduk.addAll(jsonDecode(res.body));
        // _loading = false;
      });
    });
  }

  // getBadanUsaha(int _limit) {
  //   crud.getData("/badan_usaha/limit/$_limit").then((res) {
  //     setState(() {
  //       _listBadanUsaha = jsonDecode(res.body);
  //       // _listBadanUsahaNotNullFoto = jsonDecode(res.body)
  //       //     .where((el) =>
  //       //         el["foto_alat_produksi"] != null &&
  //       //         el["foto_alat_produksi"] != "")
  //       //     .toList();
  //       // _loading = false;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getLoginCache();
  }

  getLoginCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('idUser');
    String? nama = prefs.getString('namaUser');
    String? foto = prefs.getString('fotoUser');

    setState(() {
      _idUser = id!;
      _namaUser = nama!;
      _fotoUser = foto!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List _kategory = [
      {"image": "assets/images/bg1.png", "title": "Alat Bangunan"},
      {"image": "assets/images/bg1.png", "title": "Fashion"},
    ];
    List _listMenu = [
      {
        'title': 'Simanis Website',
        'icon': 'assets/images/website.svg',
        '_ontap': () async {
          String url = "https://simanis.ntbprov.go.id";
          if (await canLaunch(url)) {
            await launch(url);
            return;
          }
          print("couldn't launch $url");
        }
      },
      {
        'title': 'Kontak CS',
        'icon': 'assets/images/cs_icon.svg',
        '_ontap': () async {
          String url = "https://api.whatsapp.com/send?phone=6287728937983";
          if (await canLaunch(url)) {
            await launch(url);
            return;
          }
          print("couldn't launch $url");
        }
      },
      {
        'title': 'Survei',
        'icon': 'assets/images/survei.svg',
        '_ontap': () async {
          String url = _listcma.length == 0
              ? "https://docs.google.com/forms/d/e/1FAIpQLSdampdX0BstgbXIrfSj89fqN-q2TFjt0rmkifEm2n5aTQ3tfQ/alreadyresponded?embedded=true"
              : _listcma[0]['survei_url'];
          if (await canLaunch(url)) {
            await launch(url);
            return;
          }
          print("couldn't launch $url");
        }
      },
      {
        'title': 'Statistik',
        'icon': 'assets/images/pie_chart.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{"selectedIndex": 2});
        }
      },
      {
        'title': 'Pangan',
        'icon': 'assets/images/fast-food.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "1",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Hulu Agro',
        'icon': 'assets/images/hulu_agro.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "2",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Permesinan',
        'icon': 'assets/images/permesinan.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "3",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Pertambangan',
        'icon': 'assets/images/pertambangan.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "4",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Ekonomi Kreatif',
        'icon': 'assets/images/ekonomi_kreatif.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "6",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Kesehatan',
        'icon': 'assets/images/kesehatan.svg',
        '_ontap': () {
          Navigator.pushNamed(context, '/homeLayoutPage',
              arguments: <String, dynamic>{
                "selectedIndex": 1,
                "kategori": "5",
                "aksesLink": "home"
              });
        }
      },
      {
        'title': 'Share',
        'icon': 'assets/images/share.svg',
        '_ontap': () async {
          Share.share(
              "https://play.google.com/store/apps/details?id=com.disperin.Simanis");
        }
      },
    ];

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Lengkapi Data Untuk Mengakses Fitur Ini'),
                  // Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tutup'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Lengkapi Data'),
                onPressed: () {
                  Navigator.pushNamed(context, '/detailUsaha');
                },
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Logo_blue.svg",
                      width: 32,
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      child: SvgPicture.asset(
                        "assets/images/cross.svg",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://simanis.ntbprov.go.id' + _fotoUser),
                        ),
                        customText(context, Colors.black, _namaUser,
                            TextAlign.left, 24, FontWeight.bold),
                        customText(context, Colors.black38, "Akun Member IKM",
                            TextAlign.left, 18, FontWeight.normal),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/detailUsaha');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: customText(context, Colors.black, "Detail Usaha",
                      TextAlign.left, 18, FontWeight.normal),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/pengaturanAkun');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: customText(context, Colors.black, "Update Password",
                      TextAlign.left, 18, FontWeight.normal),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: customText(context, Colors.black, "Update Password",
              //       TextAlign.left, 18, FontWeight.normal),
              // ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(UserDataProgressMutation),
                  onCompleted: (dynamic resultData) {
                    var userDataProgress =
                        resultData['UserDataProgress']['UserDataProgress'];
                    if (double.parse(userDataProgress) >= 100) {
                      Navigator.pushNamed(context, '/kartu');
                    } else {
                      _showMyDialog();
                    }
                  },
                  onError: (err) {
                    print(err);
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return GestureDetector(
                    onTap: () {
                      runMutation(<String, dynamic>{
                        'user_id': _idUser,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: customText(context, Colors.black, "Kartu",
                          TextAlign.left, 18, FontWeight.normal),
                    ),
                  );
                },
              ),

              Mutation(
                options: MutationOptions(
                  document: gql(UserDataProgressMutation),
                  onCompleted: (dynamic resultData) {
                    var userDataProgress =
                        resultData['UserDataProgress']['UserDataProgress'];
                    if (double.parse(userDataProgress) >= 100) {
                      Navigator.pushNamed(context, '/pengajuanDana');
                    } else {
                      _showMyDialog();
                    }
                  },
                  onError: (err) {
                    print(err);
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return GestureDetector(
                    onTap: () {
                      runMutation(<String, dynamic>{
                        'user_id': _idUser,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: customText(
                          context,
                          Colors.black,
                          "Pembiayan Usaha",
                          TextAlign.left,
                          18,
                          FontWeight.normal),
                    ),
                  );
                },
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(UserDataProgressMutation),
                  onCompleted: (dynamic resultData) {
                    var userDataProgress =
                        resultData['UserDataProgress']['UserDataProgress'];
                    if (double.parse(userDataProgress) >= 100) {
                      Navigator.pushNamed(context, '/pengajuanProduk');
                    } else {
                      _showMyDialog();
                    }
                  },
                  onError: (err) {
                    print(err);
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return GestureDetector(
                    onTap: () {
                      runMutation(<String, dynamic>{
                        'user_id': _idUser,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: customText(
                          context,
                          Colors.black,
                          "Pengajuan Produk",
                          TextAlign.left,
                          18,
                          FontWeight.normal),
                    ),
                  );
                },
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/Surat');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: customText(context, Colors.black, "Surat Rekomendasi",
                      TextAlign.left, 18, FontWeight.normal),
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: customText(context, Colors.black, "Kontak Kami",
                    TextAlign.left, 18, FontWeight.normal),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: customText(context, Colors.black, "Syarat & Ketentuan",
                    TextAlign.left, 18, FontWeight.normal),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: customText(context, Colors.red, "Logout",
                      TextAlign.left, 18, FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://simanis.ntbprov.go.id' +
                                        _fotoUser),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(context, Colors.black, _namaUser,
                                    TextAlign.left, 18, FontWeight.normal),
                                customText(
                                    context,
                                    Colors.black38,
                                    "Akun Member IKM",
                                    TextAlign.left,
                                    12,
                                    FontWeight.normal),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notificationList');
                        },
                        child: Image.network(
                          "https://freeiconshop.com/wp-content/uploads/edd/notification-outline.png",
                          height: 25,
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Query(
                            options:
                                QueryOptions(document: gql(slideShowQuery)),
                            builder: (QueryResult result,
                                {fetchMore, refetch}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }
                              if (result.isLoading) {
                                return Text("");
                              }
                              final _slideShowList = result.data?['SlideShow'];
                              return CarouselSlider(
                                carouselController: buttonCarouselController,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  aspectRatio: 1 / 1,
                                  viewportFraction: 1,
                                  height: 286.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                items: _slideShowList.map<Widget>((e) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              'https://simanis.ntbprov.go.id' +
                                                  e['img'],
                                              fit: BoxFit.fill,
                                            ),
                                            ColoredBox(
                                                color: Colors.black.withOpacity(
                                                    0.25) // 0: Light, 1: Dark
                                                ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _slideShowImg.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () =>
                          buttonCarouselController.animateToPage(entry.key),
                      child: Container(
                        width: _current == entry.key ? 20 : 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: _current == entry.key
                                ? BorderRadius.circular(10)
                                : null,
                            shape: _current == entry.key
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            color: _current == entry.key
                                ? Colors.blue.shade600
                                : Color(0xffE5E7EB)),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      customText(
                          context,
                          Color(0xff242F43),
                          "Kategori Produk IKM",
                          TextAlign.center,
                          16,
                          FontWeight.w600),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1 / 0.9,
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      primary: true,
                      children: _listMenu.map((e) {
                        if (e['title'] == 'Survei') {
                          return Query(
                            options: QueryOptions(document: gql(surveiQuery)),
                            builder: (QueryResult result,
                                {fetchMore, refetch}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }
                              if (result.isLoading) {
                                return Text("");
                              }
                              final _surveiList = result.data?['Survei'];
                              return GestureDetector(
                                onTap: () async {
                                  String url = _surveiList[0]['link'];
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                    return;
                                  }
                                  print("couldn't launch $url");
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      e['icon'],
                                      width: 32,
                                      height: 32,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: customText(
                                          context,
                                          Color(0xff242F43),
                                          e['title'],
                                          TextAlign.center,
                                          12,
                                          FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return GestureDetector(
                            onTap: e['_ontap'],
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  e['icon'],
                                  width: 32,
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: customText(
                                      context,
                                      Color(0xff242F43),
                                      e['title'],
                                      TextAlign.center,
                                      12,
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xffECF6FF),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 39, horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: customText(
                              context,
                              Colors.black,
                              "Layanan Simanis",
                              TextAlign.left,
                              16,
                              FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Mutation(
                              options: MutationOptions(
                                document: gql(UserDataProgressMutation),
                                onCompleted: (dynamic resultData) {
                                  var userDataProgress =
                                      resultData['UserDataProgress']
                                          ['UserDataProgress'];
                                  print(double.parse(userDataProgress) >= 100);

                                  if (double.parse(userDataProgress) >= 100) {
                                    Navigator.pushNamed(
                                        context, '/pengajuanDana');
                                  } else {
                                    _showMyDialog();
                                  }
                                },
                                onError: (err) {
                                  print(err);
                                },
                              ),
                              builder: (RunMutation runMutation,
                                  QueryResult? result) {
                                return GestureDetector(
                                  onTap: () {
                                    print("object");
                                    runMutation(<String, dynamic>{
                                      'user_id': _idUser,
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: SvgPicture.asset(
                                            "assets/images/AjukanDana.svg",
                                            width: 32,
                                            height: 32,
                                          ),
                                        ),
                                        customText(
                                            context,
                                            Colors.white,
                                            "Ajukan Dana",
                                            TextAlign.left,
                                            16,
                                            FontWeight.normal),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url =
                                    ("https://api.whatsapp.com/send?phone=6287728937983");
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  return;
                                }
                                print("couldn't launch $url");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF59E0B),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: SvgPicture.asset(
                                        "assets/images/HubungiKami.svg",
                                        width: 32,
                                        height: 32,
                                      ),
                                    ),
                                    customText(
                                        context,
                                        Colors.white,
                                        "Hubungi Kami",
                                        TextAlign.left,
                                        16,
                                        FontWeight.normal),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
