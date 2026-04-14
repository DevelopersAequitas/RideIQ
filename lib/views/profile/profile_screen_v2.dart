import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/views/profile/link_platform_screen.dart';
import 'package:rideiq/views/profile/settings_screen.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            _TopBar(
              title: 'Profile',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: Transform.translate(
                      offset: Offset(0, -r.s(14)),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          r.s(20),
                          r.s(18),
                          r.s(20),
                          r.s(18) + r.s(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          _UserHeader(
                            onOpenSettings: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: r.s(36)),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Rides',
                                  value: '126',
                                  icon: Icons.directions_car_filled_outlined,
                                ),
                              ),
                              SizedBox(width: r.s(12)),
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Spent',
                                  value: r'$1,842',
                                  icon: Icons.payments_outlined,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.s(12)),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Frequent Location',
                                  value: 'Downtown, LA',
                                  icon: Icons.location_on_outlined,
                                ),
                              ),
                              SizedBox(width: r.s(12)),
                              Expanded(
                                child: _StatCard(
                                  title: 'Avg Ride Time',
                                  value: '18 mins',
                                  icon: Icons.access_time_outlined,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.s(24)),
                          Text(
                            'Linked Accounts',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.s(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: r.s(20)),
                          const _LinkedAccountsCard(),
                          SizedBox(height: r.s(12)),
                          Container(height: 1, color: AppColors.borderSecondary),
                          SizedBox(height: r.s(12)),
                          _HelpCenterRow(onTap: () {}),
                          SizedBox(height: r.s(6)),
                          _MenuRow(
                            iconAsset: 'assets/icons/FileText.svg',
                            label: 'Privecy policy',
                            onTap: () {},
                          ),
                          _MenuRow(
                            iconAsset: 'assets/icons/WarningCircle.svg',
                            label: 'Report',
                            onTap: () {},
                          ),
                          _MenuRow(
                            iconAsset: 'assets/icons/Headset.svg',
                            label: 'About us',
                            onTap: () {},
                          ),
                          _MenuRow(
                            iconAsset: 'assets/icons/setting.svg',
                            label: 'Log out',
                            onTap: () {},
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BottomRoleBar(
              selectedIndex: _bottomIndex,
              onSelect: (i) => setState(() => _bottomIndex = i),
              accentColor: const Color(0xFF2D60FF),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: r.s(52),
          height: r.s(52),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/images/Profilepicture.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        SizedBox(width: r.s(12)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: r.s(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ethan Carter',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.s(14),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  'ethancarter@gmail.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.s(11),
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  '+1 555-0123',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onOpenSettings,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(r.s(10)),
              child: SvgPicture.asset(
                'assets/icons/setting.svg',
                width: r.s(20),
                height: r.s(20),
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final topPad = MediaQuery.paddingOf(context).top;

    return Material(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.only(top: topPad),
        child: SizedBox(
          height: r.s(46),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(r.s(14)),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: r.s(18),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.s(6)),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.s(16),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(width: r.s(14)), // right padding symmetry
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      height: r.s(78),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.s(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(r.s(14), r.s(12), r.s(14), r.s(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: r.s(10.5),
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                icon,
                size: r.s(16),
                color: const Color(0xFF2D60FF),
              ),
              SizedBox(width: r.s(8)),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.s(13),
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkedAccountsCard extends StatelessWidget {
  const _LinkedAccountsCard();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.s(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _LinkedAccountTile(
            leading: const _CircleLogo(
              bg: Color(0xFF2D60FF),
              child: Text('A'),
            ),
            title: 'AYRO',
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check, size: 14, color: Color(0xFF34C759)),
                SizedBox(width: 6),
                Text('Connected'),
              ],
            ),
            subtitleColor: const Color(0xFF34C759),
            actionLabel: 'Disconnect',
            actionColor: const Color(0xFFFF3B30),
          ),
          _LinkedAccountDivider(indent: r.s(56)),
          _LinkedAccountTile(
            leading: _CircleLogo(
              bg: Color(0xFF111111),
              child: Text('Uber'),
            ),
            title: 'Uber',
            subtitle: null,
            subtitleColor: null,
            actionLabel: 'Re-sync',
            actionColor: Color(0xFF2D60FF),
            onActionTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LinkPlatformScreen(platformName: 'Uber'),
                ),
              );
            },
          ),
          _LinkedAccountDivider(indent: r.s(56)),
          _LinkedAccountTile(
            leading: _CircleLogo(
              bg: Color(0xFFEA2D8C),
              child: Text('lyft'),
            ),
            title: 'Lyft',
            subtitle: null,
            subtitleColor: null,
            actionLabel: 'Link',
            actionColor: Color(0xFF2D60FF),
            onActionTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LinkPlatformScreen(platformName: 'Lyft'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LinkedAccountDivider extends StatelessWidget {
  const _LinkedAccountDivider({required this.indent});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(height: 1, color: AppColors.borderSecondary),
    );
  }
}

class _LinkedAccountTile extends StatelessWidget {
  const _LinkedAccountTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.actionLabel,
    required this.actionColor,
    this.onActionTap,
  });

  final Widget leading;
  final String title;
  final Widget? subtitle;
  final Color? subtitleColor;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
      child: Row(
        children: [
          SizedBox(width: r.s(34), height: r.s(34), child: leading),
          SizedBox(width: r.s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.s(14),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: r.s(4)),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: subtitleColor ?? AppColors.textSecondary,
                      fontSize: r.s(11),
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(r.s(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: r.s(6), vertical: r.s(6)),
                child: Text(
                  actionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: actionColor,
                    fontSize: r.s(12),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
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

class _HelpCenterRow extends StatelessWidget {
  const _HelpCenterRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.s(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(4), vertical: r.s(10)),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: r.s(16),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: r.s(10)),
              Text(
                'Help Center',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: r.s(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.s(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(4), vertical: r.s(10)),
          child: Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                width: r.s(16),
                height: r.s(16),
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: r.s(10)),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.s(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleLogo extends StatelessWidget {
  const _CircleLogo({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return DecoratedBox(
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontSize: r.s(10),
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

