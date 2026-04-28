import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/core/services/api_service.dart';
import 'package:rideiq/core/services/local_service.dart';


import 'package:rideiq/core/constants/api_constants.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
    required Function() onVerificationCompleted,
  });

  Future<UserCredential?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> verifyBackend({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  });

  Future<void> signOut();

  Future<void> deleteAccount();

  User? get currentUser;
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService;

  FirebaseAuthRepository(this._apiService);

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
    required Function() onVerificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        onVerificationCompleted();
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<UserCredential?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyBackend({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyAuth,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'firebase_token': token,
          'role': role.toLowerCase(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['status'] == true && response.data['data'] != null) {
        final backendToken = response.data['data']['token'];
        if (backendToken != null) {
          await LocalService.setAuthToken(backendToken);
        }
      }

    } catch (e) {
      if (e is DioException) {
        print("Backend Error Details: ${e.response?.data}");
      }
      rethrow;
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FirebaseAuthRepository(apiService);
}
