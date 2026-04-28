import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/features/auth/repository/auth_repository.dart';
import 'package:rideiq/features/auth/viewmodel/auth_state.dart';
import 'package:rideiq/core/services/local_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  Timer? _timer;

  @override
  AuthState build() {
    ref.onDispose(() => _timer?.cancel());
    return const AuthState();
  }

  void updateCountryCode(String code) {
    state = state.copyWith(countryCode: code);
  }

  void updatePhoneNumber(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  void updateLastName(String value) {
    state = state.copyWith(lastName: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateUserType(String type) {
    state = state.copyWith(userType: type);
  }

  Future<void> completeRegistration() async {
    await LocalService.setAuthStep(AuthSteps.userType);
  }

  Future<void> completeUserSelection() async {
    await LocalService.setAuthStep(AuthSteps.permissions);
  }

  Future<void> completePermissions() async {
    await LocalService.setAuthStep(AuthSteps.paywall);
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    state = state.copyWith(locationGranted: status.isGranted);
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    state = state.copyWith(notificationsGranted: status.isGranted);
  }

  Future<void> sendOtp() async {
    if (state.phoneNumber.isEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final fullPhone = '${state.countryCode}${state.phoneNumber}';
    
    try {
      await ref.read(authRepositoryProvider).verifyPhoneNumber(
        phoneNumber: fullPhone,
        onCodeSent: (verificationId, resendToken) {
          state = state.copyWith(
            isLoading: false,
            isOtpSent: true,
            verificationId: verificationId,
            resendToken: resendToken,
            resendAttempt: state.resendAttempt + 1,
          );
          _startTimer();
        },
        onVerificationFailed: (message) {
          state = state.copyWith(isLoading: false, errorMessage: message);
        },
        onVerificationCompleted: () {
          state = state.copyWith(isLoading: false);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _startTimer() {
    _timer?.cancel();
    
    int seconds = 60;
    if (state.resendAttempt == 2) {
      seconds = 300; // 5 mins
    } else if (state.resendAttempt == 3) {
      seconds = 600; // 10 mins
    } else if (state.resendAttempt >= 4) {
      seconds = 900; // 15 mins
    }

    state = state.copyWith(resendTimer: seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendTimer > 0) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> login() async {
    if (state.otp.length < 6 || state.verificationId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final userCredential = await ref.read(authRepositoryProvider).signInWithOtp(
        verificationId: state.verificationId!,
        smsCode: state.otp,
      );

      if (userCredential != null && userCredential.user != null) {
        await LocalService.setAuthStep(AuthSteps.userType);
        state = state.copyWith(isLoading: false, isAuthenticated: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Invalid OTP");
    }
  }

  Future<void> syncWithBackend() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) throw Exception("User not logged in");

      // Force refresh token to ensure validity
      final token = await user.getIdToken(true);
      if (!ref.mounted) return;

      await ref.read(authRepositoryProvider).verifyBackend(
            token: token ?? '',
            firstName: state.firstName,
            lastName: state.lastName,
            email: state.email,
            role: state.userType,
          );
      
      if (!ref.mounted) return;

      await LocalService.setAuthStep(AuthSteps.permissions);
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      rethrow;
    }
  }


  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      await LocalService.clearAll();
      if (ref.mounted) {
        state = const AuthState();
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await LocalService.clearAll();
      if (ref.mounted) {
        state = const AuthState();
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

}
