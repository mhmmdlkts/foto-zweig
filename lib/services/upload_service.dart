import 'dart:convert';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:http/http.dart' as http;
import 'package:firebase/firebase.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class UploadService {

  uploadImage(SmallFotoItem smallFotoItem, MediaInfo mediaInfo) async {
    String downloadUrl = await _uploadFile(smallFotoItem, mediaInfo);
    smallFotoItem.path = downloadUrl;
    smallFotoItem.thumbnailPath = downloadUrl;
    String url = 'https://europe-west1-foto-zweig-312d2.cloudfunctions.net/upload?foto=${Uri.encodeComponent(json.encode(smallFotoItem.toJson()))}';
    http.Response response = await http.get(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    if (jsonData["error"] != null)
      return jsonData["error"];
    smallFotoItem.id = jsonData["id"];
    print(smallFotoItem.id);
  }

  _uploadFile(SmallFotoItem smallFotoItem, MediaInfo mediaInfo) async {
    try {
      String mimeType = mime(basename(mediaInfo.fileName));
      var metaData = UploadMetadata(contentType: mimeType);
      StorageReference storageReference = storage().ref('foto').child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = storageReference.put(mediaInfo.data, metaData);
      var snapshot = await uploadTask.future;
      await Future.delayed(Duration(seconds: 1));
      return (await snapshot.ref.getDownloadURL()).toString();
    } catch (e) {
      print('File Upload Error: $e');
    }
  }
}