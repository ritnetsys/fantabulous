import 'package:fantabulous/admin/my_account.dart';
import 'package:fantabulous/auth/auth_view.dart';
import 'package:fantabulous/home/cart_view.dart';
import 'package:fantabulous/home/home_view.dart';
import 'package:fantabulous/home/shop_view.dart';
import 'package:fantabulous/home/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  initializeFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fantabulous Flower and Fruit Trees',
      initialRoute: kIsWeb ? '/' : '/splash',
      getPages: [
        GetPage(name: '/', page: () => HomeView()),
        GetPage(name: '/splash', page: () => SplashView()),
        GetPage(name: '/shop', page: () => ShopView()),
        GetPage(name: '/cart', page: () => CartView()),
        GetPage(name: '/login', page: () => AuthView()),
        GetPage(name: '/admin', page: () => MyAccountView(true)),
        GetPage(name: '/my_account', page: () => MyAccountView(false)),
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

