import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:truv_flutter/truv_event.dart';
import 'package:truv_flutter/truv_flutter.dart';
import 'package:rideiq/l10n/app_localizations.dart';
import 'package:rideiq/core/utils/app_logger.dart';
import 'package:rideiq/features/profile/view/screens/link_syncing_screen.dart';
import 'package:rideiq/core/services/local_service.dart';

class DriverVerificationScreen extends ConsumerStatefulWidget {
  final String platformName;

  const DriverVerificationScreen({super.key, required this.platformName});

  @override
  ConsumerState<DriverVerificationScreen> createState() =>
      _DriverVerificationScreenState();
}

class _DriverVerificationScreenState
    extends ConsumerState<DriverVerificationScreen> {
  final bool _isVerified = false;
  String? _bridgeToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartVerification();
    });
  }

  void _checkAndStartVerification() async {
    AppLogger.info(
      'Checking for cached bridge token...',
      tag: 'DriverVerification',
    );
    final cachedToken = await LocalService.getBridgeToken();

    if (cachedToken != null) {
      AppLogger.info('Using cached bridge token', tag: 'DriverVerification');
      setState(() {
        _bridgeToken = cachedToken;
      });
    } else {
      AppLogger.info(
        'No cached token, requesting new one...',
        tag: 'DriverVerification',
      );
      _startTruvVerification();
    }
  }

  void _startTruvVerification() async {
    final viewModel = ref.read(truvViewModelProvider.notifier);
    final token = await viewModel.createBridgeToken(platformName: widget.platformName);
    if (token != null && mounted) {
      setState(() {
        _bridgeToken = token;
      });
    }
  }

  void _handleTruvEvent(TruvEvent event) async {
    AppLogger.info('Truv Event received: $event', tag: 'DriverVerification');

    if (event is TruvEventSuccess) {
      final publicToken = event.publicToken;
      AppLogger.info(
        'Truv Success! Public Token: $publicToken',
        tag: 'DriverVerification',
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LinkSyncingScreen(
              platformName: widget.platformName,
              isDriverMode: true,
              publicToken: publicToken,
            ),
          ),
        );
      }
    } else if (event is TruvEventClose) {
      AppLogger.info('Truv Bridge Closed', tag: 'DriverVerification');
      if (mounted) {
        // Just go back so user can try again, don't show syncing animation
        Navigator.pop(context);
      }
    } else if (event is TruvEventError) {
      AppLogger.error(
        'Truv Error: ${event.toString()}',
        tag: 'DriverVerification',
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_bridgeToken != null) {
      return Scaffold(
        body: SafeArea(
          child: TruvBridge(
            bridgeToken: _bridgeToken!,
            onEvent: _handleTruvEvent,
          ),
        ),
      );
    }

    final isLoading = ref.watch(truvViewModelProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.driver_verification_title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              l10n.verify_income_title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                fontFamily: 'Figtree',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.verify_income_subtitle,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF666666),
                height: 1.5,
                fontFamily: 'Figtree',
              ),
            ),
            SizedBox(height: 60.h),
            if (_isVerified)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F5),
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(color: const Color(0xFF1ABC9C)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF1ABC9C)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        l10n.income_verified_success,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (isLoading || _bridgeToken == null)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Color(0xFF1E74E9)),
                    SizedBox(height: 20.h),
                    Text(
                      l10n.syncing,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF666666),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
