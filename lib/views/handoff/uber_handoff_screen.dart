import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/widgets/bottom_role_bar.dart';

class UberHandoffScreen extends StatefulWidget {
  const UberHandoffScreen({super.key});

  @override
  State<UberHandoffScreen> createState() => _UberHandoffScreenState();
}

class _UberHandoffScreenState extends State<UberHandoffScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _handoffTimer;

  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    _handoffTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const UberNotInstalledScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _handoffTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

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
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                      child: Column(
                        children: [
                          SizedBox(height: r.s(10)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _UberSpinner(controller: _controller),
                                SizedBox(height: r.s(26)),
                                Text(
                                  'Opening Uber',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: r.s(18),
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: r.s(6)),
                                Text(
                                  'Your pickup and drop location\nhave been added.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: r.s(12),
                                    fontWeight: FontWeight.w400,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(height: r.s(16)),
                                _GhostButton(
                                  label: 'Cancel',
                                  onTap: () {
                                    _handoffTimer?.cancel();
                                    Navigator.of(context).maybePop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: r.s(14)),
                            child: Row(
                              children: [
                                Text(
                                  'App not installed?',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: r.s(11),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                _InstallPill(
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _UberSpinner extends StatelessWidget {
  const _UberSpinner({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final size = r.s(74);

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SpinnerPainter(t: controller.value),
            child: Center(
              child: ClipOval(
                child: Container(
                  width: r.s(50),
                  height: r.s(50),
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    'Uber',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.s(14),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 3;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.ctaBlue;

    // Two arcs with a small gap, rotating.
    final base = -math.pi / 2 + t * 2 * math.pi;
    const sweep = math.pi * 0.65;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      base,
      sweep,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      base + math.pi,
      sweep * 0.55,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final radius = BorderRadius.circular(r.s(12));

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: AppColors.borderSecondary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(22), vertical: r.s(12)),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.s(12),
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _InstallPill extends StatelessWidget {
  const _InstallPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final radius = BorderRadius.circular(r.s(12));

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: AppColors.borderSecondary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), r.s(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, size: r.s(16), color: AppColors.ctaBlue),
              SizedBox(width: r.s(8)),
              Text(
                'Install Uber',
                style: TextStyle(
                  color: AppColors.ctaBlue,
                  fontSize: r.s(12),
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UberNotInstalledScreen extends StatefulWidget {
  const UberNotInstalledScreen({super.key});

  @override
  State<UberNotInstalledScreen> createState() => _UberNotInstalledScreenState();
}

class _UberNotInstalledScreenState extends State<UberNotInstalledScreen> {
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
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _UberNotInstalledMark(),
                                SizedBox(height: r.s(26)),
                                Text(
                                  'App is not installed',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: r.s(18),
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: r.s(6)),
                                Text(
                                  'Get Uber to book selected ride',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: r.s(12),
                                    fontWeight: FontWeight.w400,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(height: r.s(16)),
                                _InstallPill(onTap: () {}),
                              ],
                            ),
                          ),
                          SizedBox(height: r.s(14)),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _UberNotInstalledMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final size = r.s(74);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: ClipOval(
              child: Container(
                width: r.s(50),
                height: r.s(50),
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  'Uber',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: r.s(14),
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: r.s(14),
            top: r.s(11),
            child: Container(
              width: r.s(18),
              height: r.s(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF6D9CC),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: r.s(2)),
              ),
              alignment: Alignment.center,
              child: Text(
                '!',
                style: TextStyle(
                  color: const Color(0xFFCE5A2B),
                  fontSize: r.s(12),
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

