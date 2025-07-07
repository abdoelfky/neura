import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/common/api_constants.dart';

final changePasswordControllerProvider =
StateNotifierProvider<ChangePasswordController, AsyncValue<void>>((ref) {
  return ChangePasswordController();
});

class ChangePasswordController extends StateNotifier<AsyncValue<void>> {
  ChangePasswordController() : super(const AsyncValue.data(null));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    state = const AsyncValue.loading();

    try {
      if (newPassword != confirmPassword) {
        throw 'New passwords do not match';
      }
      final response = await DioHelper.putData(
        url: ApiConstants.changePassword,
        data: {
          'oldPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        },
        token: token,
      );

      // Success
      state = const AsyncValue.data(null);
    } on DioError catch (e) {
      String message = 'Change password failed';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          message = data['message'];
        }
      }
      state = AsyncValue.error(message, StackTrace.current);
      throw message;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      throw e.toString();
    }
  }
}
