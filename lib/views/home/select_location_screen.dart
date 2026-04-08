import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/views/home/fare_comparison_screen.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// Select pickup/drop + recent locations + Rider/Driver tab bar (reference UI).
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  int _bottomIndex = 0;

  static const double _sheetRadius = 28;
  static const double _hPad = 20;
  static const Color _bg = Color.fromRGBO(250, 250, 250, 1);

  Future<void> _openAddStopSheet() async {
    final r = context.r;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => _LocationPickerSheet(maxWidth: r.contentMaxWidth),
    );
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
        backgroundColor: _bg,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(r.s(_sheetRadius)),
                      ),
                      child: ColoredBox(
                        color: _bg,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            r.s(_hPad),
                            r.s(18),
                            r.s(_hPad),
                            r.s(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _HeaderRow(),
                              SizedBox(height: r.s(20)),
                              _LocationRouteCard(onAddStop: _openAddStopSheet),
                              SizedBox(height: r.s(40)),
                              RidePrimaryButton(
                                label: 'Compare Fares',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const FareComparisonScreen(),
                                    ),
                                  );
                                },
                                padding:
                                    const EdgeInsets.fromLTRB(15, 18, 15, 14),
                                minimumHeight: 52,
                                borderRadius: 16,
                              ),
                              SizedBox(height: r.s(42)),
                              Container(
                                height: 1,
                                color: AppColors.borderSecondary,
                              ),
                              SizedBox(height: r.s(26)),
                              Text(
                                'Recent locations',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: r.s(14),
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: r.s(20)),
                              const _RecentLocationTile(
                                title: '2458 Maple Ave',
                                subtitle: 'Apt 3B — Brooklyn, NY',
                              ),
                              SizedBox(height: r.s(10)),
                              const _RecentLocationTile(
                                title: '2458 Maple Ave',
                                subtitle: 'Apt 3B — Brooklyn, NY',
                              ),
                              SizedBox(height: r.s(10)),
                              const _RecentLocationTile(
                                title: '2458 Maple Ave',
                                subtitle: 'Apt 3B — Brooklyn, NY',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _BottomRoleBar(
              selectedIndex: _bottomIndex,
              onSelect: (i) => setState(() => _bottomIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Select location',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.s(20),
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.2,
            ),
          ),
        ),
        SizedBox(width: r.s(10)),
        const _AvatarCluster(),
      ],
    );
  }
}

class _LocationRouteCard extends StatelessWidget {
  const _LocationRouteCard({required this.onAddStop});

  final VoidCallback onAddStop;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Material(
      color: AppColors.surface,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(r.s(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: r.s(190)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(r.s(18), r.s(22), r.s(18), r.s(22)),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: r.s(18),
                  child: Column(
                    children: [
                      _Dot(
                        color: AppColors.ctaBlue,
                        isSquare: false,
                        size: r.s(16),
                      ),
                      SizedBox(height: r.s(6)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: r.s(2)),
                          child: SizedBox(
                            width: r.s(2),
                            child: CustomPaint(
                              painter: _VerticalDashesPainter(
                                color: AppColors.ctaBlue.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: r.s(6)),
                      _Dot(
                        color: AppColors.ctaBlue,
                        isSquare: true,
                        size: r.s(16),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: r.s(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _LocationBlock(
                        label: 'Pickup location',
                        address: '2458 Maple Ave',
                      ),
                      SizedBox(height: r.s(18)),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.borderSecondary,
                            ),
                          ),
                          SizedBox(width: r.s(12)),
                          GestureDetector(
                            onTap: onAddStop,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  size: r.s(18),
                                  color: AppColors.ctaBlue,
                                ),
                                SizedBox(width: r.s(2)),
                                Text(
                                  'Add Stop',
                                  style: TextStyle(
                                    color: AppColors.ctaBlue,
                                    fontSize: r.s(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.s(18)),
                      const _LocationBlock(
                        label: 'Drop location',
                        address: '123 Main St',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationPickerSheet extends StatelessWidget {
  const _LocationPickerSheet({required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final viewPadding = MediaQuery.paddingOf(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(r.s(22)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              r.s(18),
              r.s(10),
              r.s(18),
              r.s(14) + viewPadding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: r.s(40),
                  height: r.s(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E8),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                SizedBox(height: r.s(14)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pickup location',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.s(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const _CurrentLocationPill(),
                  ],
                ),
                SizedBox(height: r.s(10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/MapPin.svg',
                      width: r.s(18),
                      height: r.s(18),
                      colorFilter: const ColorFilter.mode(
                        AppColors.ctaBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: r.s(10)),
                    Expanded(
                      child: Text(
                        '2458 Maple Ave',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: r.s(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.s(14)),
                Container(height: 1, color: AppColors.borderSecondary),
                SizedBox(height: r.s(12)),
                const _ResultRow(
                  title: '2458 Maple Ave',
                  subtitle: 'Apt 3B — Brooklyn, NY',
                ),
                const _ResultRow(
                  title: '2458 Maple Ave',
                  subtitle: 'Apt 3B — Brooklyn, NY',
                ),
                SizedBox(height: r.s(14)),
                RidePrimaryButton(
                  label: 'Done',
                  onPressed: () => Navigator.of(context).pop(),
                  minimumHeight: 52,
                  borderRadius: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentLocationPill extends StatelessWidget {
  const _CurrentLocationPill();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: r.s(36)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.s(12)),
          border: Border.all(color: AppColors.borderSecondary),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: r.s(12),
            vertical: r.s(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/Gps.svg',
                width: r.s(14),
                height: r.s(14),
                colorFilter: const ColorFilter.mode(
                  AppColors.ctaBlue,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: r.s(6)),
              Text(
                'Current location',
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.s(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.north_east_rounded,
            size: r.s(18),
            color: AppColors.textTertiary,
          ),
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
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: r.s(2)),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.s(12),
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.isSquare, required this.size});

  final Color color;
  final bool isSquare;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            isSquare ? BorderRadius.circular(3) : BorderRadius.circular(99),
      ),
    );
  }
}

class _VerticalDashesPainter extends CustomPainter {
  _VerticalDashesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final r = (size.width / 2).clamp(0.8, 1.6);
    const step = 7.0;
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawCircle(Offset(cx, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalDashesPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _LocationBlock extends StatelessWidget {
  const _LocationBlock({required this.label, required this.address});

  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: r.s(12),
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        SizedBox(height: r.s(10)),
        Text(
          address,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: r.s(17),
            fontWeight: FontWeight.w500,
            height: 1.2,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _RecentLocationTile extends StatelessWidget {
  const _RecentLocationTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  static const double _minHeight = 74;
  static const double _vPad = 22;

  @override
  Widget build(BuildContext context) {
    final rr = context.r;
    final tileRadius = BorderRadius.circular(rr.s(14));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: tileRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: tileRadius,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: rr.s(_minHeight)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rr.s(14),
              vertical: rr.s(_vPad),
            ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/MapPin.svg',
                width: rr.s(22),
                height: rr.s(22),
              ),
              SizedBox(width: rr.s(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: rr.s(16),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: rr.s(4)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: rr.s(13),
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          ),
      ),
    );
  }
}



class _BottomRoleBar extends StatelessWidget {
  const _BottomRoleBar({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

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
                children: [
                  Expanded(
                    child: _NavItem(
                      label: 'Rider',
                      assetPath: 'assets/icons/User.svg',
                      selected: selectedIndex == 0,
                      onTap: () => onSelect(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      label: 'Driver',
                      assetPath: 'assets/icons/Car.svg',
                      selected: selectedIndex == 1,
                      onTap: () => onSelect(1),
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

class _AvatarCluster extends StatelessWidget {
  const _AvatarCluster();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final avatarSize = r.s(44);
    return _PhotoAvatar(
      size: avatarSize,
      image: const AssetImage('assets/images/Profilepicture.png'),
    );
  }
}

class _PhotoAvatar extends StatelessWidget {
  const _PhotoAvatar({required this.size, required this.image});

  final double size;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(image: image, fit: BoxFit.cover),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final color = selected ? AppColors.ctaBlue : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.s(12)),
      child: Padding(
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
      ),
    );
  }
}

