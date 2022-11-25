import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/CustomText.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
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

  getNotifikasiQuery() {
    return '''
      query{
       Notifikasi(user_id:"${_idUser}"){
          id
          nik
          deskripsi
          status
          user_role
          created_at
          updated_at
        }
      }
    ''';
  }

  String NotifikasiMutation = r'''
      mutation($id: String!){
        Notifikasi(id:$id){
          messagges
        }
      }
    ''';

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
      body: Query(
          options: QueryOptions(document: gql(getNotifikasiQuery())),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Text("");
            }
            final _dataList = result.data?['Notifikasi'];

            return ListView(
              children: _dataList.map<Widget>((e) {
                return Mutation(
                  options: MutationOptions(
                    document: gql(NotifikasiMutation),

                    // or do something with the result.data on completion
                    onCompleted: (dynamic resultData) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // setState(() {});
                      Navigator.popAndPushNamed(context, '/notificationList');
                      // print(resultData);
                    },
                    onError: (err) {
                      print(err);
                    },
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return GestureDetector(
                      onTap: () {
                        runMutation(<String, dynamic>{
                          'id': e['id'],
                        });
                      },
                      child: Container(
                        color: e['deskripsi'] == "read"
                            ? Colors.white
                            : Colors.blue.shade100,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 16.0),
                              child: SvgPicture.asset(
                                "assets/images/Dana.svg",
                                height: 32,
                                width: 32,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                    context,
                                    Colors.black,
                                    "Pengajuan Dana",
                                    TextAlign.left,
                                    18,
                                    FontWeight.bold),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: customText(
                                      context,
                                      Colors.black38,
                                      e['deskripsi'],
                                      TextAlign.left,
                                      18,
                                      FontWeight.normal),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }),
    );
  }
}
