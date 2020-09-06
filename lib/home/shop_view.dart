import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/home/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopView extends StatefulWidget {
  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  UserData user;
  int selected = 0;
  List<String> categoriesList = [];
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    if (auth.currentUser != null) {
      user = UserData.fromDocument(auth.currentUser.uid, (await getUser(auth.currentUser.uid)).data());
    }
    getCategories().listen((event) {
      List<String> valuesList = event.docs
          .map((data) => data.data()['name'].toString())
          .toList();
      setState(() {
        categoriesList = valuesList;
      });
    });
  }

  addToCart(String uid) async {
    if (user.cart.products == null) {
      user.cart.products = [];
    }
    if (!user.cart.products.contains(uid)) {
      user.cart.products.add(uid);
      await updateUser(user);
      Get.snackbar(
          "Added to Cart", "Product has been successfully added to cart.",
          backgroundColor: Colors.green[900], colorText: Colors.white);
    } else {
      Get.snackbar("Already there", "Product has been added to cart before.",
          backgroundColor: Colors.green[900], colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  child: Text('Fantabulous FLower and Fruit Trees',
                      style: GoogleFonts.galada(
                          color: Colors.green[900], fontSize: 24)),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: calculateWidth(isPotrait ? 2 : 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: calculateHeight(10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.length > 0) {
                      return ListView.builder(
                        itemCount: (categoriesList.length + 1),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 0;
                                  });
                                },
                                child: Chip(
                                  label: Text(
                                    'All',
                                    style: GoogleFonts.sourceSerifPro(
                                      color: selected != 0
                                          ? Colors.green[900]
                                          : Colors.white,
                                    ),
                                  ),
                                  backgroundColor: selected == 0 ? Colors.green[900] : Colors.white,
                                ));
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = index + 1;
                                  });
                                },
                                child: Chip(
                                  label: Text(
                                    categoriesList[index - 1],
                                    style: GoogleFonts.sourceSerifPro(
                                      color: selected != (index + 1)
                                          ? Colors.green[900]
                                          : Colors.white,
                                    ),
                                  ),
                                  backgroundColor: selected == (index + 1)
                                      ? Colors.green[900]
                                      : Colors.white,
                                ));
                          }
                        },
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: selected == 0 ? getProducts() : getProductsByCategory(categoriesList[selected - 2]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: (snapshot.data.docs.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: isPotrait ? 0.6 : 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: isPotrait ? 2 : 4),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot doc = snapshot.data.docs[index];
                            Product product =
                                Product.fromDocument(doc.id, doc.data());
                            return Container(
                              height: calculateHeight(50),
                              width: calculateWidth(isPotrait ? 50 : 23),
                              padding: EdgeInsets.all(isPotrait ? 0 : 10),
                              child: Card(
                                margin: EdgeInsets.all(isPotrait ? 5 : 20),
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Container(
                                  width: calculateWidth(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(product.image),
                                              fit: BoxFit.cover),
                                        ),
                                      )),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 5),
                                        child: Text(
                                          product.name,
                                          style: GoogleFonts.sourceSerifPro(
                                              color: Colors.green[900],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: Chip(
                                          label: Text(
                                            product.category,
                                            style: GoogleFonts.sourceSerifPro(
                                                fontSize: 10,
                                                color: Colors.green[900]),
                                          ),
                                          backgroundColor: Colors.green[200],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        child: Text(
                                          product.description,
                                          style: GoogleFonts.sourceSerifPro(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        child: Text(
                                          "₹${product.price}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FlatButton(
                                                onPressed: () {
                                                  if (user != null &&
                                                      user.uid != null) {
                                                    addToCart(product.uid);
                                                  } else {
                                                    dynamic userData =
                                                        Get.toNamed('/login');
                                                    if (userData != null &&
                                                        userData.uid != null) {
                                                      setState(() {
                                                        user = userData;
                                                      });
                                                    }
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                color: Colors.green[900],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.shopping_cart,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
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
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
