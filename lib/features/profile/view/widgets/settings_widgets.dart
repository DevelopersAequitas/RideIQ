import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/utils/size_config.dart';

class SettingDropdownItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final String value;
  final VoidCallback onTap;

  const SettingDropdownItem({
    super.key,
    required this.assetPath,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF999999),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                  fontFamily: 'Figtree',
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: const Color(0xFF1A1A1A),
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingActionItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const SettingActionItem({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF999999),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingSwitchItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchItem({
    super.key,
    required this.assetPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 24.w,
            height: 24.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFF999999),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
                fontFamily: 'Figtree',
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF1E74E9),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }
}
