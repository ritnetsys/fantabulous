import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemListView extends StatefulWidget {
  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  UserData user;
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    if (auth.currentUser != null) {
      user = UserData.fromDocument(auth.currentUser.uid, (await getUser(auth.currentUser.uid)).data());
    }
  }

  addToCart(String uid) async {
    if (user.cart.products == null) {
      user.cart.products = [];
    }
    if (!user.cart.products.contains(uid)) {
      user.cart.products.add(uid);
      await updateUser(user);
      Get.snackbar("Added to Cart", "Product has been successfully added to cart.", backgroundColor: Colors.green[900], colorText: Colors.white);
    } else {
      Get.snackbar("Already there", "Product has been added to cart before.", backgroundColor: Colors.green[900], colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Text('OUR PRODUCTS', style: GoogleFonts.sourceSerifPro(color: Colors.green[800], fontSize: 24)),
          Padding(
            padding: EdgeInsets.symmetric( horizontal: calculateWidth(isPotrait? 4: 0)),
            child: Text('The best time to plant a tree was 20 years ago. The second best time is now.'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: FlatButton(onPressed: () {
              Get.toNamed('/shop');
            }, hoverColor: Colors.green[100], child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Show All Products', style: GoogleFonts.sourceSerifPro(color: Colors.green[800]),),
                  Padding(padding: EdgeInsets.only(left: 8.0), child: Icon(Icons.navigate_next, color: Colors.green[800],),)
                ],
              ),
            )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            width: calculateWidth(100),
            height: calculateHeight(55),
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getHomeProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          Product product = Product.fromDocument(doc.id, doc.data());
                          return Container(
                            margin: EdgeInsets.all(10),
                            width: calculateWidth(isPotrait ? 50 : 16),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white,  boxShadow: [BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: calculateWidth(isPotrait ? 50 : 16),
                                  height: calculateHeight(30),
                                  decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20),),
                                image: DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Text(
                                    product.name,
                                    style: GoogleFonts.sourceSerifPro(color: Colors.green[900], fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Chip(
                                    label: Text(
                                      product.category,
                                      style: GoogleFonts.sourceSerifPro(fontSize: 10, color: Colors.green[900]),
                                    ),
                                    backgroundColor: Colors.green[200],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Text(
                                      product.description,
                                      style: GoogleFonts.sourceSerifPro(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    "₹${product.price}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                          onPressed: () {
                                            if (user != null && user.uid != null) {
                                              addToCart(product.uid);
                                            } else {
                                              dynamic userData = Get.toNamed('/login');
                                              if (userData != null && userData.uid != null) {
                                                setState(() {
                                                  user = userData;
                                                });
                                              }
                                            }
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                          color: Colors.green[900],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'ADD TO CART',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
