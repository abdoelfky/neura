// features/profile/data/account_info_repo.dart

import 'package:dio/dio.dart';
import 'package:neura/core/common/api_constants.dart';
import '../../../core/network/dio_helper.dart';
import '../data/profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> fetchProfile(String token) async {
    final response = await DioHelper.getData(
      url: ApiConstants.me,
      token: token,
    );
    return ProfileModel.fromJson(response.data);
  }

  Future<void> changeName({
    required String firstName,
    required String lastName,
    required String token,
  }) async {
    await DioHelper.putData(
      url: ApiConstants.changeName,
      data: {'firstName': firstName, 'lastName': lastName},
      token: token,
    );
  }

  Future<void> changeEmail({
    required String email,
    required String token,
  }) async {
    await DioHelper.putData(
      url: ApiConstants.changeEmail,
      data: {'newEmail': email},
      token: token,
    );
  }
}
