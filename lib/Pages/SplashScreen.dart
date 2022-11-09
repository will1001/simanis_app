import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

getGpsPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      Navigator.pushNamed(context, '/login');
    });
    getGpsPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      body: Center(
        child: Image.asset(
          'assets/images/LogoWhite.png',
          height: 350,
        ),
      ),
    );
  }
}
