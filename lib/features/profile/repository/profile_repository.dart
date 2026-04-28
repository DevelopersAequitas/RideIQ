import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/core/services/api_service.dart';
import 'package:rideiq/core/constants/api_constants.dart';
import 'package:rideiq/core/services/local_service.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<Map<String, dynamic>?> fetchProfile() async {
    final token = await LocalService.getAuthToken();
    if (token == null) return null;

    try {
      final response = await _apiService.get(
        ApiConstants.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['status'] == true && response.data['data'] != null) {
        return response.data['data']['user'];
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final token = await LocalService.getAuthToken();
    if (token == null) return null;

    try {
      final response = await _apiService.post(
        ApiConstants.userProfileUpdate,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['status'] == true && response.data['data'] != null) {
        return response.data['data']['user'];
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProfileRepository(apiService);
}
