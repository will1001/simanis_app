import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Widget/CustomText.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              "assets/images/backArrow.svg",
            ),
          ),
        ),
        centerTitle: true,
        title: customText(context, Colors.black, "Notifikasi", TextAlign.left,
            18, FontWeight.normal),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.blue.shade100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 16.0),
                  child: SvgPicture.asset(
                    "assets/images/Dana.svg",
                    height: 32,
                    width: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Pengajuan Dana Diterima",
                        TextAlign.left, 18, FontWeight.bold),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: customText(
                          context,
                          Colors.black38,
                          "Selamat pengajuan dana anda telah diterima, lakukan verifikasi berikut untuk pencairan dana",
                          TextAlign.left,
                          18,
                          FontWeight.normal),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.blue.shade100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 16.0),
                  child: SvgPicture.asset(
                    "assets/images/Dana.svg",
                    height: 32,
                    width: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Pengajuan Dana Diterima",
                        TextAlign.left, 18, FontWeight.bold),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: customText(
                          context,
                          Colors.black38,
                          "Selamat pengajuan dana anda telah diterima, lakukan verifikasi berikut untuk pencairan dana",
                          TextAlign.left,
                          18,
                          FontWeight.normal),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 16.0),
                  child: SvgPicture.asset(
                    "assets/images/Dana.svg",
                    height: 32,
                    width: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(context, Colors.black, "Pengajuan Dana Ditolak",
                        TextAlign.left, 18, FontWeight.bold),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: customText(
                          context,
                          Colors.black38,
                          "Selamat pengajuan dana anda telah diterima, lakukan verifikasi berikut untuk pencairan dana",
                          TextAlign.left,
                          18,
                          FontWeight.normal),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
