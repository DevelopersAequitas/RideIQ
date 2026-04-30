import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/widgets/permission_card.dart';
import 'package:rideiq/features/paywall/view/screens/paywall_screen.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class PermissionScreen extends ConsumerWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    // Auto-navigate when both are granted
    ref.listen(authViewModelProvider, (prev, next) {
      final wasGranted =
          (prev?.locationGranted ?? false) &&
          (prev?.notificationsGranted ?? false);
      final isGranted = next.locationGranted && next.notificationsGranted;

      if (isGranted && !wasGranted) {
        notifier.completePermissions();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                l10n.allow_permissions,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Figtree',
                ),
              ).animate().fade().slideX(begin: -0.1, end: 0),

              SizedBox(height: 48.h),

              PermissionCard(
                title: l10n.location,
                subtitle: l10n.location_subtitle,
                assetPath: AppAssets.mapPinSvg,
                isGranted: state.locationGranted,
                onTap: notifier.requestLocationPermission,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),

              SizedBox(height: 32.h),

              PermissionCard(
                title: l10n.notifications,
                subtitle: l10n.notifications_subtitle,
                assetPath: AppAssets.bellRingingSvg,
                isGranted: state.notificationsGranted,
                onTap: notifier.requestNotificationPermission,
              ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
