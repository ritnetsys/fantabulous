import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(
            "https://www.google.co.in/maps/place/Fantabulous+Flowers+and+Fruit+Trees/@22.8580651,88.4070204,15.27z/data=!4m5!3m4!1s0x39f897fb5f5e0a33:0x7ffb0aacffab5494!8m2!3d22.855448!4d88.42331");
      },
      child: Container(
        width: calculateWidth(100),
        height: calculateHeight(60),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/map.webp'), fit: BoxFit.cover)),
        child: Container(
          width: calculateWidth(100),
          height: calculateHeight(40),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.green[900].withOpacity(0.9),
              Colors.green[700].withOpacity(0.7),
              Colors.green[500].withOpacity(0.5),
              Colors.green[100].withOpacity(0.3)
            ],
            stops: [0.2, 0.4, 0.6, 0.8],
          )),
          child: Center(
            child: Row(
              children: [
                Container(
                  height: calculateHeight(40),
                  width: calculateWidth(isPotrait ? 80 :30),
                  color: Colors.white,
                  margin: EdgeInsets.only(left: calculateWidth(isPotrait? 1: 10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Text(
                          'CONTACT US',
                          style: GoogleFonts.sourceSerifPro(
                              color: Colors.green[900],
                              fontSize: calculateWidth(isPotrait? 6 :2)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: calculateWidth(3)),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.green[900],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Ab road by lane 2 , Narayanpur(Talikhola),pin-743126 Kolkata West Bengal 743126 IN, Kankinara, West Bengal 700136',
                                            style: GoogleFonts.sourceSerifPro(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.green[900],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text('+919830949454'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: Colors.green[900],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                              'fantabulousfruitsandflowers@gmail.com'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'images/facebook.png',
                                        color: Colors.green[900],
                                        height: 24,
                                        width: 24,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await launch("https://www.facebook.com/fantabulousflowerfruittrees");
                                            },
                                              child: Text(
                                            '@fantabulousflowerfruittrees',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
