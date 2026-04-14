import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/views/profile/link_platform_otp_screen.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

class LinkPlatformScreen extends StatefulWidget {
  const LinkPlatformScreen({
    super.key,
    required this.platformName,
  });

  final String platformName;

  @override
  State<LinkPlatformScreen> createState() => _LinkPlatformScreenState();
}

class _LinkPlatformScreenState extends State<LinkPlatformScreen> {
  int _bottomIndex = 0;

  bool get _isLyft => widget.platformName.trim().toLowerCase() == 'lyft';
  bool get _isUber => widget.platformName.trim().toLowerCase() == 'uber';

  Color get _platformBgColor {
    if (_isLyft) return const Color(0xFFEA2D8C);
    if (_isUber) return const Color(0xFF111111);
    return const Color(0xFF111111);
  }

  String get _platformBadgeText {
    if (_isLyft) return 'lyft';
    return widget.platformName;
  }

  InputDecoration _decoration(BuildContext context, {required String hintText}) {
    final r = context.r;
    final baseSide = BorderSide(color: AppColors.borderSecondary, width: 1);
    final focusedSide = BorderSide(color: AppColors.borderPrimary, width: 1);
    final radius = BorderRadius.circular(r.s(12));

    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: r.s(14),
        vertical: r.s(14),
      ),
      hintStyle: TextStyle(
        color: AppColors.textTertiary,
        fontSize: r.s(12.5),
        fontWeight: FontWeight.w500,
      ),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: baseSide),
      border: OutlineInputBorder(borderRadius: radius, borderSide: baseSide),
      focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: focusedSide),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final topPad = MediaQuery.paddingOf(context).top;

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
            Material(
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
                          onTap: () => Navigator.of(context).pop(),
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
                          'Link Platform',
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
            ),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        r.s(20),
                        r.s(22),
                        r.s(20),
                        r.s(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _CircleLogo(
                                bg: _platformBgColor,
                                child: Text(_platformBadgeText),
                              ),
                              SizedBox(width: r.s(14)),
                              Expanded(
                                child: Text(
                                  widget.platformName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: r.s(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.s(22)),
                          TextField(
                            decoration: _decoration(
                              context,
                              hintText: 'Phone',
                            ),
                          ),
                          SizedBox(height: r.s(18)),
                          RidePrimaryButton(
                            label: 'Continue',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => LinkPlatformOtpScreen(
                                    platformName: widget.platformName,
                                  ),
                                ),
                              );
                            },
                            minimumHeight: 52,
                            borderRadius: 14,
                            showBorder: false,
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

class _CircleLogo extends StatelessWidget {
  const _CircleLogo({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      width: r.s(44),
      height: r.s(44),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontSize: r.s(10),
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
        child: child,
      ),
    );
  }
}

