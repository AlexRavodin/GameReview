import 'package:firebase_storage/firebase_storage.dart';

class ImageProvider {

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> normalizeFirebaseUrl(String imagePath) async {
    String url = await _storage.ref(imagePath).getDownloadURL();

    return url;
  }

}