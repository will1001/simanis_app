import 'dart:convert';
import 'dart:math';
import 'package:appsimanis/Provider/ThemeProvider.dart';
import 'package:appsimanis/Widget/DropDown2.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({Key? key}) : super(key: key);

  @override
  _StatistikPageState createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  int touchedIndex = -1;
  double _maxY = 0;
  List _dataBarChart = [7, 4, 5, 6, 7, 8, 9, 10, 3, 5, 7, 4];
  List _dataPieChart = [211, 175];
  String _tahun = "2021";
  List<String> _listTahun = ["2019", "2020", "2021"];

  setData() {
    crud.getData("/badan_usaha/statistik/totalIKM").then((res) {
      setState(() {
        _dataPieChart[0] = jsonDecode(res.body)["total"];
      });
    });

    crud.getData("/badan_usaha/statistik/totalTenagaKerja").then((res) {
      setState(() {
        _dataPieChart[1] = jsonDecode(res.body)["total"];
      });
    });
    setDataBar();
  }

  setDataBar() {
    for (var i = 0; i < _dataBarChart.length; i++) {
      crud
          .getData("/badan_usaha/statistik/tahun/0${i + 1}/${_tahun}")
          .then((res) {
        setState(() {
          _dataBarChart[i] = jsonDecode(res.body)["total"] ?? 0;
          // _maxY < jsonDecode(res.body)["total"]
          //     ? _maxY = jsonDecode(res.body)["total"]
          //     : _maxY;
        });
        // print("/badan_usaha/statistik/bulan/0${i + 1}");
        // print(_dataBarChart);
        // print(_dataBarChart..sort());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    print(_dataBarChart.reduce((a, b) => a + b));
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          // title: textLabel("Produk", 15, Colors.black, "", FontWeight.w400),
          centerTitle: true,

          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            dropDown2(_tahun, "Tahun", _listTahun, (newValue) {
              setState(() {
                _tahun = newValue!;
                setDataBar();
              });
            }),
            AspectRatio(
              aspectRatio: 1.7,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 900,
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Container(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY:
                                    (_dataBarChart.reduce((a, b) => a + b) + 50)
                                        .toDouble(),
                                barTouchData: BarTouchData(
                                  enabled: false,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.transparent,
                                    tooltipPadding: const EdgeInsets.all(0),
                                    tooltipMargin: 8,
                                    getTooltipItem: (
                                      BarChartGroupData group,
                                      int groupIndex,
                                      BarChartRodData rod,
                                      int rodIndex,
                                    ) {
                                      return BarTooltipItem(
                                        rod.y.round().toString(),
                                        TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: Color(0xff7589a2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Januari';
                                        case 1:
                                          return 'Februari';
                                        case 2:
                                          return 'Maret';
                                        case 3:
                                          return 'April';
                                        case 4:
                                          return 'Mei';
                                        case 5:
                                          return 'Juni';
                                        case 6:
                                          return 'Juli';
                                        case 7:
                                          return 'Agustus';
                                        case 8:
                                          return 'September';
                                        case 9:
                                          return 'Oktober';
                                        case 10:
                                          return 'November';
                                        case 11:
                                          return 'Desember';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(showTitles: false),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: _dataBarChart
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i,
                                        BarChartGroupData(
                                          x: i,
                                          barRods: [
                                            BarChartRodData(
                                                y: e.toDouble(),
                                                colors: [
                                                  Colors.lightBlueAccent,
                                                  Colors.greenAccent
                                                ])
                                          ],
                                          showingTooltipIndicators: [0],
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(),
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: Card(
                elevation: 9,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  final desiredTouch = pieTouchResponse
                                          .touchInput is! PointerExitEvent &&
                                      pieTouchResponse.touchInput
                                          is! PointerUpEvent;
                                  if (desiredTouch &&
                                      pieTouchResponse.touchedSection != null) {
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  } else {
                                    touchedIndex = -1;
                                  }
                                });
                              }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections()),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Indicator(
                          color: Color(0xff0293ee),
                          text: 'Total IKM',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Color(0xfff8b250),
                          text: 'Tenaga Kerja',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        // Indicator(
                        //   color: Color(0xff845bef),
                        //   text: 'Third',
                        //   isSquare: true,
                        // ),
                        // SizedBox(
                        //   height: 4,
                        // ),
                        // Indicator(
                        //   color: Color(0xff13d38e),
                        //   text: 'Fourth',
                        //   isSquare: true,
                        // ),
                        // SizedBox(
                        //   height: 18,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: _dataPieChart[0].toDouble(),
            title: '${_dataPieChart[0]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: _dataPieChart[1].toDouble(),
            title: '${_dataPieChart[1]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        // case 2:
        //   return PieChartSectionData(
        //     color: const Color(0xff845bef),
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize,
        //         fontWeight: FontWeight.bold,
        //         color: const Color(0xffffffff)),
        //   );
        // case 3:
        //   return PieChartSectionData(
        //     color: const Color(0xff13d38e),
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize,
        //         fontWeight: FontWeight.bold,
        //         color: const Color(0xffffffff)),
        //   );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
