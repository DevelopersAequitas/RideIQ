import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class FareBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const FareBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            assetPath: currentIndex == 0 
                ? AppAssets.riderTabFilled 
                : AppAssets.riderTabOutlined,
            label: l10n.rider,
            isActive: currentIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _NavItem(
            assetPath: currentIndex == 1 
                ? AppAssets.driverTabFilled 
                : AppAssets.driverTabOutlined,
            label: l10n.driver,
            isActive: currentIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.assetPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF1D72DD) : const Color(0xFF999999);
    final isSvg = assetPath.endsWith('.svg');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSvg)
            SvgPicture.asset(
              assetPath,
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          else
            Image.asset(
              assetPath,
              width: 24.w,
              height: 24.w,
              color: color,
            ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }
}

