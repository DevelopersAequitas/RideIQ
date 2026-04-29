import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'link_viewmodel.g.dart';

enum LinkSyncStep { none, syncing, success }

class LinkState {
  final String countryCode;
  final String phone;
  final String license;
  final String otp;
  final bool isLoading;
  final LinkSyncStep syncStep;

  LinkState({
    this.countryCode = "+1",
    this.phone = "",
    this.license = "",
    this.otp = "",
    this.isLoading = false,
    this.syncStep = LinkSyncStep.none,
  });

  String get fullPhone => "$countryCode$phone";
  
  bool get isPlatformValid => phone.length >= 8;
  bool get isDriverPlatformValid => phone.length >= 8 && license.isNotEmpty;
  bool get isOtpValid => otp.length >= 6;

  LinkState copyWith({
    String? countryCode,
    String? phone,
    String? license,
    String? otp,
    bool? isLoading,
    LinkSyncStep? syncStep,
  }) {
    return LinkState(
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      license: license ?? this.license,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      syncStep: syncStep ?? this.syncStep,
    );
  }
}

@riverpod
class LinkViewModel extends _$LinkViewModel {
  @override
  LinkState build() {
    // Keep provider alive while we are in the linking flow
    // ref.keepAlive(); 
    return LinkState();
  }

  void updateCountryCode(String code) => state = state.copyWith(countryCode: code);
  void updatePhone(String phone) => state = state.copyWith(phone: phone);
  void updateLicense(String license) => state = state.copyWith(license: license);
  void updateOtp(String otp) => state = state.copyWith(otp: otp);

  Future<bool> handleContinue() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    if (!ref.mounted) return false;
    state = state.copyWith(isLoading: false);
    return true;
  }

  Future<bool> handleConfirm() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    if (!ref.mounted) return false;
    state = state.copyWith(isLoading: false);
    return true;
  }

  Future<void> startSync() async {
    state = state.copyWith(syncStep: LinkSyncStep.syncing);
    
    // Mock 3-second sync
    await Future.delayed(const Duration(seconds: 3));
    
    // SAFETY CHECK: Only update state if the provider is still active
    if (ref.mounted) {
      state = state.copyWith(syncStep: LinkSyncStep.success);
    }
  }

  Future<void> startTruvSync(String publicToken) async {
    state = state.copyWith(syncStep: LinkSyncStep.syncing);
    
    try {
      final truvNotifier = ref.read(truvViewModelProvider.notifier);
      
      // 1. Exchange Token
      final success = await truvNotifier.exchangeToken(publicToken);
      
      if (success && ref.mounted) {
        // 2. Check Status
        final status = await truvNotifier.checkStatus();
        
        if (status != null && status['verification_status'] == 'connected' && ref.mounted) {
          // 3. Fetch Report (background)
          await truvNotifier.fetchReport();
          
          if (ref.mounted) {
            state = state.copyWith(syncStep: LinkSyncStep.success);
            return;
          }
        }
      }
      
      // If we reach here, something failed
      if (ref.mounted) {
        state = state.copyWith(syncStep: LinkSyncStep.none);
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(syncStep: LinkSyncStep.none);
      }
    }
  }

  void resetSync() => state = state.copyWith(syncStep: LinkSyncStep.none);
}

