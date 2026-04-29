import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/features/profile/viewmodel/link_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class LinkSyncingScreen extends ConsumerWidget {
  final String platformName;
  final bool isDriverMode;
  final String? publicToken;

  const LinkSyncingScreen({
    super.key,
    required this.platformName,
    required this.isDriverMode,
    this.publicToken,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(linkViewModelProvider);
    final notifier = ref.read(linkViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    // Trigger sync once on build
    if (state.syncStep == LinkSyncStep.none) {
      if (publicToken != null) {
        Future.microtask(() => notifier.startTruvSync(publicToken!));
      } else {
        Future.microtask(() => notifier.startSync());
      }
    }


    final String logoAsset;
    if (platformName.toLowerCase() == "uber") {
      logoAsset = AppAssets.uberLogoPng;
    } else if (platformName.toLowerCase() == "lyft") {
      logoAsset = AppAssets.lyftLogoPng;
    } else {
      logoAsset = AppAssets.ayroLogoPng;
    }
    final isUber = platformName.toLowerCase() == "uber" || platformName.toLowerCase() == "ayro";
    final isSuccess = state.syncStep == LinkSyncStep.success;

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
          l10n.syncing,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Logo Section with Animated Progress Ring
            Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle with Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(60.sp),
                  child: Container(
                    height: 100.w,
                    width: 100.w,
                    color: isUber ? Colors.black : const Color(0xFFFF00BF),
                    child: Image.asset(logoAsset, fit: BoxFit.contain),
                  ),
                ),

                // Real Circular Progress Bar (Fills 0 to 1)
                if (!isSuccess)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return SizedBox(
                        height: 110.w,
                        width: 110.w,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 4,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1E74E9),
                          ),
                          backgroundColor: const Color(
                            0xFFF2F2F2,
                          ).withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),

                // Success Badge
                if (isSuccess)
                  Positioned(
                    top: 0,
                    right: 0,
                    child:
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: const Color(0xFF4CAF50),
                            size: 32.sp,
                          ),
                        ).animate().scale(
                          duration: 300.ms,
                          curve: Curves.easeOutBack,
                        ),
                  ),
              ],
            ),

            SizedBox(height: 48.h),

            // 2. Title Logic
            if (!isSuccess)
              Text(
                isDriverMode
                    ? l10n.pulling_ride_history
                    : l10n.connecting_to(platformName),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                  fontFamily: 'Figtree',
                ),
              ).animate().fade(),

            if (isSuccess)
              Text(
                l10n.platform_connected(platformName),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  fontFamily: 'Figtree',
                ),
              ).animate().fade().slideY(begin: 0.2),

            SizedBox(height: 24.h),

            // 3. Linear Progress Bar
            if (!isSuccess)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 6.h,
                            backgroundColor: const Color(0xFFF2F2F2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1E74E9),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Subtext logic
                    if (isDriverMode) ...[
                      Text(
                        l10n.found_trips,
                        style: TextStyle(
                          color: const Color(0xFF1E74E9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fade(delay: 1.seconds),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.estimated_sync_time,
                        style: TextStyle(
                          color: const Color(0xFF999999),
                          fontSize: 13.sp,
                        ),
                      ),
                    ] else
                      Text(
                        l10n.securely_syncing,
                        style: TextStyle(
                          color: const Color(0xFF999999),
                          fontSize: 13.sp,
                        ),
                      ),
                  ],
                ),
              ),

            // 4. Success Subtext
            if (isSuccess)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  l10n.trips_synced,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 14.sp,
                    fontFamily: 'Figtree',
                    height: 1.4,
                  ),
                ),
              ).animate().fade(delay: 200.ms),

            if (isSuccess) ...[
              SizedBox(height: 48.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: ElevatedButton(
                  onPressed: () {
                    // Reset state
                    notifier.resetSync();

                    // Smart Navigation back to relative home screen
                    // Pops back through Syncing -> Verification -> Link screen
                    Navigator.of(context).pop(); // Pop Syncing
                    Navigator.of(context).pop(); // Pop Verification
                    Navigator.of(context).pop(); // Pop Link Screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E74E9),
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.done,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fade(delay: 500.ms).scale(),
            ],
          ],
        ),
      ),
    );
  }
}

