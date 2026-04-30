import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/features/profile/repository/profile_repository.dart';
import 'package:rideiq/features/profile/viewmodel/profile_state.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    Future.microtask(() => fetchProfile());
    return const ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final userData = await ref.read(profileRepositoryProvider).fetchProfile();
      state = state.copyWith(isLoading: false, userData: userData, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final userData = await ref.read(profileRepositoryProvider).updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      if (userData != null) {
        state = state.copyWith(isLoading: false, userData: userData, errorMessage: null);
        return true;
      }
      state = state.copyWith(isLoading: false, errorMessage: "Update failed");
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
