import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantabulous/auth.dart';
import 'package:fantabulous/database.dart';
import 'package:fantabulous/defaults.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLoginForm = true;
  bool inProgress = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  submit() async {
    setState(() {
      inProgress = true;
    });
    UserData userData;
    if (isLoginForm) {
      try {
        User user = await login(emailController.text, passwordController.text);
        if (user != null) {
          DocumentSnapshot snapshot = await getUser(user.uid);
          print(snapshot.data());
          userData = UserData.fromDocument(user.uid, snapshot.data());
        } else {
          setState(() {
            inProgress = false;
          });
          Get.snackbar("Invalid Login", "Please check your email and password.",
              backgroundColor: Colors.green[900], colorText: Colors.white);
          return;
        }
      } catch (err) {
        setState(() {
          inProgress = false;
        });
        Get.snackbar("Invalid Login", "Please check your email and password.",
            backgroundColor: Colors.green[900], colorText: Colors.white);
        return;
      }
    } else {
      if (confirmController.text != passwordController.text) {
        setState(() {
          inProgress = false;
        });
        Get.snackbar("Invalid Password", "Please check your password.", backgroundColor: Colors.green[900], colorText: Colors.white);
        return;
      } else if (nameController.text.length == 0 || phoneController.text.length == 0) {
        setState(() {
          inProgress = false;
        });
        Get.snackbar("Empty fields", "Please enter your name and valid phone number!.", backgroundColor: Colors.green[900], colorText: Colors.white);
        return;
      }
      try {
        User user = await createUser(
            emailController.text, passwordController.text);
        if (user != null) {
          userData = UserData();
          userData.uid = user.uid;
          userData.name = nameController.text;
          userData.admin = false;
          userData.address = [];
          userData.phone = phoneController.text;
          userData.email = user.email;
          await addUser(userData);
        } else {
          setState(() {
            inProgress = false;
          });
          Get.snackbar("Invalid email", "Please check your email and password.",
              backgroundColor: Colors.green[900], colorText: Colors.white);
          return;
        }
      } catch (err) {
        setState(() {
          inProgress = false;
        });
        Get.snackbar("Invalid email", "Please check your details.",
            backgroundColor: Colors.green[900], colorText: Colors.white);
        return;
      }
    }
    if (userData.admin) {
      subscribeToNotification();
    }

    Get.offNamed('/', arguments: userData);
  }

  Future<User> handleSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPotrait? 2: 10.0),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.keyboard_backspace, color: Colors.green[900],), onPressed: () {
                Navigator.of(context).pop();
              }),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Fantabulous FLower and Fruit Trees',
                    style: GoogleFonts.galada(color: Colors.green[900], fontSize: isPotrait
                        ? calculateWidth(3.5): 24)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.green[900], Colors.green[800], Colors.green[700]],
          stops: [0.2, 0.4, 0.6],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(20),
                  elevation: 5,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: calculateWidth(isPotrait? 80: 40), maxHeight: calculateHeight(80)),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login to Fantabulous",
                            style: GoogleFonts.galada(
                                color: Colors.green[900], fontSize: 30),
                          ),
                          isLoginForm
                              ? Container()
                              : Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: TextFormField(
                              controller: nameController,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Name',
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.green[900],
                                  )),
                              validator: (value) => value.isEmpty
                                  ? 'Name can\'t be empty!'
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFormField(
                              controller: emailController,
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  icon: Icon(
                                    Icons.mail,
                                    color: Colors.green[900],
                                  )),
                              validator: (value) => value.isEmpty
                                  ? 'Email can\'t be empty!'
                                  : !GetUtils.isEmail(value)
                                      ? 'Please enter valid email!'
                                      : null,
                            ),
                          ),
                          isLoginForm
                              ? Container()
                              : Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFormField(
                              controller: phoneController,
                              maxLines: 1,
                              keyboardType: TextInputType.phone,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Phone',
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.green[900],
                                  )),
                              validator: (value) => value.length != 10
                                  ? 'Phone number not valid!'
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFormField(
                              controller: passwordController,
                              maxLines: 1,
                              obscureText: true,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.green[900],
                                  )),
                              validator: (value) =>
                                  value.isEmpty ? 'Password can\'t be empty' : null,
                            ),
                          ),
                          isLoginForm
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TextFormField(
                                    controller: confirmController,
                                    maxLines: 1,
                                    obscureText: true,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        hintText: 'Confirm Password',
                                        icon: Icon(
                                          Icons.lock,
                                          color: Colors.green[900],
                                        )),
                                    validator: (value) => value.isEmpty
                                        ? 'Password can\'t be empty'
                                        : null,
                                  ),
                                ),
                          Padding(
                              padding: EdgeInsets.only(top: 45, bottom: 20),
                              child: SizedBox(
                                height: 30,
                                child: inProgress ? CircularProgressIndicator() : RaisedButton(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.green[900],
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                        isLoginForm ? 'Login' : 'Create account',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  onPressed: () {
                                    submit();
                                  },
                                ),
                              )),
                          isLoginForm ? Text('Forgot your password? Reset now') : Container(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoginForm = !isLoginForm;
                                  });
                                },
                                child: Text(isLoginForm
                                    ? 'Don\'t have an account? Create New'
                                    : 'Already have an account? Sign In')),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 10.0),
                          //   child: Text('OR'),
                          // ),
                          // RaisedButton(
                          //   onPressed: () async {
                          //     setState(() {
                          //       inProgress = !inProgress;
                          //     });
                          //     User user = await handleSignInWithGoogle();
                          //     DocumentSnapshot data = await getUser(user.uid);
                          //     UserData userData;
                          //     if (!data.exists) {
                          //       userData = UserData();
                          //       userData.uid = user.uid;
                          //       userData.name = user.displayName;
                          //       userData.admin = false;
                          //       userData.address = [];
                          //       userData.phone = user.phoneNumber;
                          //       userData.email = user.email;
                          //       await addUser(userData);
                          //     }
                          //     if (userData.admin) {
                          //       subscribeToNotification();
                          //     }
                          //     Get.offNamed('/', arguments: userData);
                          //   },
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius:
                          //       BorderRadius.all(Radius.circular(20.0))),
                          //   color: Colors.white,
                          //   child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 6.0, horizontal: 8.0),
                          //       child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(right: 5.0),
                          //             child: Image.asset(
                          //               'images/google.webp',
                          //               width: 20.0,
                          //               height: 20.0,
                          //             ),
                          //           ),
                          //           Text(
                          //             'Sign In With Google',
                          //             style: TextStyle(),
                          //           ),
                          //         ],
                          //       )),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
