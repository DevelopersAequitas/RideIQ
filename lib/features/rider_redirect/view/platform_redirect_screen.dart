import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class PlatformRedirectScreen extends ConsumerStatefulWidget {
  final String platformName;
  final String logoAsset;

  const PlatformRedirectScreen({
    super.key,
    required this.platformName,
    required this.logoAsset,
  });

  @override
  ConsumerState<PlatformRedirectScreen> createState() =>
      _PlatformRedirectScreenState();
}

class _PlatformRedirectScreenState extends ConsumerState<PlatformRedirectScreen>
    with TickerProviderStateMixin {
  double _progress = 0.0;
  bool _isChecking = true;
  final bool _isInstalled =
      false; // Set to false as requested to show "Not Installed" UI
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {
              _progress = _progressController.value;
            });
          });

    _startRedirectFlow();
  }

  void _startRedirectFlow() async {
    _progressController.forward();

    // 3 seconds mock sync
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Navigate back to the root (Rider Tab)
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              if (!_isChecking)
                Positioned(
                  top: 20.h,
                  left: 20.w,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedLogo(),
                      SizedBox(height: 48.h),
                      _buildStatusContent(context),
                      if (_isChecking) ...[
                        SizedBox(height: 40.h),
                        _buildCancelButton(context),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Progress Circle (Only shown during checking)
        if (_isChecking)
          SizedBox(
            width: 140.w,
            height: 140.w,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 4.w,
              backgroundColor: const Color(0xFFF2F2F2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1E74E9),
              ),
            ),
          ),
        // Platform Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(60.sp),
          child: Container(
            width: 110.w,
            height: 110.w,
            color:
                (widget.platformName == "Uber" || widget.platformName == "Ayro")
                    ? Colors.black
                    : const Color(0xFFFF00BF),
            child: Image.asset(
              widget.logoAsset,
              fit: BoxFit.contain,
              errorBuilder:
                  (_, __, ___) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
            ),
          ),
        ),
        // Warning Badge for "Not Installed" state (Matching Figma)
        if (!_isChecking && !_isInstalled)
          Positioned(
            right: 5.w,
            top: 5.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF0EF), // Light background for badge
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7655A), // Orange/Red badge
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          ),
      ],
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStatusContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String title = l10n.opening_platform(widget.platformName);
    String subtitle = l10n.locations_added;

    if (!_isChecking && !_isInstalled) {
      title = l10n.app_not_installed_title;
      subtitle = l10n.get_app_to_book(widget.platformName);
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            fontFamily: 'Figtree',
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            color: const Color(0xFF999999),
            height: 1.5,
            fontFamily: 'Figtree',
          ),
        ),
        if (!_isChecking && !_isInstalled) ...[
          SizedBox(height: 32.h),
          _buildInstallButton(context),
        ],
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildInstallButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  color: const Color(0xFF1E74E9),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  l10n.install_platform(widget.platformName),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E74E9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(120.w, 54.h),
        side: const BorderSide(color: Color(0xFFF2F2F2)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.w),
        ),
      ),
      child: Text(
        l10n.cancel,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
