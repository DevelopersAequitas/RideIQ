import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/features/profile/view/widgets/stat_card.dart';
import 'package:rideiq/features/profile/view/widgets/profile_menu_item.dart';
import 'package:rideiq/features/profile/view/screens/settings_screen.dart';
import 'package:rideiq/features/profile/view/screens/link_platform_screen.dart';
import 'package:rideiq/features/profile/view/widgets/logout_dialog.dart';
import 'package:rideiq/features/profile/view/screens/edit_profile_screen.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileViewModelProvider);

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
          l10n.profile,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // 1. User Info Header
              _buildUserHeader(context, profileState)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0, curve: Curves.easeOutQuad),

              SizedBox(height: 32.h),

              // 2. Flexible Stats Rows
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          assetPath: AppAssets.carProfileSvg,
                          label: l10n.total_rides,
                          value: "126",
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: StatCard(
                          assetPath: AppAssets.moneyWavySvg,
                          label: l10n.total_spent,
                          value: "\$1,842",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          assetPath: AppAssets.mapPinSvg,
                          label: l10n.frequent_location,
                          value: "Downtown, LA",
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: StatCard(
                          assetPath: AppAssets.clockCountdownSvg,
                          label: l10n.avg_ride_time,
                          value: "18 mins",
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

              SizedBox(height: 32.h),

              // 3. Linked Accounts Section
              Text(
                l10n.linked_accounts,
                style: TextStyle(
                  color: const Color(0xFF999999),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ).animate().fadeIn(delay: 300.ms),

              SizedBox(height: 16.h),

              _buildLinkedAccountsCard(
                context,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),

              SizedBox(height: 32.h),

              // 4. Menu List (Staggered Animations)
              Column(
                children:
                    [
                          ProfileMenuItem(
                            assetPath: AppAssets.headsetSvg,
                            label: l10n.help_center,
                            onTap: () {},
                          ),
                          ProfileMenuItem(
                            assetPath: AppAssets.fileTextSvg,
                            label: l10n.privacy_policy,
                            onTap: () {},
                          ),
                          ProfileMenuItem(
                            assetPath: AppAssets.warningCircleSvg,
                            label: l10n.report,
                            onTap: () {},
                          ),
                          ProfileMenuItem(
                            assetPath: AppAssets.infoSvg,
                            label: l10n.about_us,
                            onTap: () {},
                          ),
                          ProfileMenuItem(
                            assetPath: AppAssets.signOutSvg,
                            label: l10n.log_out,
                            isDestructive: true,
                            onTap: () => LogoutDialog.show(context, ref),
                          ),
                        ]
                        .animate(interval: 50.ms)
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.1, end: 0),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, profileState) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.w,
          backgroundColor: const Color(0xFF1E74E9),
          child: Text(
            profileState.initials,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Figtree',
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profileState.fullName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                        fontFamily: 'Figtree',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.edit,
                      size: 16.sp,
                      color: const Color(0xFF1E74E9),
                    ),
                  ],
                ),
                Text(
                  profileState.email,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
                Text(
                  profileState.phone,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: SvgPicture.asset(
            AppAssets.settingsSvg,
            width: 24.w,
            height: 24.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1A1A1A),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinkedAccountsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Column(
        children: [
          _buildAccountTile(context, "Uber", false, true),
          const Divider(height: 1, color: Color(0xFFF2F2F2)),
          _buildAccountTile(context, "Lyft", false, false),
          const Divider(height: 1, color: Color(0xFFF2F2F2)),
          _buildAccountTile(context, "Ayro", false, true),
        ],
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context,
    String name,
    bool isConnected,
    bool isUber,
  ) {
    final String logoAsset;
    if (name == "Uber") {
      logoAsset = AppAssets.uberLogoPng;
    } else if (name == "Lyft") {
      logoAsset = AppAssets.lyftLogoPng;
    } else {
      logoAsset = AppAssets.ayroLogoPng;
    }

    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.sp),
            child: Container(
              height: 32.w,
              width: 32.w,
              color: name == "Lyft" ? const Color(0xFFFF00BF) : Colors.black,
              child: Image.asset(logoAsset, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
                if (isConnected)
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        l10n.connected,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isConnected) {
                _navigateToLink(context, name);
              }
            },
            child: Text(
              isConnected ? l10n.disconnect : l10n.link,
              style: TextStyle(
                color: isConnected
                    ? const Color(0xFFE53935)
                    : const Color(0xFF1D72DD),
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                fontFamily: 'Figtree',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLink(BuildContext context, String platform) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LinkPlatformScreen(platformName: platform, isDriverMode: false),
      ),
    );
  }
}
