import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:neura/core/common/api_constants.dart';
import 'package:neura/core/common/routes.dart';
import '../../../core/network/dio_helper.dart';

final verificationControllerProvider =
StateNotifierProvider<VerificationController, AsyncValue<void>>((ref) {
  return VerificationController(ref);
});

class VerificationController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  VerificationController(this.ref) : super(const AsyncValue.data(null));

  Future<void> verifyCode({
    required BuildContext context,
    required String code,
    required String email,
    required bool isResetPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      await DioHelper.postData(
        url: ApiConstants.verifyCode,
        data: {
          'email': email,
          'code': code,
        },
      );
      state = const AsyncValue.data(null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification successful!')),
      );
      Navigator.pushReplacementNamed(
        context,
        isResetPassword ? AppRoutes.reset : AppRoutes.login,
      );
    } on DioError catch (e) {
      final errorMsg = e.response?.data['message'] ?? 'Verification failed';
      state = AsyncValue.error(errorMsg, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }


  Future<void> resendCode(BuildContext context, {required String email}) async {
    try {
      await DioHelper.postData(
        url: ApiConstants.resendCode,
        data: {
          'email': email,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code resent successfully!')),
      );
    } on DioError catch (e) {
      final errorMsg = e.response?.data['message'] ?? 'Failed to resend code';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }
}
