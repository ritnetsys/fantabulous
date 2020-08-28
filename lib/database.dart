import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseFirestore database = FirebaseFirestore.instance;

const PRODUCTS = "Products";

Stream getProducts() {
  return database.collection(PRODUCTS).orderBy('name').snapshots();
}

Future<DocumentReference> addProduct(Product product) {
  return database.collection(PRODUCTS).add(product.toDocument());
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
        date = json['date'] != null ? (json['date'] as Timestamp).toDate() : DateTime.now(),
        category = json['category'],
        description = json['description'],
        image = json['image'],
        name = json['name'],
        price = json['price'],
        home = json['home'];

  Map<String, dynamic> toDocument() => {'category': category, 'description': description, 'image': image, 'name': name, 'price': price, 'home': home, 'date': FieldValue.serverTimestamp()};
}
