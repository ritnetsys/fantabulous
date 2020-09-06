import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/admin/mobile_image_picker.dart';
import 'package:fantabulous/admin/web_image_picker.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:fantabulous/home/order_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountView extends StatefulWidget {
  final bool admin;

  MyAccountView(this.admin);

  @override
  _MyAccountViewState createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<MyAccountView> {
  String name = "";
  String image = "https://via.placeholder.com/350";
  int price = 0;
  String description = "";
  String category;
  String categoryNameVal = '';
  bool inProgress = false;
  TextEditingController categoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  double progressPercent = 0;
  Uint8List uploadedImage;
  File uploadedAndroidFile;
  final picker = ImagePicker();

  startFilePicker() async {
    if (kIsWeb) {
      uploadedImage = await pickFileFromWeb();
      setState(() {});
    } else {
      uploadedImage = await (await picker.getImage(source: ImageSource.gallery)).readAsBytes();
      setState(() {});
    }
  }

  submit() async {
    if (category == null ||
        name.length == 0 ||
        description.length == 0 ||
        price == 0) {
      return;
    }
    setState(() {
      inProgress = true;
    });

    Product product = Product();
    product.home = false;
    product.image = await uploadWebImage();
    // product.image = await uploadMobileImage(uploadedImage);
    product.name = name;
    product.price = price.toString();
    product.description = description;
    product.category = category;
    await addProduct(product);
    setState(() {
      inProgress = false;
    });
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    Get.snackbar("Product Listed", "Your new product has been successfully listed.", backgroundColor: Colors.green[900], colorText: Colors.white);
  }

  @override
  void initState() {
    if (auth.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/");
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPotrait? 2: 10.0),
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
                child: Text('Admin Panel',
                    style: GoogleFonts.galada(
                        color: Colors.green[900], fontSize: isPotrait? calculateWidth(4): 24)),
              ),
              Expanded(child: Container()),
              FlatButton(
                onPressed: () async {
                  await auth.signOut();
                  Get.toNamed('/');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: Colors.green[900],
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: calculateWidth(100),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  elevation: 5,
                  child: Container(
                    width: calculateWidth(90),
                    padding: EdgeInsets.only(bottom: 50, left: 10, right: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            "Add New Product",
                            style: GoogleFonts.galada(
                                color: Colors.green[900], fontSize: 25),
                          ),
                        ),
                        Wrap(
                          children: [
                            Container(
                              width: calculateWidth(isPotrait ? 80 : 40),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RaisedButton(
                                        color: Colors.green[100],
                                        onPressed: () {
                                          startFilePicker();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.image,
                                                color: Colors.green[900],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  'Select Image File'
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.green[900],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: nameController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.text,
                                        autofocus: false,
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                        },
                                        decoration:
                                            InputDecoration(hintText: 'Name'),
                                        validator: (value) => value.isEmpty
                                            ? 'Name can\'t be empty!'
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: descriptionController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.text,
                                        autofocus: false,
                                        onChanged: (value) {
                                          setState(() {
                                            description = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Description'),
                                        validator: (value) => value.isEmpty
                                            ? 'Description can\'t be empty!'
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: priceController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        onChanged: (value) {
                                          setState(() {
                                            price = int.parse(value);
                                          });
                                        },
                                        decoration:
                                            InputDecoration(hintText: 'Price'),
                                        validator: (value) => value.isEmpty
                                            ? 'Price can\'t be empty!'
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: getCategories(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data.docs.length > 0) {
                                              List<String> valuesList = snapshot
                                                  .data.docs
                                                  .map((data) => data
                                                      .data()['name']
                                                      .toString())
                                                  .toList();
                                              return PopupMenuButton<String>(
                                                offset: Offset(0, 45),
                                                onSelected: (String result) {
                                                  setState(() {
                                                    category = result;
                                                  });
                                                },
                                                child: Card(
                                                  color: Colors.green[100],
                                                  elevation: 5,
                                                  margin: EdgeInsets.all(0),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          category == null
                                                              ? 'Select Category'
                                                              : category,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[900]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        valuesList
                                                            .map((e) =>
                                                                PopupMenuItem<
                                                                    String>(
                                                                  child: Container(
                                                                      width: calculateWidth(isPotrait
                                                                          ? 80
                                                                          : 40),
                                                                      child: Text(
                                                                          e)),
                                                                  value: e,
                                                                ))
                                                            .toList(),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 45),
                                        child: inProgress
                                            ? CircularProgressIndicator()
                                            : SizedBox(
                                                height: 30,
                                                child: RaisedButton(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  color: Colors.green[900],
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text('Save Product',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  onPressed: () {
                                                    submit();
                                                  },
                                                ),
                                              ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: calculateWidth(isPotrait ? 80 : 40),
                              height: calculateHeight(isPotrait ? 40 : 50),
                              child: Center(
                                child: ItemPreviewCard(name, description,
                                    category, price, image, uploadedImage),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,
                  child: Container(
                    width: calculateWidth(90),
                    padding: EdgeInsets.symmetric(
                        horizontal: calculateWidth(isPotrait ? 2 : 10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            "Add New Category",
                            style: GoogleFonts.galada(
                                color: Colors.green[900], fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                    controller: categoryController,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                onChanged: (value) {
                                  setState(() {
                                    categoryNameVal = value;
                                  });
                                },
                                decoration:
                                    InputDecoration(hintText: 'Category Name'),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (categoryNameVal.length > 0) {
                                      await addCategory(categoryNameVal);
                                      categoryController.clear();
                                    }
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green[900],
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: getCategories(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: Wrap(
                                    children: snapshot.data.docs
                                        .map((e) => Container(
                                              margin: EdgeInsets.all(5),
                                              child: Chip(
                                                label: Text(
                                                  e.data()['name'],
                                                  style: GoogleFonts
                                                      .sourceSerifPro(
                                                          color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    Colors.green[900],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  elevation: 5,
                  child: Container(
                    width: calculateWidth(90),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            "Pending Orders",
                            style: GoogleFonts.galada(
                                color: Colors.green[900], fontSize: 25),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: getAllOrders(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<OrderData> orders = snapshot.data.docs
                                    .map((e) => OrderData.fromDocument(e.id, e.data()))
                                    .toList();
                                return ListView.builder(
                                  shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: index.isOdd ? Colors.white: Colors.green[100],
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('ORDER ID: #${orders[index].uid}'),
                                              Text('${orders[index].ordered}'),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text('${orders[index].name}', style: TextStyle(fontWeight: FontWeight.bold),),
                                              ),
                                              Text('Email: ${orders[index].email}'),
                                              Text('Phone: ${orders[index].phone}'),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: Text(
                                                  'Products',
                                                  style: GoogleFonts.sourceSerifPro(
                                                      color: Colors.green[900], fontSize: 16),
                                                ),
                                              ),
                                              Text('Requirements: ${orders[index].description.length == 0? 'None': orders[index].description}'),
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemPreviewCard extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String description;
  final String category;
  final Uint8List uploadedImage;

  ItemPreviewCard(this.name, this.description, this.category, this.price,
      this.image, this.uploadedImage);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 5,
      color: Colors.white,
      child: Container(
        width: calculateWidth(isPotrait ? 50 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: uploadedImage == null
                        ? NetworkImage(image)
                        : MemoryImage(uploadedImage),
                    fit: BoxFit.cover),
              ),
            )),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(
                name,
                style: GoogleFonts.sourceSerifPro(
                    color: Colors.green[900],
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Chip(
                label: Text(
                  category == null ? 'None' : category,
                  style: GoogleFonts.sourceSerifPro(
                      fontSize: 10, color: Colors.green[900]),
                ),
                backgroundColor: Colors.green[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                description,
                style: GoogleFonts.sourceSerifPro(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                "₹$price",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
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
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
