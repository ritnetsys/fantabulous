import 'dart:html' as html;
import 'dart:typed_data';

import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase/firebase.dart' as fb;

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String name = "";
  String image = "https://via.placeholder.com/350";
  int price = 0;
  String description = "";
  String category = "None";
  bool inProgress = false;

  double progressPercent = 0;
  Uint8List uploadedImage;
  html.File uploadedImageFile;

  startFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      List<html.File> files = uploadInput.files;
      if (files.length == 1) {
        html.File file = files[0];
        html.FileReader reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImageFile = file;
            uploadedImage = reader.result;
          });
        });

        reader.onError.listen((fileEvent) {});

        reader.readAsArrayBuffer(file);
      }
    });
  }

  submit() {
    setState(() {
      inProgress = true;
    });
    final filePath = 'Products/images/${DateTime.now()}_1.png';
    fb.StorageReference ref = fb.storage().refFromURL('gs://fantabulous-tree-store.appspot.com').child(filePath);

    ref.put(uploadedImageFile).onStateChanged.listen((event) {
      setState(() {
        progressPercent = event != null ? (event.bytesTransferred / event.totalBytes * 100).toInt() : 0;
      });
    }).onDone(() async {
      String url = (await ref.getDownloadURL()).toString();
      Product product = Product();
      product.home = false;
      product.image = url;
      product.name = name;
      product.price = price.toString();
      product.description = description;
      product.category = category;
      await addProduct(product);
      setState(() {
        inProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text('Fantabulous Admin Panel', style: GoogleFonts.galada(color: Colors.green[900], fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(30),
                elevation: 5,
                child: Container(
                  width: calculateWidth(90),
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          "Add New Product",
                          style: GoogleFonts.galada(color: Colors.green[900], fontSize: 25),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: Container(
                              width: calculateWidth(30),
                              child: Column(
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
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                'Select Image File'.toUpperCase(),
                                                style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() {
                                          name = value;
                                        });
                                      },
                                      decoration: InputDecoration(hintText: 'Name'),
                                      validator: (value) => value.isEmpty ? 'Name can\'t be empty!' : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() {
                                          description = value;
                                        });
                                      },
                                      decoration: InputDecoration(hintText: 'Description'),
                                      validator: (value) => value.isEmpty ? 'Description can\'t be empty!' : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() {
                                          price = int.parse(value);
                                        });
                                      },
                                      decoration: InputDecoration(hintText: 'Price'),
                                      validator: (value) => value.isEmpty ? 'Price can\'t be empty!' : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() {
                                          category = value;
                                        });
                                      },
                                      decoration: InputDecoration(hintText: 'Category'),
                                      validator: (value) => value.isEmpty ? 'Category can\'t be empty!' : null,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 45),
                                      child: inProgress
                                          ? Stack(children: [Align(alignment: Alignment.center, child: CircularProgressIndicator()), Align(alignment: Alignment.center, child: Text('$progressPercent%'))])
                                          : SizedBox(
                                              height: 30,
                                              child: RaisedButton(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                color: Colors.green[900],
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  child: Text('Save Product', style: TextStyle(color: Colors.white)),
                                                ),
                                                onPressed: () {
                                                  submit();
                                                },
                                              ),
                                            ))
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            height: 450,
                            child: Center(
                              child: ItemPreviewCard(name, description, category, price, image, uploadedImage),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  ItemPreviewCard(this.name, this.description, this.category, this.price, this.image, this.uploadedImage);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 5,
      color: Colors.white,
      child: Container(
        width: calculateWidth(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: uploadedImage == null ? NetworkImage(image) : MemoryImage(uploadedImage), fit: BoxFit.cover),
              ),
            )),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(
                name,
                style: GoogleFonts.sourceSerifPro(color: Colors.green[900], fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Chip(
                label: Text(
                  category,
                  style: GoogleFonts.sourceSerifPro(fontSize: 10, color: Colors.green[900]),
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
  }
}
