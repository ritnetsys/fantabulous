import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final FirebaseFirestore database = FirebaseFirestore.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher_foreground');
var initializationSettingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification);
var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
// final TwilioFlutter twilioFlutter = TwilioFlutter(
//     accountSid : 'AC099099016c02f419d8f8cfc4a54f1c7e',
//     authToken : 'f7a93d95a7fd9257c8185a6c31c29aa6',
//     twilioNumber : '+12077055919'
// );

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  showDialog(
    context: Get.context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {},
        )
      ],
    ),
  );
}

Future selectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'fantabulous_notification_conference',
        'Fantabulous Orders',
        'Notification regarding your cake orders',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, notification['title'],
        notification['body'], platformChannelSpecifics,
        payload: 'item x');
  }
}

configureMessaging() async {
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        final dynamic data = message['data'];
      }

      if (message.containsKey('notification')) {
        final dynamic notification = message['notification'];
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'fantabulous_notification_conference',
            'Fantabulous Orders',
            'Notification regarding your cake orders',
            importance: Importance.Max,
            priority: Priority.High,
            ticker: 'ticker');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(0, notification['title'],
            notification['body'], platformChannelSpecifics,
            payload: 'item x');
      }
    },
    onBackgroundMessage: backgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {},
    onResume: (Map<String, dynamic> message) async {},
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );
}

subscribeToNotification() async {
  try {
    await firebaseMessaging.subscribeToTopic('orders');
  } catch (er) {
    print(er);
  }
}

const USERS = "Users";
const PRODUCTS = "Products";
const CATEGORIES = "Categories";
const ORDERS = "Orders";

Stream<QuerySnapshot> getCategories() {
  return database.collection(CATEGORIES).orderBy('name').snapshots();
}

Future<DocumentReference> addCategory(String name) {
  return database.collection(CATEGORIES).add(<String, dynamic>{"name": name});
}

Future<DocumentSnapshot> getProduct(String uid) {
  return database.collection(PRODUCTS).doc(uid).get();
}

Stream getProducts() {
  return database.collection(PRODUCTS).orderBy('name').snapshots();
}

Stream getProductsByCategory(String category) {
  return database
      .collection(PRODUCTS)
      .where("category", isEqualTo: category)
      .orderBy('name')
      .snapshots();
}

Stream getHomeProducts() {
  return database
      .collection(PRODUCTS)
      .where("home", isEqualTo: true)
      .orderBy('name')
      .snapshots();
}

Future<DocumentReference> addProduct(Product product) {
  return database.collection(PRODUCTS).add(product.toDocument());
}

Future<DocumentSnapshot> getUser(String uid) {
  return database.collection(USERS).doc(uid).get();
}

Future<void> addUser(UserData userData) {
  userData.cart = OrderData();
  return database
      .collection(USERS)
      .doc(userData.uid)
      .set(userData.toDocument());
}

Future updateUser(UserData user) {
  return database.collection(USERS).doc(user.uid).update(user.toDocument());
}

Stream<QuerySnapshot> getMyOrders(String uid) {
  return database
      .collection(ORDERS)
      .where("user", isEqualTo: uid)
      .orderBy("ordered", descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getAllOrders() {
  return database
      .collection(ORDERS)
      .orderBy("ordered", descending: true)
      .snapshots();
}

Future placeOrder(OrderData orderData) async {
  await sendNotification(
      "Order Placed", "You have a new order from ${orderData.name}", "orders");
  var uname = 'AC099099016c02f419d8f8cfc4a54f1c7e';
  var pword = 'f7a93d95a7fd9257c8185a6c31c29aa6';
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
  var res = await http.post(
      'https://api.twilio.com/2010-04-01/Accounts/AC099099016c02f419d8f8cfc4a54f1c7e/Messages.json',
      headers: {
        'Authorization': authn
      },
      body: {
        'From': 'whatsapp:+14155238886',
        'To': 'whatsapp:+917003799926',
        'Body': 'You have a new order from ${orderData.name}, Please check our app or visit our site for more details.'
      });
  print(res.statusCode);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.body}');
  }
  print('Body: '+res.body);
  return database.collection(ORDERS).add(orderData.toDocument());
}

final String serverToken =
    'AAAANwjN2uA:APA91bEUNOIklNp9kXj1izG51RmuwGtdApuUKhCw8HsNXeqv7alH2imZZTRVJ-lkYTdnYGkkb0J01uLhUFk26gXle30cKrNLQgjcJhApmHJGDuDraBkfMiaxSsAeyOtz4JSBaqhXnYGl';

Future<Map<String, dynamic>> sendNotification(
    String title, String body, String to) async {
  if (!kIsWeb) {
    await firebaseMessaging.getToken();
  }
  http.Response response = await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': "/topics/$to",
      },
    ),
  );
  print("Response" + response.body);
}

class Product {
  String uid;
  String category;
  String description;
  String image;
  String name;
  String price;
  bool home;
  DateTime date;

  Product();

  Product.fromDocument(String uid, Map<String, dynamic> json)
      : uid = uid,
        date = json['date'] != null
            ? (json['date'] as Timestamp).toDate()
            : DateTime.now(),
        category = json['category'],
        description = json['description'],
        image = json['image'],
        name = json['name'],
        price = json['price'],
        home = json['home'];

  Map<String, dynamic> toDocument() => {
        'category': category,
        'description': description,
        'image': image,
        'name': name,
        'price': price,
        'home': home,
        'date': FieldValue.serverTimestamp()
      };
}

class UserData {
  String uid;
  String name;
  String phone;
  String email;
  bool admin;
  OrderData cart;
  List<dynamic> address;

  UserData();

  UserData.fromDocument(String uid, Map<String, dynamic> json)
      : uid = uid,
        phone = json['phone'],
        email = json['email'],
        admin = json['admin'],
        name = json['name'],
        cart = OrderData.fromDocument('', json['cart']),
        address = json['address'];

  Map<String, dynamic> toDocument() => {
        'phone': phone,
        'email': email,
        'admin': admin,
        'name': name,
        'cart': cart.toDocument(),
        'address': address
      };
}

class CartData {
  String uid;
  String productId;
  int quantity;

  CartData();

  CartData.fromDocument(String uid, Map<String, dynamic> json)
      : uid = uid,
        productId = json['productId'],
        quantity = json['quantity'];

  Map<String, dynamic> toDocument() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class OrderData {
  String uid;
  String name;
  String email;
  String phone;
  String user;
  String description;
  int status = 0;
  List<dynamic> products = [];
  List<dynamic> quantity = [];

  DateTime ordered;

  int amount = 0;

  OrderData();

  OrderData.fromDocument(String uid, Map<String, dynamic> json)
      : uid = uid,
        name = json['name'],
        status = json['status'],
        email = json['email'],
        phone = json['phone'],
        quantity = json['quantity'],
        user = json['user'],
        description = json['description'],
        products = json['products'],
        ordered = json['ordered'] != null
            ? (json['ordered'] as Timestamp).toDate()
            : DateTime.now(),
        amount = json['amount'];

  Map<String, dynamic> toDocument() => {
        'name': name,
        'email': email,
        'phone': phone,
        'user': user,
        'quantity': quantity,
        'description': description,
        'status': status,
        'products': products,
        'ordered': FieldValue.serverTimestamp(),
        'amount': amount
      };
}
