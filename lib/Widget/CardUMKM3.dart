import 'package:flutter/material.dart';

import 'CustomText.dart';

String _storageUrl = "https://simanis.ntbprov.go.id/storage/";

Widget cardUMKM3(BuildContext context, var e) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, "/detailsUMKM", arguments: e);
    },
    child: Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    e['foto_ruang_produksi'] == Null ||
                            e['foto_ruang_produksi'] == 'null' ||
                            e['foto_ruang_produksi'] == ""
                        ? 'https://www.btklsby.go.id/images/placeholder/basic.png'
                        : (e['foto_ruang_produksi'] == null
                                ? ""
                                : _storageUrl) +
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: customText(
                        context,
                        Colors.black,
                        e['nama_usaha'].toString().length > 30
                            ? e['nama_usaha'].toString().substring(0, 30) +
                                ' . . .'
                            : e['nama_usaha'] ?? "",
                        TextAlign.left,
                        17,
                        FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: customText(
                        context,
                        Colors.blue,
                        e['nama_direktur'] ?? "",
                        TextAlign.left,
                        14,
                        FontWeight.w500),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 4),
                  //   child: Container(
                  //     width: 200,
                  //     child: customText(
                  //         context,
                  //         Color(0xff727986),
                  //         e['jenis_usaha'] ?? "",
                  //         TextAlign.left,
                  //         12,
                  //         FontWeight.w500),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff727986),
                          size: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 180,
                          child: customText(
                              context,
                              Color(0xff727986),
                              e['alamat_lengkap'].toString().length > 30
                                  ? e['alamat_lengkap']
                                          .toString()
                                          .substring(0, 30) +
                                      ' . . .'
                                  : e['alamat_lengkap'] ?? "",
                              TextAlign.left,
                              14,
                              FontWeight.w400),
                        )
                      ],
                    ),
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
