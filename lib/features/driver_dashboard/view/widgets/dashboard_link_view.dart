import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/profile/view/screens/link_platform_screen.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';

class DashboardLinkView extends ConsumerWidget {
  const DashboardLinkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(dashboardViewModelProvider.notifier);
    final truvState = ref.watch(truvViewModelProvider);
    final isUberConnected = truvState.isPlatformConnected("Uber");

    final isLyftConnected = truvState.isPlatformConnected("Lyft");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Uber",
            logo: AppAssets.uberLogoPng,
            isConnected: isUberConnected,
            status: isUberConnected ? l10n.connected : l10n.not_linked,
            l10n: l10n,
            ref: ref,
            onLinkTap: isUberConnected
                ? null
                : () => _openDriverLinkFlow(context, "Uber"),
          ),
          SizedBox(height: 16.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Lyft",
            logo: AppAssets.lyftLogoPng,
            isConnected: isLyftConnected,
            status: isLyftConnected ? l10n.connected : l10n.not_linked,
            l10n: l10n,
            ref: ref,
            onLinkTap: isLyftConnected
                ? null
                : () => _openDriverLinkFlow(context, "Lyft"),
          ),
          SizedBox(height: 16.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Ayro",
            logo: AppAssets.ayroLogoPng,
            isConnected: truvState.isPlatformConnected("Ayro"),
            status: truvState.isPlatformConnected("Ayro")
                ? l10n.connected
                : l10n.not_linked,
            l10n: l10n,
            ref: ref,
            onLinkTap: truvState.isPlatformConnected("Ayro")
                ? null
                : () => _openDriverLinkFlow(context, "Ayro"),
          ),

          SizedBox(height: 40.h),
          PrimaryButton(
            text: l10n.go_to_dashboard,
            onPressed: () => notifier.activateDashboard(),
          ),
        ],
      ).animate().fade().slideY(begin: 0.1),
    );
  }
}

  Widget _buildPlatformLinkCard({
    required BuildContext context,
    required String name,
    required String logo,
    required bool isConnected,
    required String status,
    required AppLocalizations l10n,
    required WidgetRef ref,
    VoidCallback? onLinkTap,
  }) {
    final isUber = name.toLowerCase() == "uber";
    final truvState = ref.watch(truvViewModelProvider);

    // Extract company name from report data if available
    String companyName = name;
    if (isConnected && truvState.reportData != null) {
      try {
        final employments =
            truvState.reportData!['data']['employments'] as List;
        if (employments.isNotEmpty) {
          companyName = employments[0]['company']['name'] ?? name;
        }
      } catch (_) {}
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.sp),
            child: Container(
              width: 48.w,
              height: 48.w,
              color: isUber ? Colors.black : const Color(0xFFFF00BF),
              child: Image.asset(logo, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? companyName : name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (isConnected)
                      Icon(
                        Icons.verified,
                        color: const Color(0xFF1ABC9C),
                        size: 14.sp,
                      ),
                    if (isConnected) SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        isConnected ? l10n.income_source_connected : status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isConnected
                              ? const Color(0xFF1ABC9C)
                              : const Color(0xFF999999),
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  ],
                ),
                if (isConnected) ...[
                  SizedBox(height: 2.h),
                  Text(
                    l10n.verified_employer,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF999999),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isConnected && onLinkTap != null)
            TextButton(
              onPressed: onLinkTap,
              child: Text(
                l10n.link_btn,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E74E9),
                ),
              ),
            )
          else if (isConnected)
            Icon(
              Icons.check_circle,
              color: const Color(0xFF1ABC9C),
              size: 24.sp,
            ),
        ],
      ),
    );
  }

  void _openDriverLinkFlow(BuildContext context, String platformName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LinkPlatformScreen(platformName: platformName, isDriverMode: true),
      ),
    );
  }
