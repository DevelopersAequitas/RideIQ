import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default('+1') String countryCode,
    @Default('') String phoneNumber,
    @Default('') String otp,
    @Default(false) bool isOtpSent,
    @Default(60) int resendTimer,
    @Default(0) int resendAttempt,
    @Default(false) bool isLoading,
    @Default(false) bool isOtpLoading,
    @Default(false) bool isLoginLoading,
    String? errorMessage,
    String? verificationId,
    int? resendToken,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default('driver') String userType,
    @Default(false) bool locationGranted,
    @Default(false) bool notificationsGranted,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}
