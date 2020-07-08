import 'package:fantabulous/auth/auth_view.dart';
import 'package:fantabulous/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fantabulous',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/login', page: () => AuthView()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}

