import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ImageService {
  Future<String> uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.cloudinary.com/v1_1/ut8hrbqy/image/upload',
      ),
    );

    request.fields['upload_preset'] = 'ml_default';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      return data['secure_url'];
    }

    throw Exception('Image upload failed');
  }
}