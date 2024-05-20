import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class StorageMethods{
  Future<Uint8List?> pickImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: source);
      if (file != null) {
        return await file.readAsBytes();
      } else {
        print("No Images Selected");
      }
    } catch (e) {
      print("An error occurred while picking the image: $e");
    }
    return null;
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async{
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print("An error occurred while deleting the image: $e");
    }
  }

}