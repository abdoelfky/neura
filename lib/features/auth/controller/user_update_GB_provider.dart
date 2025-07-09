import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/api_constants.dart';
import 'package:neura/core/network/dio_helper.dart';
import 'package:neura/core/storage/shared_prefs.dart';

final userUpdateProvider =
    StateNotifierProvider<UserUpdateNotifier, AsyncValue<void>>((ref) {
  return UserUpdateNotifier();
});

class UserUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  UserUpdateNotifier() : super(const AsyncValue.data(null));

  Future<void> updateGenderAndBirthDate({
    required String userId,
    required String gender,
    required String birthDate,
  }) async {
    print(userId);
    print(gender);
    print(birthDate);
    print(SharedPrefs.userToken);
    state = const AsyncValue.loading();
    try {
      await DioHelper.patchData(
          url: '${ApiConstants.updateGender}/$userId',
          data: {'gender': gender},
          token: SharedPrefs.userToken);

      await DioHelper.patchData(
          url: '${ApiConstants.updateBirth}/$userId',
          data: {'birthDate': birthDate},
          token: SharedPrefs.userToken);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print(e.toString());
    }
  }
}
