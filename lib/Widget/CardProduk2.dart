import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget cardProduk2(
    BuildContext context,
    String _namaProduk,
    String _namaPemilik,
    String _namaUMKM,
    String? _foto,
    String _noHp,
    String _location,
    var e) {
  ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.only(left: 33.0, right: 33, bottom: 20),
    child: Card(
      elevation: 9,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 297,
        height: 225,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                _foto == null || _foto == ""
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            color: themeProvider.bgColor,
                          ),
                          Icon(Icons.image_outlined,
                              size: 24, color: Colors.grey.shade500)
                        ],
                      )
                    : Container(
                        height: 100,
                        child: Image.network(
                          _foto,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                        // child: CachedNetworkImage(
                        //   imageUrl: _foto,
                        //   width: 90,
                        //   imageBuilder: (context, imageProvider) => Container(
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //         image: imageProvider,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        //   placeholder: (context, url) =>
                        //       CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) =>
                        //       Icon(Icons.error),
                        // ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 110.0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: customText(context, Colors.black, _namaProduk,
                            TextAlign.left, 16, FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: customText(context, Colors.grey, _namaPemilik,
                            TextAlign.left, 12, FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: customText(context, Colors.grey, _namaUMKM,
                            TextAlign.left, 12, FontWeight.w700),
                      ),
                      Row(
                        children: [
                          customText(context, Colors.black, "Kontak UMKM",
                              TextAlign.left, 14, FontWeight.w700),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                String url = _noHp;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  return;
                                }
                                print("couldn't launch $url");
                              },
                              child: Image.asset(
                                "assets/images/whatsapp (2).png",
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          customText(context, Colors.black, "Lokasi UMKM",
                              TextAlign.left, 14, FontWeight.w700),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                String url = _location;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  return;
                                }
                                print("couldn't launch $url");
                              },
                              child: SvgPicture.asset(
                                "assets/images/map.svg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ButtonGradient1(context, "Lihat Details", 10, () {
              Navigator.pushNamed(context, "/detailsProduk", arguments: e);
            })
          ],
        ),
      ),
    ),
  );
}
