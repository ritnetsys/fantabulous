import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<FirebaseUser> createUser(String email, String password) async {
  return (await auth.createUserWithEmailAndPassword(
      email: email, password: password)).user;
}

Future<FirebaseUser> login(String email, String password) async {
  return (await auth.signInWithEmailAndPassword(
      email: email, password: password)).user;
}

