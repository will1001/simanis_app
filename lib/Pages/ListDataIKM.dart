import 'dart:convert';

import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/GradientBg.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/TextLabel.dart';
import 'package:flutter/material.dart';

class ListDataIKM extends StatefulWidget {
  const ListDataIKM({Key? key}) : super(key: key);

  @override
  _ListDataIKMState createState() => _ListDataIKMState();
}

class _ListDataIKMState extends State<ListDataIKM> {
  List _listBadanUsaha = [];
  bool _loading = true;

  var HeadTable = [
    "No",
    "Nama Perusahaan",
    'Nama Pemilik',
    'Alamat',
    'Status Verifikasi',
    'Nomor Telepon',
    // 'male',
    // 'famale',
    // 'nilai_investasi',
    // 'kapasitas_produksi',
  ];

  
  getBadanUsaha() {
    crud.getData("/badan_usaha/limit/10").then((res) {
      // print(jsonDecode(res.body));
      setState(() {
        _listBadanUsaha = jsonDecode(res.body);
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBadanUsaha();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? loadingWidget(context)
        : Scaffold(
            appBar: AppBar(
              leading: Opacity(
                  opacity: 0,
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.ac_unit))),
              title:
                  textLabel("Data IKM", 15, Colors.black, "", FontWeight.w400),
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                gradientBg(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 25,
                      dataRowHeight: 120,
                      columns: HeadTable.map((e) {
                        return DataColumn(
                          label: Text(
                            e,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        );
                      }).toList(),
                      rows: _listBadanUsaha
                          .asMap()
                          .map((i, e) => MapEntry(
                              i,
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text((i + 1).toString())),
                                  DataCell(Text(e["nama_perusahaan"])),
                                  DataCell(Text(e["nama_pemilik"])),
                                  DataCell(Text(e["alamat"])),
                                  DataCell(Text(e["status_verifikasi"])),
                                  DataCell(Text(e["nomor_telpon"])),
                                ],
                              )))
                          .values
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
