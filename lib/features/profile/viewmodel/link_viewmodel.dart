import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'link_viewmodel.g.dart';

enum LinkSyncStep { none, syncing, success }

class LinkState {
  final String countryCode;
  final String phone;
  final String license;
  final String otp;
  final String email;
  final String password;
  final bool isLoading;
  final LinkSyncStep syncStep;

  LinkState({
    this.countryCode = "+1",
    this.phone = "",
    this.license = "",
    this.otp = "",
    this.email = "",
    this.password = "",
    this.isLoading = false,
    this.syncStep = LinkSyncStep.none,
  });

  String get fullPhone => "$countryCode$phone";
  
  bool get isPlatformValid => phone.length >= 8;
  bool get isDriverPlatformValid => phone.length >= 8 && license.isNotEmpty;
  bool get isOtpValid => otp.length >= 6;
  bool get isUberValid => email.isNotEmpty && password.length >= 4;

  LinkState copyWith({
    String? countryCode,
    String? phone,
    String? license,
    String? otp,
    String? email,
    String? password,
    bool? isLoading,
    LinkSyncStep? syncStep,
  }) {
    return LinkState(
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      license: license ?? this.license,
      otp: otp ?? this.otp,
      email: email ?? this.email,
      password: password ?? this.password,
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
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updatePassword(String password) => state = state.copyWith(password: password);

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
        
        final verificationStatus = status?['verification_status'];
        if (status != null && (verificationStatus == 'connected' || verificationStatus == 'verified') && ref.mounted) {
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

  Future<void> checkTruvStatusOnly() async {
    state = state.copyWith(syncStep: LinkSyncStep.syncing);
    
    try {
      final truvNotifier = ref.read(truvViewModelProvider.notifier);
      
      // Retry mechanism: Poll the status up to 5 times with a 3-second delay
      // This prevents immediate "failure" if the backend is still processing
      int retryCount = 0;
      bool isConnected = false;

      while (retryCount < 5 && !isConnected && ref.mounted) {
        final status = await truvNotifier.checkStatus();
        final verificationStatus = status?['verification_status'];
        
        if (status != null && (verificationStatus == 'connected' || verificationStatus == 'verified')) {
          isConnected = true;
          await truvNotifier.fetchReport();
          if (ref.mounted) {
            state = state.copyWith(syncStep: LinkSyncStep.success);
            return;
          }
        } else {
          retryCount++;
          if (retryCount < 5) {
            await Future.delayed(const Duration(seconds: 3));
          }
        }
      }
      
      if (ref.mounted && !isConnected) {
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

