// import 'dart:async';
// import 'dart:convert';

// import 'package:appsimanis/Provider/ThemeProvider.dart';
// import 'package:appsimanis/Services/FunctionGroup.dart';
// import 'package:appsimanis/Widget/AlertButton.dart';
// import 'package:appsimanis/Widget/AlertDialogBox.dart';
// import 'package:appsimanis/Widget/Button1.dart';
// import 'package:appsimanis/Widget/CardProduk.dart';
// import 'package:appsimanis/Widget/EditDialogBox.dart';
// import 'package:appsimanis/Widget/LoadingWidget.dart';
// import 'package:appsimanis/Widget/StatistikBox.dart';
// import 'package:appsimanis/Widget/TextLabel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomePageWebView extends StatefulWidget {
//   const HomePageWebView({Key? key}) : super(key: key);

//   @override
//   _HomePageWebViewState createState() => _HomePageWebViewState();
// }

// class _HomePageWebViewState extends State<HomePageWebView> {
//   String _storageUrl = "https://simanis.ntbprov.go.id/storage/";
//   late DateTime currentBackPressTime;
//   FunctionGroup functionGroup = new FunctionGroup();
//   bool _loading = true;
//   final webViewPlugin = new FlutterWebviewPlugin();
//   late StreamSubscription<String> _subscription;

//   Future<bool> onWillPop() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       // Fluttertoast.showToast(msg: exit_warning);
//       return Future.value(false);
//     }
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialogBox("", "Keluar dari App ?", [
//             AlertButton("Ya", Colors.blue, null, () async {
//               SystemNavigator.pop();
//             }, context),
//             AlertButton("tidak", Colors.blue, null, () {
//               Navigator.pop(context);
//             }, context),
//           ]);
//         });
//     return Future.value(true);
//   }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _loading = false;
//     });
//      webViewPlugin.close();
//     _subscription = webViewPlugin.onUrlChanged.listen((String url) async {
//       print("navigating to...$url");
//       if (url.startsWith("mailto") ||
//           url.startsWith("tel") ||
//           url.startsWith("http") ||
//           url.startsWith("https")) {
//         await webViewPlugin.stopLoading();
//         await webViewPlugin.goBack();
//         if (await canLaunch(url) && url != "https://simanis.ntbprov.go.id/") {
//           await launch(url);
//           return;
//         }
//         print("couldn't launch $url");
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Every listener should be canceled, the same should be done with this stream.
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeProvider themeProvider =
//         Provider.of<ThemeProvider>(context, listen: false);
//     return _loading
//         ? loadingWidget(context)
//         : WillPopScope(
//             onWillPop: onWillPop,
//             child: WebviewScaffold(
//               url: "https://simanis.ntbprov.go.id",
//               // appBar: new AppBar(
//               //   title: new Text("Widget webview"),
//               // ),
//             ),
//           );
//   }
// }
