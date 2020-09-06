import 'dart:io';
import 'dart:ui';

import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  initializeFirebase() async {
      await Firebase.initializeApp();
      await configureMessaging();
      sleep(Duration(seconds: 2));
      Get.toNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.green[900], body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/much_more.webp'), fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.green[900].withOpacity(0.4),
          child: Center(child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Fantabulous',
                  style: GoogleFonts.galada(
                      color: Colors.white,
                      fontSize: calculateWidth(13))),
              Text('FLower and Fruit Trees', style: GoogleFonts.galada(
                  color: Colors.white,
                  fontSize: calculateWidth(5)))
            ],
          ),),
        ),
      ),
    ),);
  }
}
