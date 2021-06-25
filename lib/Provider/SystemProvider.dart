import 'package:flutter/material.dart';

class SystemProvider extends ChangeNotifier {
String idUser = "";

  void changeIdUser(String id) {
    idUser = id;
    notifyListeners();
  }
}
