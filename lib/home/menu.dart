import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuView extends StatefulWidget {
  final MenuSelectionCallback menuSelectionCallback;

  MenuView(this.menuSelectionCallback);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                widget.menuSelectionCallback(0);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isPotrait ? 5.0 : 10.0),
                child: Text(
                  'HOME',
                  style: GoogleFonts.lato(
                      color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              )),
          GestureDetector(
              onTap: () {
                widget.menuSelectionCallback(1);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isPotrait ? 5.0 : 10.0),
                child: Text(
                  'ABOUT US',
                  style: GoogleFonts.lato(
                      color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              )),
          GestureDetector(
              onTap: () {
                widget.menuSelectionCallback(2);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isPotrait ? 5.0 : 10.0),
                child: Text(
                  'SHOP',
                  style: GoogleFonts.lato(
                      color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              )),
          GestureDetector(
              onTap: () {
                widget.menuSelectionCallback(3);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isPotrait ? 5.0 : 10.0),
                child: Text(
                  'CONTACT US',
                  style: GoogleFonts.lato(
                      color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              )),
          isPotrait
              ? Container()
              : user != null && !user.admin && user.uid != null
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed('/cart', arguments: user);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isPotrait ? 5.0 : 10.0),
                        child: Text(
                          'MY CART',
                          style: GoogleFonts.lato(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        if (user == null || user.uid == null) {
                          dynamic userData = Get.toNamed('/login');
                          if (userData.uid != null) {
                            setState(() {
                              user = userData;
                            });
                          }
                        } else {
                          Get.toNamed('/admin');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isPotrait ? 5.0 : 10.0),
                        child: Text(
                          user == null || user.uid == null ? 'LOGIN' : 'ADMIN',
                          style: GoogleFonts.lato(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold),
                        ),
                      ))
        ],
      ),
    );
  }
}

typedef void MenuSelectionCallback(int item);
