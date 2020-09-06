import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

final StorageReference storageReference = FirebaseStorage().ref().child('Products').child('images').child("${DateTime.now().millisecondsSinceEpoch}.png");

Future<String> uploadMobileImage(Uint8List uploadedImage) async {
  final StorageUploadTask uploadTask = storageReference.putData(uploadedImage);
  StorageTaskSnapshot snapshot = await uploadTask.onComplete;
  return (await snapshot.ref.getDownloadURL()).toString();
}
