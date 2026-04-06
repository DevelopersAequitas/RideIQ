import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';

/// Allow location + notifications — layout matched to onboarding reference.
class AllowPermissionsScreen extends StatefulWidget {
  const AllowPermissionsScreen({super.key});

  static const String _locationIcon = 'assets/icons/MapPin.svg';
  static const String _notificationIcon = 'assets/icons/BellRinging.svg';

  @override
  State<AllowPermissionsScreen> createState() => _AllowPermissionsScreenState();
}

class _AllowPermissionsScreenState extends State<AllowPermissionsScreen> {
  bool _locationOn = false;
  bool _notificationsOn = false;
  bool _didSchedulePop = false;

  static const double _hPad = 20;
  static const double _cardRadius = 14;
  static const Color _cardFill = Color(0xFFF5F5F5);

  void _onLocationChanged(bool value) {
    setState(() => _locationOn = value);
    _maybeProceedWhenBothOn();
  }

  void _onNotificationsChanged(bool value) {
    setState(() => _notificationsOn = value);
    _maybeProceedWhenBothOn();
  }

  void _maybeProceedWhenBothOn() {
    if (!_locationOn || !_notificationsOn || _didSchedulePop) return;
    _didSchedulePop = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Allow Permissions',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 32),
                _PermissionSection(
                  iconAsset: AllowPermissionsScreen._locationIcon,
                  title: 'Location',
                  caption: 'Used to detect pickup location',
                  value: _locationOn,
                  onChanged: _onLocationChanged,
                  cardRadius: _cardRadius,
                  cardFill: _cardFill,
                ),
                const SizedBox(height: 28),
                _PermissionSection(
                  iconAsset: AllowPermissionsScreen._notificationIcon,
                  title: 'Notifications',
                  caption: 'Used for fare alerts and driver insights',
                  value: _notificationsOn,
                  onChanged: _onNotificationsChanged,
                  cardRadius: _cardRadius,
                  cardFill: _cardFill,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionSection extends StatelessWidget {
  const _PermissionSection({
    required this.iconAsset,
    required this.title,
    required this.caption,
    required this.value,
    required this.onChanged,
    required this.cardRadius,
    required this.cardFill,
  });

  final String iconAsset;
  final String title;
  final String caption;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double cardRadius;
  final Color cardFill;

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle _captionStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconAsset,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: _titleStyle),
                ),
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: AppColors.ctaBlue,
                  inactiveTrackColor: const Color(0xFFE5E5EA),
                  thumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(caption, style: _captionStyle),
      ],
    );
  }
}
