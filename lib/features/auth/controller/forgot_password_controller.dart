import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:neura/core/common/api_constants.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/common/routes.dart';

final forgetResetControllerProvider =
StateNotifierProvider<ForgetResetController, AsyncValue<void>>((ref) {
  return ForgetResetController(ref);
});

class ForgetResetController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  ForgetResetController(this.ref) : super(const AsyncValue.data(null));

  Future<void> sendResetCode({
    required String email,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      await DioHelper.postData(
        url: ApiConstants.forgetPassword,
        data: {'email': email},
      );
      state = const AsyncValue.data(null);
      Navigator.pushNamed(
        context,
        AppRoutes.verification,
        arguments: {
          'email': email,
          'isResetPassword': true,
        },
      );
    } on DioError catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to send code';
      state = AsyncValue.error(message, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      await DioHelper.postData(
        url: ApiConstants.resetPassword,
        data: {
          'email': email,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
      state = const AsyncValue.data(null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully.')),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    } on DioError catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to reset password';
      state = AsyncValue.error(message, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
