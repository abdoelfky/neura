import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:neura/core/common/routes.dart';
import 'package:neura/core/storage/shared_prefs.dart';
import 'package:neura/features/auth/data/auth_model.dart';
import 'package:neura/features/auth/data/auth_repo.dart';


final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<AuthModel?>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<AuthModel?>> {
  final Ref ref;
  AuthController(this.ref) : super(const AsyncValue.data(null));

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authModel = await ref.read(authRepositoryProvider).loginUser(
        email: email,
        password: password,
      );

      await SharedPrefs.saveUser(authModel);

      state = AsyncValue.data(authModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful")),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } on DioError catch (e) {
      final error = e.response?.data;
      final errorMessage =
      error is Map && error['message'] != null ? error['message'] : 'Login failed. Please try again.';

      state = AsyncValue.error(errorMessage, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      final fallback = 'Unexpected error: $e';
      state = AsyncValue.error(fallback, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fallback)),
      );
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
