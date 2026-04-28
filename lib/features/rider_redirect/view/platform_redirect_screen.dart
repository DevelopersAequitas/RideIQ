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
  ConsumerState<PlatformRedirectScreen> createState() => _PlatformRedirectScreenState();
}

class _PlatformRedirectScreenState extends ConsumerState<PlatformRedirectScreen> with TickerProviderStateMixin {
  double _progress = 0.0;
  bool _isChecking = true;
  final bool _isInstalled = true; // Mock: set to false to test the "Not Installed" UI
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
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
        // In a real app, we would use url_launcher or device_apps to check installation
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedLogo(),
                  SizedBox(height: 48.h),
                  _buildStatusText(context),
                  if (_isChecking) ...[
                    SizedBox(height: 40.h),
                    _buildCancelButton(context),
                  ],
                ],
              ),
            ),
            if (!_isChecking && !_isInstalled) _buildNotInstalledFooter(context),
            if (!_isChecking && _isInstalled) _buildInstalledFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Progress Circle
        SizedBox(
          width: 140.w,
          height: 140.w,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 4.w,
            backgroundColor: const Color(0xFFF2F2F2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E74E9)),
          ),
        ),
        // Platform Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(30.sp),
          child: Container(
            width: 110.w,
            height: 110.w,
            color: widget.platformName == "Uber" ? Colors.black : const Color(0xFFFF00BF),
            padding: EdgeInsets.all(20.w),
            child: Image.asset(
              widget.logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),
        ),
        // Warning Badge for "Not Installed" state
        if (!_isChecking && !_isInstalled)
          Positioned(
            right: 5.w,
            top: 5.w,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8E8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.priority_high, color: Colors.red, size: 20.sp),
            ).animate().scale(),
          ),
      ],
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStatusText(BuildContext context) {
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
            color: const Color(0xFF666666),
            height: 1.5,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildCancelButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(120.w, 54.h),
        side: const BorderSide(color: Color(0xFFF2F2F2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
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

  Widget _buildNotInstalledFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      bottom: 40.h,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined),
          label: Text(l10n.install_platform(widget.platformName)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E74E9),
            elevation: 0,
            side: const BorderSide(color: Color(0xFFF2F2F2)),
            minimumSize: Size(200.w, 54.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildInstalledFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      bottom: 40.h,
      left: 24.w,
      right: 24.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.app_not_installed_question,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined, size: 20),
            label: Text(l10n.install_platform(widget.platformName)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFF2F2F2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}

