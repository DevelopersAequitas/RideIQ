import 'package:rideiq/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
    required Function() onVerificationCompleted,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Always succeed in mock mode
    onCodeSent("mock_verification_id", 123456);
  }

  @override
  Future<UserCredential?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Return null or throw if you want to test error states
    // For now, we simulate a successful login
    return null; // Note: In real app, we'd mock a UserCredential object if needed
  }
}

// Update the provider to allow easy swapping or overrides
final mockAuthRepositoryProvider = Provider<AuthRepository>((ref) => MockAuthRepository());
