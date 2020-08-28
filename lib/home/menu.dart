import 'package:fantabulous/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  int loginState = 0;

  checkUser() async {
    User user = auth.currentUser;
    if (user == null) {
      setState(() {
        loginState = 1;
      });
    } else {
      setState(() {
        loginState = 2;
      });
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlatButton(
            onPressed: () {
              Get.toNamed('/');
            },
            child: Text(
              'HOME',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {

            },
            child: Text(
              'ABOUT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {

            },
            child: Text(
              'SHOP',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {

            },
            child: Text(
              'CONTACT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {
              if (loginState == 1) {
                Get.toNamed('/login');
              } else {
                Get.toNamed('/admin');
              }
            },
            child: Text(
              loginState == 0 ? '' : loginState == 1 ? 'LOGIN' : 'MY ACCOUNT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
