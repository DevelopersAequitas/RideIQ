import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/views/profile/link_platform_sync_screen.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

class LinkPlatformOtpScreen extends StatefulWidget {
  const LinkPlatformOtpScreen({
    super.key,
    required this.platformName,
  });

  final String platformName;

  @override
  State<LinkPlatformOtpScreen> createState() => _LinkPlatformOtpScreenState();
}

class _LinkPlatformOtpScreenState extends State<LinkPlatformOtpScreen> {
  int _bottomIndex = 0;

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.isEmpty) {
      if (i > 0) _nodes[i - 1].requestFocus();
      return;
    }
    if (v.length > 1) {
      _controllers[i].text = v.characters.last;
      _controllers[i].selection = TextSelection.collapsed(
        offset: _controllers[i].text.length,
      );
    }
    if (i < _nodes.length - 1) {
      _nodes[i + 1].requestFocus();
    } else {
      _nodes[i].unfocus();
    }
  }

  InputDecoration _boxDecoration(BuildContext context) {
    final r = context.r;
    final radius = BorderRadius.circular(r.s(10));
    final side = BorderSide(color: AppColors.borderSecondary, width: 1);
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      counterText: '',
      border: OutlineInputBorder(borderRadius: radius, borderSide: side),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: side),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.borderPrimary, width: 1),
      ),
      contentPadding: EdgeInsets.zero,
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
                      SizedBox(width: r.s(10)),
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
                        r.s(25),
                        r.s(25),
                        r.s(20),
                        r.s(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _CircleLogo(
                                bg: const Color(0xFF111111),
                                child: Text(widget.platformName),
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
                          SizedBox(height: r.s(28)),
                          Text(
                            'Enter verification code',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.s(12),
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: r.s(24)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (i) {
                              return SizedBox(
                                width: r.s(44),
                                height: r.s(44),
                                child: TextField(
                                  controller: _controllers[i],
                                  focusNode: _nodes[i],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: _boxDecoration(context),
                                  onChanged: (v) => _onChanged(i, v),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: r.s(28)),
                          RidePrimaryButton(
                            label: 'Verify',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => LinkPlatformSyncScreen(
                                    platformName: widget.platformName,
                                  ),
                                ),
                              );
                            },
                            minimumHeight: 52,
                            borderRadius: 14,
                            showBorder: false,
                          ),
                          SizedBox(height: r.s(30)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: r.s(16),
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(width: r.s(10)),
                              Expanded(
                                child: Text(
                                  'We only read earnings data. We never modify your\naccount.',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: r.s(11),
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
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

