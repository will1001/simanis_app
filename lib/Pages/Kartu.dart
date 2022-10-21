import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class Kartu extends StatefulWidget {
  const Kartu({Key? key}) : super(key: key);

  @override
  _KartuState createState() => _KartuState();
}

class _KartuState extends State<Kartu> {
  bool _passError = false;
  bool _obscPass = true;

  TextEditingController passwordTextEditingController =
      new TextEditingController();

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
        title: customText(context, Colors.black, "Kartu", TextAlign.left, 18,
            FontWeight.normal),
      ),
      backgroundColor: Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                          "https://expertphotography.b-cdn.net/wp-content/uploads/2020/08/social-media-profile-photos-3.jpg",
                          height: 80),
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                                context,
                                Colors.black,
                                "No Kartu. 098798",
                                TextAlign.center,
                                22,
                                FontWeight.bold),
                            customText(
                                context,
                                Colors.black,
                                "NIK 021351351284652",
                                TextAlign.center,
                                18,
                                FontWeight.normal),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(context, Colors.black26, "Nama",
                                  TextAlign.center, 18, FontWeight.normal),
                              customText(
                                  context,
                                  Colors.black,
                                  "Wili Rahmat Muhammad",
                                  TextAlign.center,
                                  18,
                                  FontWeight.normal),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(context, Colors.black26, "Alamat",
                                  TextAlign.left, 18, FontWeight.normal),
                              Container(
                                width: 210,
                                child: customText(
                                    context,
                                    Colors.black,
                                    "Jl. Sriwijaya No.333, Punia, Kec. Mataram, Kota Mataram, Nusa Tenggara Bar. 83127",
                                    TextAlign.left,
                                    18,
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(context, Colors.black26, "Badan Usaha",
                                  TextAlign.left, 18, FontWeight.normal),
                              Container(
                                width: 210,
                                child: customText(
                                    context,
                                    Colors.black,
                                    "Ternak Sapi",
                                    TextAlign.left,
                                    18,
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(context, Colors.black26, "Kabupaten",
                                  TextAlign.left, 18, FontWeight.normal),
                              Container(
                                  width: 210,
                                  child: customText(
                                      context,
                                      Colors.black,
                                      "Lombok Timur",
                                      TextAlign.left,
                                      18,
                                      FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: button2("Edit Data", Colors.blue.shade600,
                        Color.fromARGB(255, 255, 255, 255), context, () {}),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
