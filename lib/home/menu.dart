import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuView extends StatelessWidget {
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
        FlatButton(
            onPressed: () {},
            child: Text(
              'LOGIN',
              style: GoogleFonts.lato(
                  color: Colors.green[800], fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
