import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class BillingToggle extends StatelessWidget {
  final bool isMonthly;
  final Function(bool) onToggle;

  const BillingToggle({
    super.key,
    required this.isMonthly,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Monthly Item
          _ToggleItem(
            label: l10n.paywall_monthly,
            active: isMonthly,
            onTap: () => onToggle(true),
          ),

          SizedBox(width: 10.w), // 10px gap between items
          // Yearly Item
          _ToggleItem(
            label: l10n.paywall_yearly,
            active: !isMonthly,
            onTap: () => onToggle(false),
            hasBadge: true,
            badgeText: l10n.paywall_save_percent,
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool hasBadge;
  final String? badgeText;

  const _ToggleItem({
    required this.label,
    required this.active,
    required this.onTap,
    this.hasBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
          left: 16.w,
          right: hasBadge ? 8.w : 16.w, // Adjust for badge space
        ),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.w),
          // "below border visible nd above not"
          border: active
              ? const Border(
                  bottom: BorderSide(
                    color: Color(
                      0x1A000000,
                    ), // Very subtle dark border (10% black)
                    width: 2,
                  ),
                )
              : null,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? Colors.black : const Color(0xFF666666),
                fontFamily: 'Figtree',
              ),
            ),
            if (hasBadge && badgeText != null) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7ED),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

