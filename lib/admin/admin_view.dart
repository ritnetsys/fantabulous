import 'dart:html';
import 'dart:typed_data';

import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  submit() {}

  Uint8List uploadedImage;

  startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImage = reader.result;
          });
        });

        reader.onError.listen((fileEvent) {});

        reader.readAsArrayBuffer(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text('Fantabulous Admin Panel',
            style: GoogleFonts.galada(color: Colors.green[900], fontSize: 24)),
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
                          style: GoogleFonts.galada(
                              color: Colors.green[900], fontSize: 25),
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
                                            Icon(Icons.image, color: Colors.green[900],),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text('Select Image File'.toUpperCase(), style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),),
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
                                    child: TextFormField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() {
                                          category = value;
                                        });
                                      },
                                      decoration:
                                          InputDecoration(hintText: 'Category'),
                                      validator: (value) => value.isEmpty
                                          ? 'Category can\'t be empty!'
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 45),
                                      child: SizedBox(
                                        height: 30,
                                        child: RaisedButton(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          color: Colors.green[900],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text('Save Product',
                                                style: TextStyle(
                                                    color: Colors.white)),
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
                              child: ItemPreviewCard(name, description,
                                  category, price, image, uploadedImage),
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
  String name;
  String image;
  int price;
  String description;
  String category;
  Uint8List uploadedImage;

  ItemPreviewCard(this.name, this.description, this.category, this.price,
      this.image, this.uploadedImage);

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
                style: TextStyle(
                    color: Colors.green[900], fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Chip(
                label: Text(
                  category,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900]),
                ),
                backgroundColor: Colors.green[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                description,
                style: TextStyle(
                    color: Colors.green[900], fontWeight: FontWeight.bold),
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
