// features/auth/data/auth_repository.dart

import 'package:dio/dio.dart';
import 'package:neura/core/common/api_constants.dart';
import 'package:neura/features/auth/data/auth_model.dart';
import '../../../core/network/dio_helper.dart';

class AuthRepository {
  Future<AuthModel> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await DioHelper.postData(
      url: ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthModel.fromJson(response.data);
  }

  Future<AuthModel> registerUser({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final payload = {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phoneNumber': phoneNumber,
      };

      print('📤 Sending payload: $payload');

      final response = await DioHelper.postData(
        url: ApiConstants.register,
        data: payload,
      );

      print('✅ Registration response: ${response.data}');
      return AuthModel.fromJson(response.data);

    } on DioError catch (e) {
      print('❌ DioError response: ${e.response?.data}');

      if (e.response?.data is Map && e.response?.data['message'] != null) {
        throw e.response?.data['message'];
      } else if (e.response?.data is String) {
        throw e.response?.data;
      } else {
        throw 'Registration failed. Please try again.';
      }
    }
  }
}
