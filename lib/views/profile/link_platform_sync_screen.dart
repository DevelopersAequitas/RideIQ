import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';

class LinkPlatformSyncScreen extends StatefulWidget {
  const LinkPlatformSyncScreen({
    super.key,
    required this.platformName,
  });

  final String platformName;

  @override
  State<LinkPlatformSyncScreen> createState() => _LinkPlatformSyncScreenState();
}

class _LinkPlatformSyncScreenState extends State<LinkPlatformSyncScreen> {
  int _bottomIndex = 0;
  double _progress = 0.0;
  bool _done = false;
  Timer? _timer;

  void _popLinkFlowToProfile() {
    final nav = Navigator.of(context);
    nav.pop();
    nav.pop();
    nav.pop();
  }

  void _handleBack() {
    if (_done) {
      _popLinkFlowToProfile();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 0.02).clamp(0.0, 1.0);
        if (_progress >= 1.0) {
          _done = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      child: PopScope(
        canPop: !_done,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_done) _popLinkFlowToProfile();
        },
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
                            onTap: _handleBack,
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
                          'Syncing',
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
                        r.s(24),
                        r.s(20),
                        r.s(16),
                      ),
                      child: _done ? _SuccessState(platformName: widget.platformName) : _SyncState(platformName: widget.platformName, progress: _progress),
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
      ),
    );
  }
}

bool _isLyftPlatform(String platformName) =>
    platformName.trim().toLowerCase() == 'lyft';

Color _platformLogoBg(String platformName) {
  if (_isLyftPlatform(platformName)) return const Color(0xFFEA2D8C);
  return const Color(0xFF111111);
}

String _platformLogoLabel(String platformName) {
  if (_isLyftPlatform(platformName)) return 'lyft';
  return platformName;
}

class _SyncState extends StatelessWidget {
  const _SyncState({required this.platformName, required this.progress});

  final String platformName;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final logoBg = _platformLogoBg(platformName);
    final logoLabel = _platformLogoLabel(platformName);

    return Column(
      children: [
        const Spacer(),
        SizedBox(
          width: r.s(96),
          height: r.s(96),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: r.s(96),
                height: r.s(96),
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: r.s(3.5),
                  backgroundColor: const Color(0xFFE6EEF9),
                  color: const Color(0xFF2D60FF),
                ),
              ),
              _CircleLogo(
                size: r.s(74),
                bg: logoBg,
                child: Text(logoLabel),
              ),
            ],
          ),
        ),
        SizedBox(height: r.s(22)),
        Text(
          'Connecting to $platformName...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: r.s(16),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        SizedBox(height: r.s(16)),
        ClipRRect(
          borderRadius: BorderRadius.circular(r.s(8)),
          child: SizedBox(
            width: r.s(220),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: r.s(6),
              backgroundColor: const Color(0xFFE9EEF7),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D60FF)),
            ),
          ),
        ),
        SizedBox(height: r.s(12)),
        Text(
          'Securely syncing your ride data.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: r.s(11),
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.platformName});

  final String platformName;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final logoBg = _platformLogoBg(platformName);
    final logoLabel = _platformLogoLabel(platformName);
    return Column(
      children: [
        const Spacer(),
        SizedBox(
          width: r.s(92),
          height: r.s(92),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: _CircleLogo(
                  size: r.s(74),
                  bg: logoBg,
                  child: Text(logoLabel),
                ),
              ),
              Positioned(
                right: r.s(8),
                top: r.s(2),
                child: Container(
                  width: r.s(22),
                  height: r.s(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFF34C759),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.check, size: r.s(14), color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: r.s(18)),
        Text(
          '$platformName Connected',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: r.s(16),
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        SizedBox(height: r.s(10)),
        Text(
          'Your rides are now synced with\nRYDE-IQ.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: r.s(11),
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _CircleLogo extends StatelessWidget {
  const _CircleLogo({
    required this.size,
    required this.bg,
    required this.child,
  });

  final double size;
  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontSize: r.s(11),
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
        child: child,
      ),
    );
  }
}

