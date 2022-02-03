import 'package:flutter/material.dart';

import 'CustomText.dart';

String _storageUrl = "https://simanis.ntbprov.go.id/storage/";

Widget cardUMKM2(BuildContext context, var e) {
  // String? _foto = e['foto_ruang_produksi'];
  // print(_foto == Null ||
  //         _foto == ""
  //     ? 'https://www.btklsby.go.id/images/placeholder/basic.png'
  //     : (_foto == null?"":_storageUrl) + (_foto ??
  //         "https://www.btklsby.go.id/images/placeholder/basic.png"));
  // print(e['foto_ruang_produksi']);
  // print(e['foto_ruang_produksi'].runtimeType);
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, "/detailsUMKM", arguments: e);
    },
    child: Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Color(0xff2BA33A))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  e['foto_ruang_produksi'] == Null ||
                          e['foto_ruang_produksi'] == 'null' ||
                          e['foto_ruang_produksi'] == ""
                      ? 'https://www.btklsby.go.id/images/placeholder/basic.png'
                      : (e['foto_ruang_produksi'] == null ? "" : _storageUrl) +
                          (e['foto_ruang_produksi'] ??
                              "https://www.btklsby.go.id/images/placeholder/basic.png"),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.network(
                      "https://www.btklsby.go.id/images/placeholder/basic.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: customText(
                        context,
                        Color(0xff242F43),
                        e['nama_perusahaan'].toString().length > 30
                            ? e['nama_perusahaan'].toString().substring(0, 30) +
                                ' . . .'
                            : e['nama_perusahaan'] ?? "",
                        TextAlign.left,
                        14,
                        FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: customText(
                        context,
                        Color(0xff727986),
                        e['nama_pemilik'] ?? "",
                        TextAlign.left,
                        12,
                        FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xff727986),
                        size: 17,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: customText(
                            context,
                            Color(0xff727986),
                            e['alamat'].toString().length > 30
                                ? e['alamat'].toString().substring(0, 30) +
                                    ' . . .'
                                : e['alamat'] ?? "",
                            TextAlign.left,
                            12,
                            FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
