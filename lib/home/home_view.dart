import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/home/about_us.dart';
import 'package:fantabulous/home/contact_us.dart';
import 'package:fantabulous/home/developer.dart';
import 'package:fantabulous/home/item_list.dart';
import 'package:fantabulous/home/menu.dart';
import 'package:fantabulous/home/top_carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool showTopBar = true;
  UserData user;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    if (auth.currentUser != null) {
      user = UserData.fromDocument(
          auth.currentUser.uid, (await getUser(auth.currentUser.uid)).data());
      setState(() {});
    }
  }

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();

  List<Widget> widgets = [
    CarouselView(),
    AboutUs(),
    ItemListView(),
    ContactUs(),
    Developer()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showTopBar && isPotrait
          ? RaisedButton(
              onPressed: () {
                if (user == null) {
                  dynamic userData = Get.toNamed('/login');
                  setState(() {
                    user = userData;
                  });
                } else if (user.admin) {
                  Get.toNamed('/admin');
                } else {
                  Get.toNamed('/cart', arguments: user);
                }
              },
              color: Colors.green[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Text(
                  user != null ? user.admin ? 'ADMIN' : 'MY CART' :  'LOGIN',
                  style: GoogleFonts.sourceSerifPro(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(showTopBar ? 140 : 80),
        child: AppBar(
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Fantabulous FLower and Fruit Trees',
                    style: GoogleFonts.galada(
                        color: Colors.green[900],
                        fontSize: isPotrait
                            ? calculateWidth(5)
                            : showTopBar ? 30 : 24)),
                MenuView((int item) {
                  itemScrollController.scrollTo(
                      index: item, duration: Duration(milliseconds: 500));
                }),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: NotificationListener<ScrollUpdateNotification>(
          child: ScrollablePositionedList.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
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
