import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<User> createUser(String email, String password) async {
  return (await auth.createUserWithEmailAndPassword(
      email: email, password: password)).user;
}

Future<User> login(String email, String password) async {
  return (await auth.signInWithEmailAndPassword(
      email: email, password: password)).user;
}

