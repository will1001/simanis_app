import 'package:appsimanis/Pages/AddProduk.dart';
import 'package:appsimanis/Pages/Daftar.dart';
import 'package:appsimanis/Pages/DataTambahan.dart';
import 'package:appsimanis/Pages/DetailUsaha.dart';
import 'package:appsimanis/Pages/DetailsDataUMKM.dart';
import 'package:appsimanis/Pages/DetailsProduk.dart';
import 'package:appsimanis/Pages/DetailsStatistik.dart';
import 'package:appsimanis/Pages/FormPengajuanDana.dart';
import 'package:appsimanis/Pages/FormPengajuanProduk.dart';
import 'package:appsimanis/Pages/HomeLayoutPage.dart';
import 'package:appsimanis/Pages/HomePage.dart';
import 'package:appsimanis/Pages/InformasiIKM.dart';
import 'package:appsimanis/Pages/LinkPerbankan.dart';
import 'package:appsimanis/Pages/ListDataIKM.dart';
import 'package:appsimanis/Pages/ListDataProduk.dart';
import 'package:appsimanis/Pages/Login.dart';
import 'package:appsimanis/Pages/MemberPage.dart';
import 'package:appsimanis/Pages/PengajuanDana.dart';
import 'package:appsimanis/Pages/PengajuanProduk.dart';
import 'package:appsimanis/Pages/ProdukPage.dart';
import 'package:appsimanis/Pages/ProdukPageMember.dart';
import 'package:appsimanis/Pages/ProfilPage.dart';
import 'package:appsimanis/Pages/SplashScreen.dart';
import 'package:appsimanis/Pages/StatistikPage.dart';
import 'package:appsimanis/Pages/Surat.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'Pages/Kartu.dart';
import 'Pages/NotificationList.dart';
import 'Pages/PengajuanPimbayaanPage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'Pages/PengaturanAkun.dart';

final graphqlEndpoint = 'https://simanis.ntbprov.go.id/graphql';
final HttpLink httpLink = HttpLink(graphqlEndpoint);

ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore())));

void main() {
  var app = GraphQLProvider(client: client, child: MyApp());
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        color: Colors.blue.shade700,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splashScreen',
        routes: <String, WidgetBuilder>{
          '/splashScreen': (BuildContext context) => SplashScreen(),
          '/login': (BuildContext context) => Login(),
          // '/detailsStatistik': (BuildContext context) => DetailsStatistik(),
          '/daftar': (BuildContext context) => Daftar(),
          '/memberPage': (BuildContext context) => MemberPage(
                dataUsers: {},
              ),
          '/profilPage': (BuildContext context) => ProfilPage(),
          '/informasiIKM': (BuildContext context) => InformasiIKM(),
          '/produkPage': (BuildContext context) => ProdukPage(
                kategoriID: 'null',
                aksesLink: 'home2',
                loginCache: 3,
              ),
          '/produkPageMember': (BuildContext context) => ProdukPageMember(),
          '/pengajuanPembiayaanPage': (BuildContext context) =>
              PengajuanPembiayaanPage(),
          '/homePage': (BuildContext context) => HomePage(),
          '/ListDataIKM': (BuildContext context) => ListDataIKM(
                kategoriID: "",
              ),
          '/ListDataProduk': (BuildContext context) => ListDataProduk(),
          '/homeLayoutPage': (BuildContext context) => HomeLayoutPage(),
          '/statistikPage': (BuildContext context) => StatistikPage(),
          '/detailsUMKM': (BuildContext context) => DetailsDataUMKM(),
          '/detailsProduk': (BuildContext context) => DetailsProduk(),
          '/AddProduk': (BuildContext context) => AddProduk(),
          '/linkBank': (BuildContext context) => LinkPerbankan(),
          '/notificationList': (BuildContext context) => NotificationList(),
          '/detailUsaha': (BuildContext context) => DetailUsaha(),
          '/pengaturanAkun': (BuildContext context) => PengaturanAkun(),
          '/kartu': (BuildContext context) => Kartu(),
          '/Surat': (BuildContext context) => Surat(),
          '/pengajuanDana': (BuildContext context) => PengajuanDana(),
          '/formPengajuanDana': (BuildContext context) => FormPengajuanDana(),
          '/dataTambahan': (BuildContext context) => DataTambahan(),
          '/pengajuanProduk': (BuildContext context) => PengajuanProduk(),
          '/formPengajuanProduk': (BuildContext context) =>
              FormPengajuanProduk(),
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   void getHttp() async {
//     try {
//       var response =
//           // await Dio().get('http://www.json-generator.com/api/json/get/cfimCTPASW?indent=2');
//           await Dio().get('http://www.json-generator.com/api/json/get/cptewFsSWa?indent=2');
//       print(response);
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: ,

//     );
//   }
// }
