import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/home/confirm_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCart extends StatefulWidget {
  final UserData user;
  MyCart(this.user);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<Product> products = [];
  List<int> quantity = [];

  bool inProgress= false;
  UserData user;

  @override
  void initState() {
    user = widget.user;
    getCartData();
    super.initState();
  }

  getCartData() async {
    if (auth.currentUser != null) {
      setState(() {
        inProgress=true;
      });
      user = UserData.fromDocument(
          auth.currentUser.uid, (await getUser(auth.currentUser.uid)).data());
      List<Product> productList = [];
      for (String id in user.cart.products) {
        DocumentSnapshot snapshot = await getProduct(id);
        Product product = Product.fromDocument(snapshot.id, snapshot.data());
        productList.add(product);
        quantity.add(1);
      }
      setState(() {
        products = productList;
        inProgress=false;
      });
      setState(() {});
    }
  }

  removeFromCart(Product product) async {
    user.cart.products.remove(product.uid);
    products.remove(product);
    await updateUser(user);
    setState(() {});
  }

  placeOrder() {
    OrderData orderData = user.cart;
    orderData.user = user.uid;
    orderData.name = user.name;
    orderData.phone = user.phone;
    orderData.email = user.email;
    orderData.products = products.map((e) => e.uid).toList();
    orderData.quantity = quantity;
    orderData.amount = getTotal();
    orderData.status = 1;
    orderData.description = '';
    Get.bottomSheet(
        ConfirmOrder(user, orderData), isDismissible: false, enableDrag: false)
        .whenComplete(() {
      getCartData();
    });
  }

  getTotal() {
    int total = 0;
    for (Product product in products) {
      total += (int.parse(product.price) * quantity[products.indexOf(product)]);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: calculateWidth(isPotrait ? 3 : 10), vertical: 20),
        child: products.length == 0 ? Center(child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))), child: inProgress ? CircularProgressIndicator(value: null, valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]),):Text('Your cart is empty!'),),) : Column(
          children: [
            Expanded(
                child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: isPotrait ? 0.6 : 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: isPotrait ? 2 : 4),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      Product product = products[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(product.image),
                                            fit: BoxFit.cover),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Text(
                                    product.name,
                                    style: GoogleFonts.sourceSerifPro(
                                        color: Colors.green[900],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    product.description,
                                    style: GoogleFonts.sourceSerifPro(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    "₹${product.price}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Quantity:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.green[900],
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(20))),
                                              child: Icon(
                                                Icons.remove,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              if (quantity[index] > 1) {
                                                quantity[index]--;
                                                setState(() {});
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          quantity[index].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.green[900],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Icon(
                                              Icons.add,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            quantity[index]++;
                                            setState(() {});
                                          })
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FlatButton(
                                          onPressed: () {
                                            removeFromCart(product);
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          color: Colors.red[900],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                                  child: Text(
                                                    'Remove',
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
                    })),
            Container(
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        'Total: ₹${getTotal()}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.green[900],
                      onPressed: () {
                        placeOrder();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Place Order',
                          style: GoogleFonts.sourceSerifPro(
                              color: Colors.white),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    )
                  ],
                ))
          ],
        ));
  }
}

typedef void RefreshCartCallback();
