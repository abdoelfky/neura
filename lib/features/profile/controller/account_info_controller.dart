import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/storage/shared_prefs.dart';
import '../data/account_info_repo.dart';
import '../data/profile_model.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

final profileControllerProvider = FutureProvider<ProfileModel>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  final token = await SharedPrefs.userTokenAsync;
  return repo.fetchProfile(token);
});

final accountInfoControllerProvider =
StateNotifierProvider<AccountInfoController, AsyncValue<void>>((ref) {
  return AccountInfoController(ref);
});

class AccountInfoController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AccountInfoController(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateName({
    required String firstName,
    required String lastName,
    required String token,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).changeName(
        firstName: firstName,
        lastName: lastName,
        token: token,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateEmail({
    required String email,
    required String token,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).changeEmail(
        email: email,
        token: token,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
