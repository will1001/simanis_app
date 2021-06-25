import 'package:appsimanis/Pages/Daftar.dart';
import 'package:appsimanis/Pages/HomeLayoutPage.dart';
import 'package:appsimanis/Pages/HomePage.dart';
import 'package:appsimanis/Pages/InformasiIKM.dart';
import 'package:appsimanis/Pages/ListDataIKM.dart';
import 'package:appsimanis/Pages/Login.dart';
import 'package:appsimanis/Pages/MemberPage.dart';
import 'package:appsimanis/Pages/ProdukPage.dart';
import 'package:appsimanis/Pages/ProfilPage.dart';
import 'package:appsimanis/Pages/SplashScreen.dart';
import 'package:appsimanis/Pages/StatistikPage.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'Pages/PengajuanPimbayaanPage.dart';

void main() {
  runApp(MyApp());
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
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splashScreen',
        routes: <String, WidgetBuilder>{
          '/splashScreen': (BuildContext context) => SplashScreen(),
          '/login': (BuildContext context) => Login(),
          '/daftar': (BuildContext context) => Daftar(),
          '/memberPage': (BuildContext context) => MemberPage(),
          '/profilPage': (BuildContext context) => ProfilPage(),
          '/informasiIKM': (BuildContext context) => InformasiIKM(),
          '/produkPage': (BuildContext context) => ProdukPage(),
          '/pengajuanPembiayaanPage': (BuildContext context) =>
              PengajuanPembiayaanPage(),
          '/homePage': (BuildContext context) => HomePage(),
          '/LisaDataIKM': (BuildContext context) => ListDataIKM(),
          '/homeLayoutPage': (BuildContext context) => HomeLayoutPage(),
          '/statistikPage': (BuildContext context) => StatistikPage(),
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
