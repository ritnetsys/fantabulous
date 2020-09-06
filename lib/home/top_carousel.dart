import 'dart:async';

import 'package:fantabulous/defaults.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselView extends StatefulWidget {
  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  List<String> images = [
    "images/flower_tree.webp",
    "images/fruit_tree.webp",
    "images/home_decor.webp",
    "images/medicine_plant.webp",
    "images/much_more.webp",
  ];
  List<String> titles = [
    "Flower Trees",
    "Fruit Trees",
    "Home Decoration",
    "Medicinal Plants",
    "Much More"
  ];
  int position = 0;
  Timer timer;

  next() {
    int updatedPos = position == 4 ? 0 : (position + 1);
    setState(() {
      position = updatedPos;
    });
  }

  prev() {
    int updatedPos = position == 0 ? (position - 1) : 4;
    setState(() {
      position = updatedPos;
    });
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => next());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: calculateWidth(100),
      height: calculateHeight(isPotrait ? 40 : 70),
      child: Row(
        children: [
          !kIsWeb
              ? Container()
              : Expanded(
                  flex: isPotrait ? 1 : 2,
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        prev();
                      },
                      child: Icon(
                        Icons.arrow_left,
                        size: 50,
                        color: Colors.green[700],
                      ),
                    ),
                  )),
          Expanded(
              flex: isPotrait ? 9 : 6,
              child: Container(
                child: Card(
                  margin: EdgeInsets.all(20),
                  color: Colors.green[800],
                  elevation: 10,
                  child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(images[position]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey[500], BlendMode.darken)),
                      ),
                      child: Center(
                        child: Text(
                          titles[position],
                          style: GoogleFonts.galada(
                              color: Colors.white,
                              fontSize: isPotrait ? calculateWidth(6) : 50),
                        ),
                      )),
                ),
              )),
          !kIsWeb
              ? Container()
              : Expanded(
                  flex: isPotrait ? 1 : 2,
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        next();
                      },
                      child: Icon(
                        Icons.arrow_right,
                        size: 50,
                        color: Colors.green[700],
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
