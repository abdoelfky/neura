// features/profile/controller/delete_account_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/common/api_constants.dart';

final deleteAccountControllerProvider = StateNotifierProvider<DeleteAccountController, AsyncValue<void>>((ref) {
  return DeleteAccountController();
});

class DeleteAccountController extends StateNotifier<AsyncValue<void>> {
  DeleteAccountController() : super(const AsyncValue.data(null));

  Future<void> deleteAccount({required String token}) async {
    state = const AsyncValue.loading();

    try {
      await DioHelper.deleteData(
        url: ApiConstants.deleteAccount,
        token: token,
      );

      state = const AsyncValue.data(null);
    } on DioError catch (e) {
      String message = 'Failed to delete account';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        message = e.response?.data['message'];
      }
      state = AsyncValue.error(message, StackTrace.current);
      throw message;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      throw e.toString();
    }
  }
}
