import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmOrder extends StatefulWidget {
  final UserData userData;
  final OrderData orderData;

  ConfirmOrder(this.userData, this.orderData);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  String phone = '';
  String description = '';
  bool inProgress = false;

  confirmOrder() async {
    setState(() {
      inProgress = true;
    });
    try {
      widget.orderData.description = description;
      if (phone != widget.orderData.phone) {
        widget.orderData.phone = phone;
      }
      await placeOrder(widget.orderData);
      widget.userData.cart = OrderData();
      await updateUser(widget.userData);
      Get.back();
    } catch(err) {
      print(err);
    }
  }

  @override
  void initState() {
    phone = widget.userData.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
      width: calculateWidth(isPotrait ? 100 : 50),
      padding: EdgeInsets.all(calculateWidth(isPotrait? 5: 3)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Confirm Order Details', style: GoogleFonts.sourceSerifPro(fontSize: calculateWidth(isPotrait ? 6: 3), color: Colors.green[900]),),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 8.0),
              child: TextFormField(
                maxLines: 1,
                initialValue: widget.orderData.name,
                keyboardType: TextInputType.text,
                enabled: false,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.green[900]),
                    icon: Icon(
                      Icons.person,
                      color: Colors.green[900],
                    )),
                validator: (value) => value.length != 10
                    ? 'Name not valid!'
                    : null,
              ),
            ),
            TextFormField(
              maxLines: 1,
              initialValue: widget.orderData.email,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.green[900]),
                  icon: Icon(
                    Icons.email,
                    color: Colors.green[900],
                  )),
              validator: (value) => value.length != 10
                  ? 'Email not valid!'
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
                maxLines: 1,
                initialValue: widget.orderData.phone,
                keyboardType: TextInputType.phone,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Confirm Phone Number',
                    labelStyle: TextStyle(color: Colors.green[900]),
                    icon: Icon(
                      Icons.call,
                      color: Colors.green[900],
                    )),
                validator: (value) => value.length != 10
                    ? 'Phone number not valid!'
                    : null,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: 'Your Requirements',
                  labelStyle: TextStyle(color: Colors.green[900]),
                  icon: Icon(
                    Icons.description,
                    color: Colors.green[900],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Amount: ₹${widget.orderData.amount}', style: GoogleFonts.sourceSerifPro(fontSize: calculateWidth(isPotrait ? 4: 2)),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: inProgress ? [CircularProgressIndicator(value: null, valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]),)] : [
              RaisedButton(
                color: Colors.red[900],
                onPressed: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.sourceSerifPro(color: Colors.white),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RaisedButton(
                  color: Colors.green[900],
                  onPressed: () {
                    confirmOrder();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Confirm Order',
                      style: GoogleFonts.sourceSerifPro(color: Colors.white),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              )
            ],)
          ],
        ),
      ),
    );
  }
}
