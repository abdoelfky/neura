
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:neura/core/common/routes.dart';

import 'auth_controller.dart';

final signupControllerProvider =
StateNotifierProvider<SignupController, AsyncValue<void>>((ref) {
  return SignupController(ref);
});

class SignupController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  SignupController(this.ref) : super(const AsyncValue.data(null));

  Future<void> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).registerUser(
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
      );

      state = const AsyncValue.data(null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.verification,
        arguments: {
          'email': email,
          'isResetPassword': false,
        },
      );

    } on DioError catch (e) {
      String errorMessage = 'Signup failed. Please try again.';
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }
}
