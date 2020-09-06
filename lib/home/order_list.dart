import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderList extends StatefulWidget {
  final UserData user;
  OrderList(this.user);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: calculateWidth(isPotrait ? 3 : 10), vertical: 20),
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.user != null ? getMyOrders(widget.user.uid): null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderData> orders = snapshot.data.docs
                  .map((e) => OrderData.fromDocument(e.id, e.data()))
                  .toList();
              return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ORDER ID: #${orders[index].uid}'),
                            Text('${orders[index].ordered}'),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Products',
                                style: GoogleFonts.sourceSerifPro(
                                    color: Colors.green[900], fontSize: 16),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: orders[index].products.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, pIndex) {
                                  String pId = orders[index].products[pIndex];
                                  return FutureBuilder<DocumentSnapshot>(
                                      future: getProduct(pId),
                                      builder: (context, future) {
                                        if (snapshot.hasData && future.data != null) {
                                          Product product = Product.fromDocument(future.data.id, future.data.data());
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                                "${product.name} x ${orders[index].quantity[pIndex]}"),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      });
                                }),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Total Amount: ₹${orders[index].amount}',
                                style: GoogleFonts.sourceSerifPro(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
