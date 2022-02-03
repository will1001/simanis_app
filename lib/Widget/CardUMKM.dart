import 'package:appsimanis/Widget/ButtonGradient1.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

Widget cardUMKM(BuildContext context, String _text, String _subText,
    String _noHp, String _location, var e) {
  return Padding(
    padding: const EdgeInsets.only(left: 33.0, right: 33, bottom: 20),
    child: Card(
      elevation: 9,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 297,
        height: 164,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: customText(context, Colors.black, _text,
                      TextAlign.left, 21, FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: customText(context, Colors.grey, _subText,
                      TextAlign.left, 14, FontWeight.w700),
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
            ButtonGradient1(context, "Lihat Details", 10, () {
              Navigator.pushNamed(context, "/detailsUMKM", arguments: e);
            })
          ],
        ),
      ),
    ),
  );
}
