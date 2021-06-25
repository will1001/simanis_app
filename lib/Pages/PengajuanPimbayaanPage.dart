import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/Button1.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PengajuanPembiayaanPage extends StatefulWidget {
  const PengajuanPembiayaanPage({Key? key}) : super(key: key);

  @override
  _PengajuanPembiayaanPageState createState() =>
      _PengajuanPembiayaanPageState();
}

class _PengajuanPembiayaanPageState extends State<PengajuanPembiayaanPage> {
  bool _buttonpress = false;
  Color _buttonColor = Color(0xFF0049C6);
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: textLabel(
            "Pengajuan Pembiayaan", 15, Colors.black, "", FontWeight.w400),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textLabel("Tanggal Pengajuan", 12, Colors.black54, "",
                    FontWeight.normal),
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: textLabel(
                      "Status", 12, Colors.black54, "", FontWeight.normal),
                ),
              ],
            ),
          ),
          !_buttonpress
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textLabel("Kamis , 24 Juni 2021", 12, Colors.black, "",
                          FontWeight.w600),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: textLabel("Sedang Diverifikasi", 12,
                            Colors.white, "", FontWeight.w600),
                      ),
                    ],
                  ),
                ),
          button1("Ajukan Pembiayaann",
              !_buttonpress ? _buttonColor : Colors.grey, context, () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                });
            Future.delayed(const Duration(milliseconds: 1500), () async {
              Navigator.pop(context);
              setState(() {
                _buttonpress = true;
              });
            });
          })
        ],
      ),
    );
  }
}
