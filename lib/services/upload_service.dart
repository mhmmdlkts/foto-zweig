import 'dart:convert';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:http/http.dart' as http;
import 'package:firebase/firebase.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class UploadService {

  uploadImage(SmallFotoItem smallFotoItem, MediaInfo mediaInfo) async {
    print('start');
    smallFotoItem.key = await _getFotoKey();
    print(smallFotoItem.key);
    String downloadUrl = await _uploadFile(smallFotoItem, mediaInfo);
    print(smallFotoItem.key);
    String url = 'https://europe-west1-foto-zweig-312d2.cloudfunctions.net/upload?foto=${Uri.encodeComponent(json.encode(smallFotoItem.toJson()))}&key=${smallFotoItem.key}&url=${Uri.encodeComponent(downloadUrl)}';
    http.Response response = await http.get(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    if (jsonData["error"] != null)
      return jsonData["error"];

  }

  _uploadFile(SmallFotoItem smallFotoItem, MediaInfo mediaInfo) async {
    try {
      String mimeType = mime(basename(mediaInfo.fileName));
      var metaData = UploadMetadata(contentType: mimeType);
      StorageReference storageReference = storage().ref('images').child(smallFotoItem.key).child("original.jpg");
      UploadTask uploadTask = storageReference.put(mediaInfo.data, metaData);
      var snapshot = await uploadTask.future;
      await Future.delayed(Duration(seconds: 1));
      return (await snapshot.ref.getDownloadURL()).toString();
    } catch (e) {
      print('File Upload Error: $e');
    }
  }

  Future<String> _getFotoKey() async {
    String url = 'https://europe-west1-foto-zweig-312d2.cloudfunctions.net/getNotExistingFotoKey';
    http.Response response = await http.get(url);
    return response.body.trim();
  }
}