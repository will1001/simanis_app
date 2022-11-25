import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widget/Button2.dart';
import '../Widget/CustomText.dart';

class Surat extends StatefulWidget {
  const Surat({Key? key}) : super(key: key);

  @override
  _SuratState createState() => _SuratState();
}

class _SuratState extends State<Surat> {
  String _idUser = "";

  @override
  void initState() {
    super.initState();
    getIdUser();
  }

  getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString('idUser');

    setState(() {
      _idUser = idUser!;
    });
  }

  getSuratQuery() {
    return '''
      query{
       Surat{
          id
          judul_kop
          alamat_kop
          nama_kadis
          nip
          jabatan
          alamat
          nomor_surat
          ttd
          updated_at
        }
      }
    ''';
  }

  convertRomawi(String _bln) {
    print(_bln);
    switch (_bln) {
      case "1":
        return "I";
      case "2":
        return "II";
      case "3":
        return "III";
      case "4":
        return "IV";
      case "5":
        return "V";
      case "6":
        return "VI";
      case "7":
        return "VII";
      case "8":
        return "VIII";
      case "9":
        return "IX";
      case "10":
        return "X";
      case "11":
        return "XI";
      case "12":
        return "XII";
      default:
        return _bln;
    }
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
        title: customText(context, Colors.black, "Surat Rekomendasi",
            TextAlign.left, 18, FontWeight.normal),
      ),
      body: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Query(
              options: QueryOptions(document: gql(getSuratQuery())),
              builder: (QueryResult result, {fetchMore, refetch}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Text("");
                }
                final _dataList = result.data?['Surat'];
                final DateTime dateSurat =
                    DateTime.parse(_dataList[0]['updated_at']);
                final DateFormat fullFormat = DateFormat('dd MMMM yyyy');
                final DateFormat tahunFormat = DateFormat('yyyy');
                final DateFormat bulanFormat = DateFormat('MM');
                final DateFormat tglFormat = DateFormat('dd');
                final String fulltgl = fullFormat.format(dateSurat);
                final String tahun = tahunFormat.format(dateSurat);
                final String bulan = bulanFormat.format(dateSurat);
                final String tgl = tglFormat.format(dateSurat);
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/surat.PNG",
                            width: 150,
                            height: 150,
                          ),
                          Container(
                            width: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                    context,
                                    Colors.black,
                                    "Surat Rekomendasi",
                                    TextAlign.left,
                                    18,
                                    FontWeight.normal),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: customText(
                                      context,
                                      Colors.black,
                                      "Nomor : ${_dataList[0]['nomor_surat']}/${bulan}${tgl}/01.IND/${convertRomawi(bulan)}/${tahun}/",
                                      TextAlign.left,
                                      14,
                                      FontWeight.w300),
                                ),
                                customText(context, Colors.black, fulltgl,
                                    TextAlign.left, 14, FontWeight.w300),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: button2(
                                      "Download",
                                      Colors.blue.shade600,
                                      Color.fromARGB(255, 255, 255, 255),
                                      context, () async {
                                    String url =
                                        ("https://simanis.ntbprov.go.id/downloadSurat/" +
                                            _idUser);
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                      return;
                                    }
                                    print("couldn't launch $url");
                                  }),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
