import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_1/main.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState(){
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Image.asset(
          "assets/images/metal_simple.png",
          width: 250.0,
          height: 150.0,
        ),
      ),

    );
  }
}