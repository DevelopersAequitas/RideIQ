import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_viewmodel.g.dart';

class PaywallState {
  final bool isMonthly;
  const PaywallState({this.isMonthly = true});

  PaywallState copyWith({bool? isMonthly}) {
    return PaywallState(isMonthly: isMonthly ?? this.isMonthly);
  }
}

@riverpod
class PaywallViewModel extends _$PaywallViewModel {
  @override
  PaywallState build() => const PaywallState();

  void setMonthly(bool value) {
    state = state.copyWith(isMonthly: value);
  }

  void toggleBillingCycle() {
    state = state.copyWith(isMonthly: !state.isMonthly);
  }
}
