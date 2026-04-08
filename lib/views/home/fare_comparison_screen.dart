import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';

class FareComparisonScreen extends StatefulWidget {
  const FareComparisonScreen({super.key});

  @override
  State<FareComparisonScreen> createState() => _FareComparisonScreenState();
}

class _FareComparisonScreenState extends State<FareComparisonScreen> {
  int _filterIndex = 0;

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
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.s(24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                    child: Row(
                      children: [
                        _PillButton(
                          label: 'Edit locations',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        _ProfileAvatar(size: r.s(40)),
                      ],
                    ),
                  ),
                  SizedBox(height: r.s(14)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                    child: const _RouteTimeline(),
                  ),
                  SizedBox(height: r.s(14)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                    child: _SegmentedChips(
                      selectedIndex: _filterIndex,
                      onChanged: (i) => setState(() => _filterIndex = i),
                    ),
                  ),
                  SizedBox(height: r.s(10)),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        r.s(20),
                        r.s(4),
                        r.s(20),
                        r.s(12),
                      ),
                      children: const [
                        _FareRow(
                          logoAsset: 'assets/images/uber.png',
                          provider: 'Uber',
                          product: 'UberX',
                          price: '\$9.10',
                          eta: '5 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/uber.png',
                          provider: 'Uber',
                          product: 'UberX',
                          price: '\$9.10',
                          eta: '5 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/lyft.png',
                          provider: 'Lyft',
                          product: 'Standard',
                          price: '\$9.35',
                          eta: '3 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/uber.png',
                          provider: 'Uber',
                          product: 'Comfort',
                          price: '\$12.50',
                          eta: '6 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/lyft.png',
                          provider: 'Lyft',
                          product: 'Lux',
                          price: '\$15.80',
                          eta: '8 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/uber.png',
                          provider: 'Uber',
                          product: 'Comfort',
                          price: '\$12.50',
                          eta: '6 min',
                        ),
                        _FareRow(
                          logoAsset: 'assets/images/lyft.png',
                          provider: 'Lyft',
                          product: 'Standard',
                          price: '\$9.35',
                          eta: '3 min',
                        ),
                      ],
                    ),
                  ),
                  const _BottomRoleBarStatic(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.s(12)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.s(12)),
          border: Border.all(color: AppColors.borderSecondary),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: r.s(16), color: AppColors.textPrimary),
              SizedBox(width: r.s(6)),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: const DecorationImage(
          image: AssetImage('assets/images/Profilepicture.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}

class _RouteTimeline extends StatelessWidget {
  const _RouteTimeline();

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: r.s(22),
          child: CustomPaint(
            painter: _TimelinePainter(color: AppColors.ctaBlue),
          ),
        ),
        SizedBox(height: r.s(10)),
        Row(
          children: [
            _TimelineLabel(
              title: 'Pickup location',
              value: '123 Main St',
              align: CrossAxisAlignment.start,
            ),
            _TimelineLabel(
              title: 'Stop',
              value: '123 Main St',
              align: CrossAxisAlignment.center,
            ),
            _TimelineLabel(
              title: 'Drop location',
              value: '456 Oak Ave',
              align: CrossAxisAlignment.end,
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineLabel extends StatelessWidget {
  const _TimelineLabel({
    required this.title,
    required this.value,
    required this.align,
  });

  final String title;
  final String value;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final textAlign = switch (align) {
      CrossAxisAlignment.end => TextAlign.right,
      CrossAxisAlignment.center => TextAlign.center,
      _ => TextAlign.left,
    };

    return Expanded(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            title,
            textAlign: textAlign,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: r.s(11),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: r.s(4)),
          Text(
            value,
            textAlign: textAlign,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.s(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    final leftX = 2.0;
    final rightX = size.width - 2.0;
    final midX = size.width * 0.5;

    // Dotted line.
    const dash = 5.0;
    const gap = 4.0;
    double x = leftX;
    while (x < rightX) {
      final x2 = (x + dash).clamp(leftX, rightX);
      canvas.drawLine(Offset(x, y), Offset(x2, y), paint);
      x += dash + gap;
    }

    final fill = Paint()..color = color;

    // Start dot (filled).
    canvas.drawCircle(Offset(leftX, y), 5, fill);
    // Middle dot (ring).
    canvas.drawCircle(Offset(midX, y), 5, paint..style = PaintingStyle.stroke);
    // End square (filled).
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(rightX, y), width: 10, height: 10),
        const Radius.circular(2),
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SegmentedChips extends StatelessWidget {
  const _SegmentedChips({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(
      children: [
        _FilterChip(
          label: 'All',
          selected: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),
        SizedBox(width: r.s(10)),
        _FilterChip(
          label: 'Economy',
          selected: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
        SizedBox(width: r.s(10)),
        _FilterChip(
          label: 'Premium',
          selected: selectedIndex == 2,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final bg = selected ? const Color(0xFFE6F0FF) : Colors.white;
    final border = selected ? Colors.transparent : AppColors.borderSecondary;
    final fg = selected ? AppColors.ctaBlue : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(10)),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: r.s(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.logoAsset,
    required this.provider,
    required this.product,
    required this.price,
    required this.eta,
  });

  final String logoAsset;
  final String provider;
  final String product;
  final String price;
  final String eta;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.s(12)),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              logoAsset,
              width: r.s(42),
              height: r.s(42),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: r.s(42),
                height: r.s(42),
                color: const Color(0xFFE9E9EC),
                alignment: Alignment.center,
                child: Text(
                  provider.characters.first,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: r.s(16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: r.s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider,
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: r.s(11),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: r.s(2)),
                Text(
                  product,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.s(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.s(14),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: r.s(4)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: r.s(12), color: AppColors.textTertiary),
                  SizedBox(width: r.s(4)),
                  Text(
                    eta,
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: r.s(11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomRoleBarStatic extends StatelessWidget {
  const _BottomRoleBarStatic();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: r.s(24),
            right: r.s(24),
            top: r.s(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 1, color: AppColors.borderSecondary),
              SizedBox(height: r.s(8)),
              Row(
                children: const [
                  Expanded(
                    child: _BottomNavItem(
                      label: 'Rider',
                      assetPath: 'assets/icons/User.svg',
                      selected: true,
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      label: 'Driver',
                      assetPath: 'assets/icons/Car.svg',
                      selected: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.assetPath,
    required this.selected,
  });

  final String label;
  final String assetPath;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final color = selected ? AppColors.ctaBlue : AppColors.textTertiary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.s(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: r.s(17),
            child: SvgPicture.asset(
              assetPath,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: r.s(6)),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: r.s(12),
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

