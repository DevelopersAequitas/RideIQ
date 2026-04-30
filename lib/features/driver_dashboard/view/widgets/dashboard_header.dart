import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/notifications/view/screens/notifications_screen.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileViewModelProvider);
    final dashboardState = ref.watch(dashboardViewModelProvider);

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driver_dashboard_title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.driver_dashboard_subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (dashboardState.isDashboardActive) ...[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(AppAssets.bellSvg, width: 24.w),
                ),
                SizedBox(width: 8.w),
              ],
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfileScreen(isDriverMode: true),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 0.05);
                            const end = Offset.zero;
                            const curve = Curves.easeOutQuart;

                            var slideTween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var fadeTween = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeOut));

                            return SlideTransition(
                              position: animation.drive(slideTween),
                              child: FadeTransition(
                                opacity: animation.drive(fadeTween),
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 22.w,
                  backgroundColor: const Color(0xFF1E74E9),
                  child: Text(
                    profileState.initials,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ); // Copy your _buildHeader code here
  }
}
