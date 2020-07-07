import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore database = Firestore.instance;

Stream getProducts() {
  return database.collection("Products").orderBy('name').snapshots();
}