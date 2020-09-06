import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Developer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
        Container(width: calculateWidth(isPotrait ? 100: 30), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('© 2020 All rights reserved by Fantabulous', style: GoogleFonts.sourceSerifPro(fontSize: 12),),
            Text('Privacy Policy', style: GoogleFonts.sourceSerifPro(fontSize: 12, decoration: TextDecoration.underline),),
          ],
        ), ),
        Container(
          width: calculateWidth(isPotrait ? 100: 30),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Developed By: ', style: GoogleFonts.sourceSerifPro(fontSize: 12),),
                Text('Ayan Saha', style: GoogleFonts.sourceSerifPro(fontWeight: FontWeight.bold, fontSize: 15),),
              ],
            ),
          ),
        ),
        Container(width: calculateWidth(isPotrait ? 100: 30), child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('ayansaha999@gmail.com', style: GoogleFonts.sourceSerifPro(fontSize: 12),),
          ],
        ))
      ],),
    );
  }
}
