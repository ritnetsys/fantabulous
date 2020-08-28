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
  bool showTopBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(showTopBar ? 140 : 80),
        child: AppBar(
          flexibleSpace: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Fantabulous FLower and Fruit Trees', style: GoogleFonts.galada(color: Colors.green[900], fontSize: showTopBar ? 30 : 24)),
              MenuView(),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: NotificationListener<ScrollUpdateNotification>(
          child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CarouselView(),
                  ItemListView(),
                ],
              ),
            ),
          ]),
          onNotification: (notification) {
            if (notification.scrollDelta > 1) {
              setState(() {
                showTopBar = false;
              });
            }
            if (notification.scrollDelta < 0) {
              setState(() {
                showTopBar = true;
              });
            }
            return true;
          },
        ),
      ),
    );
  }
}
