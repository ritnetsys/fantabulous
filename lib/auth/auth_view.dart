import 'package:fantabulous/auth.dart';
import 'package:fantabulous/defaults.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  submit() async {
    setState(() {
      inProgress = true;
    });
    if (isLoginForm) {
      await login(emailController.text, passwordController.text);
    } else {
      if (confirmController.text != passwordController.text) {
        return;
      }
      await createUser(emailController.text, passwordController.text);
    }
    setState(() {
      inProgress = false;
    });
    Get.toNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.green[900], Colors.green[800], Colors.green[700]],
          stops: [0.2, 0.4, 0.6],
        )),
        child: Center(
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(20),
            elevation: 5,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: calculateWidth(40), maxHeight: calculateHeight(80)),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
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
                        padding: EdgeInsets.only(top: 45),
                        child: SizedBox(
                          height: 30,
                          child: RaisedButton(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
