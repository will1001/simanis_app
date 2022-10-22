import 'dart:convert';

import 'package:appsimanis/Widget/CardUMKM2.dart';
import 'package:appsimanis/Widget/CustomText.dart';
import 'package:appsimanis/Widget/EditDialogBox.dart';
import 'package:appsimanis/Widget/LoadingWidget.dart';
import 'package:appsimanis/Widget/SearchButton1.dart';
import 'package:appsimanis/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/CardUMKM3.dart';

class DetailsStatistik extends StatefulWidget {
  final String title;
  final String graphqlQuery;
  const DetailsStatistik({
    Key? key,
    required this.title,
    required this.graphqlQuery,
  }) : super(key: key);

  @override
  _DetailsStatistikState createState() => _DetailsStatistikState();
}

class _DetailsStatistikState extends State<DetailsStatistik> {
  TextEditingController _keywordController = new TextEditingController();
  bool _loading = false;
  List _listBadanUsaha = [];
  int _dataLoaded = 10;
  int _reccentPage = 0;
  ScrollController _scrollController = new ScrollController();

  String _query = '';

  cariBadanUsaha(String keyword, int limit, String _indsutri) {
    // print('keyword');
    // print(keyword);

    crud
        .getData(
            '/badan_usaha/detailStatistik/totalTenagaKerja/klasifikasiFilter/$_indsutri/null/$limit/$keyword')
        .then((res) {
      setState(() {
        _listBadanUsaha.clear();
        _listBadanUsaha = jsonDecode(res.body);
        // _keywordController.text = '';
      });
    });
  }

  getBadanUsaha() async {
    var data = client.value.query(QueryOptions(document: gql(_query)));
    data.then((value) => {
          setState(() {
            _listBadanUsaha.addAll(value.data?['badanUsaha']);
            // _listBadanUsaha = value.data?['badanUsaha'];
          })
        });
  }

  _getMoreData() {
    RegExp offsetRegex = RegExp(r'page:.*?,');
    Iterable<Match> offsetParam = offsetRegex.allMatches(_query);
    for (Match match in offsetParam) {
      String? item = match.group(0);
      setState(() {
        _query = _query.replaceAll(
            item.toString(), r'page:' + (_reccentPage + 1).toString() + r',');
        _reccentPage += 1;
      });
    }
    getBadanUsaha();
  }

  savePreviousData(List _data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prevdataCache = prefs.getString('badanUsaha');
    if (prevdataCache == "" || prevdataCache == null) {
      await prefs.setString('badanUsaha', jsonEncode(_data));
    } else {
      List prevData = jsonDecode(prevdataCache);
      List newData = [...prevData, ..._data];
      await prefs.setString('badanUsaha', jsonEncode(_data));
      // print(newData);
    }
  }

  @override
  void initState() {
    super.initState();
    _query = widget.graphqlQuery;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_listBadanUsaha.length < 50) {
        } else {
          print("go");
          _getMoreData();
        }
      }
    });
    getBadanUsaha();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_listBadanUsaha);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                child: customText(context, Colors.black, widget.title,
                    TextAlign.left, 16, FontWeight.w500),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: _listBadanUsaha.length == 0
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator()),
                        ],
                      ))
                    : ListView(
                        controller: _scrollController,
                        children: _listBadanUsaha.map<Widget>((e) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: cardUMKM3(context, e),
                              ),
                              Container(
                                height: 8,
                              ),
                              Container(
                                color: Colors.black12,
                                height: 1,
                              ),
                              Container(
                                height: 8,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
          _loading ? loadingWidget(context) : Container()
        ],
      ),
    );
  }
}
