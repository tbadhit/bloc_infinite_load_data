import 'package:flutter_bloc_increment/model/photo_model.dart';
import 'package:http/http.dart' as http;

class PhotoServices {
  Future<List<PhotosModel>?> getPhoto({int? start, int? limit}) async {
    final response = await http.get(Uri.parse(
        "http://jsonplaceholder.typicode.com/photos?_star=$start&_limit=${limit ?? 10}"));
    if (response.statusCode == 200) {
      return photosModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
