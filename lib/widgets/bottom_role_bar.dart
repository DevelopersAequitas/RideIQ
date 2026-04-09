import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';

class BottomRoleBar extends StatelessWidget {
  const BottomRoleBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    this.accentColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  /// When set (e.g. profile reference `#2D60FF`), used for the active tab color.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: r.s(24),
            right: r.s(24),
            top: r.s(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 1, color: AppColors.borderSecondary),
              SizedBox(height: r.s(8)),
              Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      label: 'Rider',
                      assetPath: 'assets/icons/User.svg',
                      selected: selectedIndex == 0,
                      onTap: () => onSelect(0),
                      accentColor: accentColor,
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      label: 'Driver',
                      assetPath: 'assets/icons/Car.svg',
                      selected: selectedIndex == 1,
                      onTap: () => onSelect(1),
                      accentColor: accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
    this.accentColor,
  });

  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final active = accentColor ?? AppColors.ctaBlue;
    final color = selected ? active : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.s(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: r.s(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: r.s(17),
              child: SvgPicture.asset(
                assetPath,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            SizedBox(height: r.s(6)),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: r.s(12),
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

