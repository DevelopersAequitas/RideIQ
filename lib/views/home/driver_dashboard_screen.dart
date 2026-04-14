import 'package:flutter/material.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// First driver home for new users: platform link status + primary CTA.
/// Horizontal gutter matches rider home (`SelectLocationScreen` `_hPad` ≈ 20pt).
class DriverDashboardBody extends StatelessWidget {
  const DriverDashboardBody({
    super.key,
    required this.onAvatarTap,
    required this.onGoToDashboard,
    required this.onLinkUber,
    required this.onLinkLyft,
  });

  final VoidCallback onAvatarTap;
  final VoidCallback onGoToDashboard;
  final VoidCallback onLinkUber;
  final VoidCallback onLinkLyft;

  /// Same baseline as [SelectLocationScreen._hPad] for left/right alignment.
  static const double _horizontalGutter = 30;

  /// Top inset below [SafeArea], aligned with rider scroll top padding (`18`).
  static const double _topInset = 30;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final h = r.s(_horizontalGutter);
    return Padding(
      padding: EdgeInsets.fromLTRB(h, r.s(_topInset), h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Driver Dashboard',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.s(20),
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: r.s(4)),
                    Text(
                      "See what you're really earning.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: r.s(11),
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: r.s(8)),
              _DriverHeaderAvatar(onTap: onAvatarTap),
            ],
          ),
          SizedBox(height: r.s(20)),
          Column(
            children: [
              _DriverPlatformCard(
                leading: _AyroMark(size: r.s(48)),
                title: 'AYRO',
                status: _ConnectedRow(r: r),
              ),
              SizedBox(height: r.s(12)),
              _DriverPlatformCard(
                leading: _UberMark(size: r.s(48)),
                title: 'Uber',
                subtitleGrey: 'Not Linked',
                trailing: _LinkChip(label: 'Link', onTap: onLinkUber),
              ),
              SizedBox(height: r.s(12)),
              _DriverPlatformCard(
                leading: _LyftMark(size: r.s(48)),
                title: 'Lyft',
                subtitleGrey: 'Not Linked',
                trailing: _LinkChip(label: 'Link', onTap: onLinkLyft),
              ),
            ],
          ),
          SizedBox(height: r.s(28)),
          RidePrimaryButton(
            label: 'Go to Dashboard',
            onPressed: onGoToDashboard,
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            minimumHeight: 46,
            borderRadius: 14,
            labelFontSize: 15,
          ),
          SizedBox(height: r.s(12)),
        ],
      ),
    );
  }
}

class _ConnectedRow extends StatelessWidget {
  const _ConnectedRow({required this.r});

  final RideResponsive r;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_rounded,
          size: r.s(16),
          color: AppColors.driverConnectedGreen,
        ),
        SizedBox(width: r.s(6)),
        Text(
          'Connected',
          style: TextStyle(
            color: AppColors.driverConnectedGreen,
            fontSize: r.s(13),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _DriverPlatformCard extends StatelessWidget {
  const _DriverPlatformCard({
    required this.leading,
    required this.title,
    this.status,
    this.subtitleGrey,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final Widget? status;
  final String? subtitleGrey;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.s(14)),
        border: Border.all(color: AppColors.borderSecondary),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(10), r.s(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading,
            SizedBox(width: r.s(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.s(14),
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (status != null) ...[
                    SizedBox(height: r.s(4)),
                    status!,
                  ],
                  if (subtitleGrey != null) ...[
                    SizedBox(height: r.s(4)),
                    Text(
                      subtitleGrey!,
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: r.s(12),
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.s(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(6), vertical: r.s(6)),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.driverAccentBlue,
              fontSize: r.s(14),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _AyroMark extends StatelessWidget {
  const _AyroMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.driverAccentBlue,
      ),
      alignment: Alignment.center,
      child: Text(
        'A',
        style: TextStyle(
          color: AppColors.surface,
          fontSize: r.s(20),
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _UberMark extends StatelessWidget {
  const _UberMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.platformUberBlack,
        alignment: Alignment.center,
        // padding: EdgeInsets.all(r.s(11)),
        child: Image.asset(
          'assets/images/uber.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _LyftMark extends StatelessWidget {
  const _LyftMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.platformLyftMagenta,
        alignment: Alignment.center,
        // padding: EdgeInsets.all(r.s(10)),
        child: Image.asset(
          'assets/images/lyft.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _DriverHeaderAvatar extends StatelessWidget {
  const _DriverHeaderAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final avatarSize = r.s(44);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 2),
            image: const DecorationImage(
              image: AssetImage('assets/images/Profilepicture.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
