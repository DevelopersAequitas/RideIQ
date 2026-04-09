import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/theme/ride_typography.dart';
import 'package:rideiq/views/home/home_page.dart';
import 'package:rideiq/views/onboarding/allow_permissions_screen.dart';

/// "What brings you here?" — passenger vs driver cards with toggles (reference UI).
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  static const String _passengerImage = 'assets/images/Rider1.png';
  static const String _driverImage = 'assets/images/iam_driver.png';

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  /// Single selection: passenger (true) or driver (false). Default matches reference (passenger on).
  bool _isPassenger = true;

  static const double _hPad = 20;
  static const double _cardRadius = 16;
  static const double _overlayRadius = 14;
  static const double _cardGap = 16;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
                  'What brings you here?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _RoleCard(
                          imageAsset: RoleSelectionScreen._passengerImage,
                          title: "I'm a Passenger",
                          subtitle: 'Find cheapest ride fares',
                          selected: _isPassenger,
                          onToggle: (on) => setState(() => _isPassenger = on),
                          borderRadius: _cardRadius,
                          overlayRadius: _overlayRadius,
                        ),
                      ),
                      SizedBox(height: _cardGap),
                      Expanded(
                        child: _RoleCard(
                          imageAsset: RoleSelectionScreen._driverImage,
                          title: "I'm a Driver",
                          subtitle: 'Compare my earnings',
                          selected: !_isPassenger,
                          onToggle: (on) => setState(() => _isPassenger = !on),
                          borderRadius: _cardRadius,
                          overlayRadius: _overlayRadius,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () async {
                      final allowed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute<bool>(
                          builder: (_) => const AllowPermissionsScreen(),
                        ),
                      );
                      if (!context.mounted) return;
                      if (allowed == true) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const MyHomePage(title: 'RydeIQ'),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.ctaBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.ctaBlue.withOpacity(0.45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: RideTypography.buttonLabel.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 12 + bottomInset),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onToggle,
    required this.borderRadius,
    required this.overlayRadius,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onToggle;
  final double borderRadius;
  final double overlayRadius;

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Stack children must be [Positioned.fill] (or sized) or the image keeps
          // intrinsic size and won't fill the card.
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                final cw = (constraints.maxWidth * dpr).round().clamp(1, 4096);
                final ch = (constraints.maxHeight * dpr).round().clamp(1, 4096);
                return ColoredBox(
                  color: const Color(0xFFE8E8ED),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: cw,
                    cacheHeight: ch,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 40, color: AppColors.textTertiary),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(overlayRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title, style: _titleStyle),
                            const SizedBox(height: 4),
                            Text(subtitle, style: _subtitleStyle),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: selected,
                        activeTrackColor: AppColors.ctaBlue,
                        inactiveTrackColor: const Color(0xFFE5E5EA),
                        thumbColor: Colors.white,
                        onChanged: onToggle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
