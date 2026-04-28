import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/features/profile/repository/profile_repository.dart';
import 'package:rideiq/features/profile/viewmodel/profile_state.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    // Initial fetch when the viewmodel is created
    Future.microtask(() => fetchProfile());
    return const ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(profileRepositoryProvider);
      final userData = await repository.fetchProfile();
      if (userData != null) {
        state = state.copyWith(isLoading: false, userData: userData, errorMessage: null);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Failed to load profile");
      }
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
      final repository = ref.read(profileRepositoryProvider);
      final userData = await repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      if (userData != null) {
        state = state.copyWith(isLoading: false, userData: userData, errorMessage: null);
        return true;
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Failed to update profile");
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
