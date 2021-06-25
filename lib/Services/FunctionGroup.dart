import 'package:appsimanis/Widget/AlertButton.dart';
import 'package:appsimanis/Widget/AlertDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionGroup {
  saveCache(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email == "" || email == null) {
      await prefs.setString('email', data["email"] ?? "");
      await prefs.setString('nama', data["nama"] ?? "");
    }
  }

  checkLoginCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email')??"";
    if (email == "" || email == null) {
      return false;
    } else {
      return true;
    }
  }
}
