import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome_viewmodel.g.dart';

@riverpod
class WelcomeViewModel extends _$WelcomeViewModel {
  @override
  void build() {
    // Initial state if needed
  }

  void onLoginPressed() {
    // Navigate to Login (handled in View)
  }

  void onSignUpPressed() {
    // Navigate to Create Account (handled in View)
  }
}
