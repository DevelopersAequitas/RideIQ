import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_viewmodel.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  FutureOr<void> build() async {
    // Perform any initialization here (e.g., check auth status, load configs)
    await Future.delayed(const Duration(seconds: 3));
  }
}
