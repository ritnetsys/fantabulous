import 'package:fantabulous/home/item_list.dart';
import 'package:fantabulous/home/menu.dart';
import 'package:fantabulous/home/top_carousel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantabulous FLower and Fruit Trees',
            style: GoogleFonts.galada(color: Colors.green[900], fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            MenuView(),
            CarouselView(),
            ItemListView(),
          ],
        ),
      ),
    );
  }
}
