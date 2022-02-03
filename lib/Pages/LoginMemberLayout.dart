import 'package:appsimanis/Pages/MemberPage.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

class LoginMemberLayout extends StatefulWidget {
  final bool loginCache;
  final Map<String, String> dataUsers;

  const LoginMemberLayout(
      {Key? key, required this.loginCache, required this.dataUsers})
      : super(key: key);

  @override
  _LoginMemberLayoutState createState() => _LoginMemberLayoutState();
}

class _LoginMemberLayoutState extends State<LoginMemberLayout> {
  bool _loginCache = false;
  var _dataUsers = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      _loginCache = widget.loginCache;
    });
  }

  changeStateLoginCache(bool _status) {
    setState(() {
      _loginCache = _status;
    });
  }

  updateDataUsers(var _data) {
    setState(() {
      _dataUsers = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return _loginCache
    //     ? MemberPage(dataUsers: widget.dataUsers)
    //     : Login(changeStateLogin: changeStateLoginCache(true),);
    return Container();
  }
}
