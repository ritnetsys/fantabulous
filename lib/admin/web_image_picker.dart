import 'package:universal_html/html.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:typed_data';

File uploadedFile;

Future<Uint8List> pickFileFromWeb() async {
  InputElement uploadInput = FileUploadInputElement();
  uploadInput.click();

  await uploadInput.onChange.first;
  uploadedFile = uploadInput.files[0];
  FileReader reader = FileReader();
  reader.readAsArrayBuffer(uploadedFile);
  await reader.onLoadEnd.first;
  return reader.result;
}

Future<String> uploadWebImage() async {
  final filePath = 'products/images/"${DateTime.now().millisecondsSinceEpoch}.png';
  fb.StorageReference ref = fb
      .storage()
      .refFromURL('gs://fantabulous-trees.appspot.com')
      .child(filePath);

  fb.UploadTaskSnapshot task = await ref.put(uploadedFile).future;
  return (await ref.getDownloadURL()).toString();
}