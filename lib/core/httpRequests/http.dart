import 'dart:io';

import 'package:dio/dio.dart';

abstract class HTTP_Requests with Dio {
  static Dio dio = Dio(BaseOptions(
    receiveDataWhenStatusError: true,
  ));

  static String _baseUrl = 'https://dev.elektronikey.com';

  static Future<List> getHttp(List<String> url) async {
    String uri = _baseUrl;

    if (url.length > 1) {
      uri = uri + '?';
      for (var i = 0; i < url.length; i++) {
        if (i == 0) {
          uri = uri + url[i];
        } else {
          uri = uri + '&' + url[i];
        }
      }
    }
    if (url.length == 1) {
      uri = uri + '?' + url[0];
    }

    try {
      Response response = await dio.get(uri);

      // The response data is already a List<dynamic>, no need to decode it
      final List<dynamic> jsonData = response.data;

      Update.setLastFetch(DateTime.now());
      // If you expect a List<Map<String, dynamic>>, you can work with it directly
      List<Map<String, dynamic>> dataList =
          jsonData.cast<Map<String, dynamic>>();

      return dataList;
    } catch (error) {
      print('HTTP Error: $error');
      return [];
    }
  }

  static Future<Map> sendPostRequest(Map<String, dynamic> data) async {
    Dio dio = Dio();

    try {
      var formData = FormData.fromMap(data);

      var response = await dio.post(
        _baseUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        Update.setLastFetch(DateTime.now());
        // Yanıtın içeriğini kontrol etmek ve işlemek için gerekli adımları burada yapın
        try {
          return response.data;
        } catch (error) {
          return {'error': error};
        }
      } else {
        return {'status': response.statusCode};
      }
    } catch (error) {
      return {'error': error};
    }
  }

  static Future<Map> postImagesWithDio(
      List<File> imageFiles, Map<String, dynamic>? data) async {
    // Replace 'your-api-endpoint' with the actual endpoint where you want to post the images
    String apiUrl = _baseUrl;
    FormData? formData;
    // Create a Dio instance
    var dio = Dio();

    try {
      // Create a FormData object for the image files
      if (data!.isNotEmpty) {
        formData = FormData.fromMap(data);
      } else {
        formData = FormData();
      }

      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry(
          'images[$i]',
          await MultipartFile.fromFile(
            imageFiles[i].path,
            filename: 'image_$i.jpg',
          ),
        ));
      }

      // Send the POST request
      var response = await dio.post(
        apiUrl,
        data: formData,
      );

      print(response);
      if (response.statusCode == 200) {
        // Images successfully uploaded

        return response.data;
      } else {
        // Handle errors

        return {
          'error':
              'Failed to upload images. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      // ⁡⁢⁣⁣Handle exceptions⁡

      return {'error': 'Error uploading images: $e'};
    }
  }
}

class Update {
  static DateTime? _lastFetch;

  static void setLastFetch(DateTime updateDate) {
    _lastFetch = updateDate;
  }

  static String lastFetchDate() {
    if (DateTime.now().difference(_lastFetch!).inSeconds > 60) {
      return '${DateTime.now().difference(_lastFetch!).inMinutes} Dakika Önce';
    } else {
      return '${DateTime.now().difference(_lastFetch!).inSeconds} Saniye Önce';
    }
  }
}
