
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

//curl -X POST "http://172.16.10.65:5000/Shop/PostFiles?shop_cd=1&kind=20" -H  "accept: */*" -H  "Content-Type: multipart/form-data" -F "files=@logo.png;type=image/png" -F "files=@logo2.png;type=image/png"

class FileDownProvider extends ChangeNotifier {

  Future<void> fileDownload(String url) async{
    final response = await http.get(url);

    final imageName = path.basename(url);
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final localPath = path.join(appDir.path, imageName);

    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
  }
}