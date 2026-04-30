import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_viewmodel.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  FutureOr<String> build() async {
    // 1. Initial delay for branding
    await Future.delayed(const Duration(milliseconds: 3200));

    // 2. Check Firebase Auth State
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      return AuthSteps.welcome;
    }

    // 3. If logged in, check where they left off
    final step = await LocalService.getAuthStep();
    
    // Default to home if logged in but step is missing/welcome
    if (step == null || step == AuthSteps.welcome) {
      return AuthSteps.home;
    }

    return step;
  }
}
