import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/home/confirm_order.dart';
import 'package:fantabulous/home/my_cart.dart';
import 'package:fantabulous/home/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  UserData user;

  @override
  void initState() {
    user = Get.arguments;
    if (user == null || user.uid == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: isPotrait? 2: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.green[900],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('My Account',
                      style: GoogleFonts.galada(
                          color: Colors.green[900], fontSize: isPotrait? calculateWidth(4): 24)),
                ),
                Expanded(child: Container()),
                FlatButton(
                  onPressed: () async {
                    await auth.signOut();
                    Get.toNamed('/');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.green[900],
                )
              ],
            ),
          ),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 8, color: Colors.green[500])),
            tabs: [
              Tab(
                child: Text('MY CART',
                    style: GoogleFonts.sourceSerifPro(
                        color: Colors.green[900], fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text(
                  'MY ORDERS',
                  style: GoogleFonts.sourceSerifPro(
                      color: Colors.green[900], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.green[900],
        body: TabBarView(
          children: [MyCart(user), OrderList(user)],
        ),
      ),
    );
  }
}

