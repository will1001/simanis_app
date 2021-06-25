import 'package:appsimanis/Pages/ListDataIKM.dart';
import 'package:appsimanis/Pages/Login.dart';
import 'package:appsimanis/Pages/MemberPage.dart';
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
  bool _loginCache = false;
  bool _loop = true;
  SystemProvider? systemProvider;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  void initState() {
    super.initState();

    functionGroup.checkLoginCache().then((loginStatus) {
      setState(() {
        _loginCache = loginStatus;
      });
    });
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
    List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      ListDataIKM(),
      StatistikPage(),
      _loginCache ? MemberPage() : Login()
    ];
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            // child: Center(child: _widgetOptions.elementAt(_selectedIndex))),
            children: _widgetOptions,),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.domain),
                label: 'List Data IKM',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: themeProvider.fontColor1,
            onTap: _onItemTapped,
          )),
    );
  }
}
