import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemListView extends StatefulWidget {
  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Text('OUR PRODUCTS', style: GoogleFonts.sourceSerifPro(color: Colors.green[800], fontSize: 24)),
          Text('The best time to plant a tree was 20 years ago. The second best time is now.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: FlatButton(onPressed: () {}, hoverColor: Colors.green[100], child: Padding(
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
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 450,
            width: calculateWidth(100),
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          Product product = Product.fromDocument(doc.id, doc.data());
                          return Card(
                            margin: EdgeInsets.all(20),
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Container(
                              width: calculateWidth(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover),
                                    ),
                                  )),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                    child: Text(
                                      product.name,
                                      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Chip(
                                      label: Text(
                                        product.category,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[900]),
                                      ),
                                      backgroundColor: Colors.green[200],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Text(
                                      product.description,
                                      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_basket,
                                                  size: 15,
                                                  color: Colors.green[900],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'BUY NOW',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green[900],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  size: 15,
                                                  color: Colors.green[900],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    'ADD TO CART',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green[900],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
