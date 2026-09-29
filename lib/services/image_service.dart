import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  Future<String> uploadImage(XFile image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.cloudinary.com/v1_1/ut8hrbqy/image/upload',
      ),
    );

    request.fields['upload_preset'] = 'campusmart_unsigned';

    final bytes = await image.readAsBytes();

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
      ),
    );

    final response = await request.send();
    final responseData =
    await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['secure_url'];
    }

    throw Exception(
      'Cloudinary error: $responseData',
    );
  }
}