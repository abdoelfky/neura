import 'dart:io';

import 'package:dio/dio.dart';
import 'package:neura/core/common/api_constants.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    String? token,
  }) async {
    return dio.delete(
      url,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
    return await dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
    return await dio.put(url, data: data, queryParameters: query);
  }
  static Future<Response> patchData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] =
    token != null ? 'Bearer $token' : null;
    return await dio.patch(url, data: data, queryParameters: query);
  }
  static Future<Response> uploadScan({
    required String url,
    required File file,
    required String type,
    String? token,
    bool useLocalBase = true,
  }) async {
    final Dio tempDio = Dio(
      BaseOptions(
        baseUrl:  ApiConstants.localBaseUrl,
        headers: {
          'Content-Type': 'multipart/form-data',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    final formData = FormData.fromMap({
      'scanImage': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      'type': type,
    });

    return await tempDio.post(url, data: formData);
  }


  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
    return await dio.get(url, queryParameters: query);
  }
}
