import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';
import '../Widget/InputFormStyle3.dart';

class PengajuanDana extends StatefulWidget {
  const PengajuanDana({Key? key}) : super(key: key);

  @override
  _PengajuanDanaState createState() => _PengajuanDanaState();
}

class _PengajuanDanaState extends State<PengajuanDana> {
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
        title: customText(context, Colors.black, "Pengajuan Dana",
            TextAlign.left, 18, FontWeight.normal),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(context, Colors.black26, "Tanggal Pengajuan",
                      TextAlign.left, 18, FontWeight.normal),
                  customText(context, Colors.black, "14/08/2020",
                      TextAlign.left, 18, FontWeight.normal),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                  customText(context, Colors.black26, "Badan Usaha",
                      TextAlign.left, 18, FontWeight.normal),
                  customText(context, Colors.black, "Alam Jaya Permai, PT",
                      TextAlign.left, 18, FontWeight.normal),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                  customText(context, Colors.black26, "Jumlah Dana",
                      TextAlign.left, 18, FontWeight.normal),
                  customText(context, Colors.black, "Rp 200.000.000",
                      TextAlign.left, 18, FontWeight.normal),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                  customText(context, Colors.black26, "Status Pengajuan",
                      TextAlign.left, 18, FontWeight.normal),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: customText(context, Colors.red, "Ditolak",
                        TextAlign.left, 18, FontWeight.normal),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                  customText(context, Colors.black26, "Alasan Ditolak",
                      TextAlign.left, 18, FontWeight.normal),
                  customText(
                      context,
                      Colors.black,
                      "Detail badan usaha belum lengkap, silakan dilengakpi terlebih dahulu.",
                      TextAlign.left,
                      18,
                      FontWeight.normal),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: button2("Lengkapi Data", Colors.blue.shade600,
                        Color.fromARGB(255, 255, 255, 255), context, () {}),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                    Navigator.pushNamed(context, '/formPengajuanDana');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
