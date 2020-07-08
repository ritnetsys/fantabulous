import 'package:fantabulous/auth.dart';
import 'package:fantabulous/auth/auth_view.dart';
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
    FirebaseUser user = await auth.currentUser();
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
            onPressed: () {},
            child: Text(
              'HOME',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {},
            child: Text(
              'ABOUT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {},
            child: Text(
              'SHOP',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {},
            child: Text(
              'CONTACT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
        loginState == 0 ?  Container(): loginState == 1 ? FlatButton(
            onPressed: () {
              Get.toNamed('/login');
            },
            child: Text(
              'LOGIN',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )): FlatButton(
            onPressed: () {
              Get.toNamed('/admin');
            },
            child: Text(
              'MY ACCOUNT',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
