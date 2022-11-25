import 'package:appsimanis/Pages/HomePageWebView.dart';
import 'package:appsimanis/Pages/ListDataIKM.dart';
import 'package:appsimanis/Pages/ListDataIKMHomeMenu.dart';
import 'package:appsimanis/Pages/Login.dart';
import 'package:appsimanis/Pages/LoginMemberLayout.dart';
import 'package:appsimanis/Pages/MemberPage.dart';
import 'package:appsimanis/Pages/ProdukPage.dart';
import 'package:appsimanis/Pages/StatistikPage.dart';
import 'package:appsimanis/Provider/SystemProvider.dart';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Services/FunctionGroup.dart';
import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

class HomeLayoutPage extends StatefulWidget {
  const HomeLayoutPage({Key? key}) : super(key: key);

  @override
  _HomeLayoutPageState createState() => _HomeLayoutPageState();
}

class _HomeLayoutPageState extends State<HomeLayoutPage> {
  late DateTime currentBackPressTime;
  int _selectedIndex = 0;
  FunctionGroup functionGroup = new FunctionGroup();
  // bool _loginCache = true;
  bool _loop = true;
  SystemProvider? systemProvider;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // print(index);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
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

  // changeStateLoginCache(bool _status) {
  //   setState(() {
  //     _loginCache = _status;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // functionGroup.checkLoginCache().then((loginStatus) {
    //   changeStateLoginCache(loginStatus);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && _loop) {
      setState(() {
        _selectedIndex = (args as Map)["selectedIndex"];
        _loop = false;
      });
    }
    //  print('args123');
    // print(args == null ? 'null' : (args as Map)["kategori"] ?? 'null');
    List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      HomePage(),
      StatistikPage(),
      StatistikPage(),
      // ListDataIKMHomeMenu(),
      // ListDataIKM(
      //   loginCache: _selectedIndex,
      // ),
      // HomePage(),
      // StatistikPage(
      //   loginCache: _selectedIndex,
      // ),
      // ProdukPage(
      //   loginCache: _selectedIndex,
      //   kategoriID: args == null ? 'null' : (args as Map)["kategori"] ?? 'null',
      //   aksesLink:
      //       args == null ? 'home2' : (args as Map)["aksesLink"] ?? 'home2',
      // ),
      // _loginCache
      //     ? MemberPage(
      //         dataUsers: args == null ? {} : (args as Map)["dataUsers"] ?? {},
      //       )
      //     : Login()
      // LoginMemberLayout(
      //   loginCache: _loginCache,
      //   dataUsers: args == null ? {} : (args as Map)["dataUsers"] ?? {},
      // )
    ];
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          // body: IndexedStack(
          //   index: _selectedIndex,
          //   children: _widgetOptions,
          // ),
          body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: Colors.blue.shade700),
            unselectedItemColor: Color(0xffB2B5BC),
            selectedItemColor: Colors.blue.shade700,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.domain),
                label: 'Data',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Produk',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.assessment),
              //   label: 'Statistik',
              // ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.person),
              //   label: 'Profil',
              // ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          )),
    );
  }
}
