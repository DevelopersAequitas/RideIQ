import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              title: 'Setting',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        r.s(20),
                        r.s(18),
                        r.s(20),
                        r.s(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: r.s(18)),
                          _SettingRow(
                            iconAsset: 'assets/icons/Translate.svg',
                            label: 'Language',
                            value: 'English',
                            onTap: () {},
                          ),
                          SizedBox(height: r.s(8)),
                          _SettingRow(
                            iconAsset: 'assets/icons/CarProfile.svg',
                            label: 'Default Ride',
                            value: 'Comfort',
                            onTap: () {},
                          ),
                          SizedBox(height: r.s(10)),
                          Container(height: 1, color: AppColors.borderSecondary),
                          SizedBox(height: r.s(10)),
                          _SettingRow(
                            iconAsset: 'assets/icons/Trash.svg',
                            label: 'Delete Account',
                            value: null,
                            destructive: true,
                            onTap: () {},
                          ),
                          const Spacer(),
                        ],
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
              SizedBox(width: r.s(14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.onTap,
    this.destructive = false,
  });

  final String iconAsset;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final fg = destructive ? AppColors.accentRed : AppColors.textPrimary;
    final valueFg = destructive ? AppColors.accentRed : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.s(14)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(4), vertical: r.s(12)),
          child: Row(
            children: [
              SizedBox(
                width: r.s(22),
                height: r.s(22),
                child: SvgPicture.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: r.s(12)),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: r.s(14),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: TextStyle(
                    color: valueFg,
                    fontSize: r.s(12),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(width: r.s(8)),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: r.s(18),
                  color: valueFg,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

