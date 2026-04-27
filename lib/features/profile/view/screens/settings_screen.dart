import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/features/profile/view/widgets/settings_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          "Setting",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),

            // Language Selection
            SettingDropdownItem(
              assetPath: AppAssets.translateSvg,
              label: "Language",
              value: "English",
              onTap: () {},
            ),

            // Default Ride Selection
            SettingDropdownItem(
              assetPath: AppAssets.carProfileSettingSvg,
              label: "Default Ride",
              value: "Comfort",
              onTap: () {},
            ),

            const Divider(color: Color(0xFFF2F2F2)),

            // Delete Account
            SettingActionItem(
              assetPath: AppAssets.trashSvg,
              label: "Delete Account",
              onTap: () {},
            ),
          ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
        ),
      ),
    );
  }
}
