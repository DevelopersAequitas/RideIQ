import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';
import 'package:rideiq/views/profile/profile_screen_v2.dart';

/// Main driver home: Today / Weekly / All Time, earnings rows, quick stats.
class DriverEarningsDashboardView extends StatefulWidget {
  const DriverEarningsDashboardView({
    super.key,
    required this.onAvatarTap,
    this.onNotificationTap,
    this.onBack,
  });

  final VoidCallback onAvatarTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBack;

  static const double _gutter = 20;
  static const double _topInset = 18;

  @override
  State<DriverEarningsDashboardView> createState() => _DriverEarningsDashboardViewState();
}

class _DriverEarningsDashboardViewState extends State<DriverEarningsDashboardView> {
  int _periodTab = 0;
  _DriverPlatform _selectedPlatform = _DriverPlatform.ayro;

  static const _tabs = ['Today', 'Weekly', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final h = r.s(DriverEarningsDashboardView._gutter);
    final top = r.s(DriverEarningsDashboardView._topInset);

    final data = _periodData(_periodTab);
    final selectedStats = data.statsFor(_selectedPlatform);
    final selectedName = _selectedPlatform.label;
    final maxHourly = math.max(
      data.ayroHourly,
      math.max(data.uberHourly, data.lyftHourly),
    );
    final maxH = maxHourly > 0 ? maxHourly : 1.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, top, 0, r.s(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderBlock(
                  onAvatarTap: widget.onAvatarTap,
                  onNotificationTap: widget.onNotificationTap,
                  onBack: widget.onBack,
                ),
                SizedBox(height: r.s(20)),
                _PeriodTabs(
                  labels: _tabs,
                  selectedIndex: _periodTab,
                  onSelect: (i) => setState(() {
                    _periodTab = i;
                    // Keep UX predictable: default selection per period.
                    _selectedPlatform = _DriverPlatform.ayro;
                  }),
                ),
                SizedBox(height: r.s(4)),
                Container(height: 1, color: AppColors.borderSecondary),
                SizedBox(height: r.s(16)),
                Text(
                  data.sectionTitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.s(13),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: r.s(12)),
                _EarningsPlatformRow(
                  selected: _selectedPlatform == _DriverPlatform.ayro,
                  leading: _AyroCircle(size: r.s(44)),
                  name: 'AYRO',
                  rateLabel: data.ayroRate,
                  totalLabel: data.ayroTotal,
                  barFraction: data.ayroHourly / maxH,
                  onTap: () => setState(() => _selectedPlatform = _DriverPlatform.ayro),
                ),
                SizedBox(height: r.s(10)),
                _EarningsPlatformRow(
                  selected: _selectedPlatform == _DriverPlatform.uber,
                  leading: _UberCircle(size: r.s(44)),
                  name: 'Uber',
                  rateLabel: data.uberRate,
                  totalLabel: data.uberTotal,
                  barFraction: data.uberHourly / maxH,
                  onTap: () => setState(() => _selectedPlatform = _DriverPlatform.uber),
                ),
                SizedBox(height: r.s(10)),
                _EarningsPlatformRow(
                  selected: _selectedPlatform == _DriverPlatform.lyft,
                  leading: _LyftCircle(size: r.s(44)),
                  name: 'Lyft',
                  rateLabel: data.lyftRate,
                  totalLabel: data.lyftTotal,
                  barFraction: data.lyftHourly / maxH,
                  onTap: () => setState(() => _selectedPlatform = _DriverPlatform.lyft),
                ),
                SizedBox(height: r.s(34)),
              ],
            ),
          ),
          // Full-width grey band, with inner content padded.
          ColoredBox(
            color: AppColors.bgPrimary,
            child: Padding(
              padding: EdgeInsets.fromLTRB(h, r.s(20), h, r.s(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.s(14),
                        height: 1.25,
                      ),
                      children: [
                        const TextSpan(text: 'Quick Stats of '),
                        TextSpan(
                          text: selectedName,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.s(16)),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: r.s(12),
                    crossAxisSpacing: r.s(12),
                    childAspectRatio: 1.62,
                    children: [
                      _QuickStatCard(
                        icon: Icons.directions_car_rounded,
                        label: data.tripsStatLabel,
                        value: selectedStats.trips,
                      ),
                      _QuickStatCard(
                        icon: Icons.schedule_rounded,
                        label: 'Online Hours',
                        value: selectedStats.onlineHours,
                      ),
                      _QuickStatCard(
                        icon: Icons.route_rounded,
                        label: 'Miles Driven',
                        value: selectedStats.milesDriven,
                      ),
                      _QuickStatCard(
                        icon: Icons.payments_outlined,
                        label: 'Tips Earned',
                        value: selectedStats.tipsEarned,
                      ),
                      _QuickStatCard(
                        icon: Icons.timer_outlined,
                        label: 'Idle Time',
                        value: selectedStats.idleTime,
                      ),
                      _QuickStatCard(
                        icon: Icons.thumb_up_alt_outlined,
                        label: 'Acceptance Rate',
                        value: selectedStats.acceptanceRate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodCopy {
  const _PeriodCopy({
    required this.sectionTitle,
    required this.ayroRate,
    required this.ayroTotal,
    required this.uberRate,
    required this.uberTotal,
    required this.lyftRate,
    required this.lyftTotal,
    required this.ayroHourly,
    required this.uberHourly,
    required this.lyftHourly,
    required this.tripsStatLabel,
    required this.ayroStats,
    required this.uberStats,
    required this.lyftStats,
  });

  final String sectionTitle;
  final String ayroRate;
  final String ayroTotal;
  final String uberRate;
  final String uberTotal;
  final String lyftRate;
  final String lyftTotal;
  /// Dollar amounts per hour (used for proportional bar fill vs max in period).
  final double ayroHourly;
  final double uberHourly;
  final double lyftHourly;
  final String tripsStatLabel;
  final _QuickStats ayroStats;
  final _QuickStats uberStats;
  final _QuickStats lyftStats;

  _QuickStats statsFor(_DriverPlatform p) => switch (p) {
        _DriverPlatform.ayro => ayroStats,
        _DriverPlatform.uber => uberStats,
        _DriverPlatform.lyft => lyftStats,
      };
}

_PeriodCopy _periodData(int tab) {
  switch (tab) {
    case 1:
      return const _PeriodCopy(
        sectionTitle: "This Week's Earnings",
        ayroRate: '\$182/hr',
        ayroTotal: '\$812',
        uberRate: '\$148/hr',
        uberTotal: '\$524',
        lyftRate: '\$126/hr',
        lyftTotal: '\$298',
        ayroHourly: 182,
        uberHourly: 148,
        lyftHourly: 126,
        tripsStatLabel: 'Trips This Week',
        ayroStats: _QuickStats(
          trips: '58',
          onlineHours: '12.4',
          milesDriven: '312',
          tipsEarned: '\$86',
          idleTime: '4h 20m',
          acceptanceRate: '91%',
        ),
        uberStats: _QuickStats(
          trips: '44',
          onlineHours: '10.1',
          milesDriven: '260',
          tipsEarned: '\$62',
          idleTime: '3h 05m',
          acceptanceRate: '88%',
        ),
        lyftStats: _QuickStats(
          trips: '29',
          onlineHours: '7.6',
          milesDriven: '194',
          tipsEarned: '\$41',
          idleTime: '2h 15m',
          acceptanceRate: '84%',
        ),
      );
    case 2:
      return const _PeriodCopy(
        sectionTitle: 'All-Time Earnings',
        ayroRate: '\$24/hr',
        ayroTotal: '\$48.2k',
        uberRate: '\$19/hr',
        uberTotal: '\$31.1k',
        lyftRate: '\$17/hr',
        lyftTotal: '\$18.4k',
        ayroHourly: 24,
        uberHourly: 19,
        lyftHourly: 17,
        tripsStatLabel: 'Total Trips',
        ayroStats: _QuickStats(
          trips: '3.2k',
          onlineHours: '1.8k',
          milesDriven: '41k',
          tipsEarned: '\$4.1k',
          idleTime: '210h',
          acceptanceRate: '88%',
        ),
        uberStats: _QuickStats(
          trips: '2.4k',
          onlineHours: '1.2k',
          milesDriven: '30k',
          tipsEarned: '\$3.0k',
          idleTime: '165h',
          acceptanceRate: '86%',
        ),
        lyftStats: _QuickStats(
          trips: '1.6k',
          onlineHours: '0.9k',
          milesDriven: '21k',
          tipsEarned: '\$2.1k',
          idleTime: '120h',
          acceptanceRate: '83%',
        ),
      );
    default:
      return const _PeriodCopy(
        sectionTitle: "Today's Earnings",
        ayroRate: '\$26/hr',
        ayroTotal: '\$120',
        uberRate: '\$21/hr',
        uberTotal: '\$78',
        lyftRate: '\$18/hr',
        lyftTotal: '\$42',
        ayroHourly: 26,
        uberHourly: 21,
        lyftHourly: 18,
        tripsStatLabel: 'Trips Today',
        ayroStats: _QuickStats(
          trips: '10',
          onlineHours: '1.5',
          milesDriven: '50',
          tipsEarned: '\$14',
          idleTime: '1h 10m',
          acceptanceRate: '87%',
        ),
        uberStats: _QuickStats(
          trips: '7',
          onlineHours: '1.1',
          milesDriven: '36',
          tipsEarned: '\$9',
          idleTime: '0h 45m',
          acceptanceRate: '85%',
        ),
        lyftStats: _QuickStats(
          trips: '4',
          onlineHours: '0.7',
          milesDriven: '22',
          tipsEarned: '\$6',
          idleTime: '0h 35m',
          acceptanceRate: '82%',
        ),
      );
  }
}

enum _DriverPlatform { ayro, uber, lyft }

extension on _DriverPlatform {
  String get label => switch (this) {
        _DriverPlatform.ayro => 'AYRO',
        _DriverPlatform.uber => 'Uber',
        _DriverPlatform.lyft => 'Lyft',
      };
}

class _QuickStats {
  const _QuickStats({
    required this.trips,
    required this.onlineHours,
    required this.milesDriven,
    required this.tipsEarned,
    required this.idleTime,
    required this.acceptanceRate,
  });

  final String trips;
  final String onlineHours;
  final String milesDriven;
  final String tipsEarned;
  final String idleTime;
  final String acceptanceRate;
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock({
    required this.onAvatarTap,
    this.onNotificationTap,
    this.onBack,
  });

  final VoidCallback onAvatarTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (onBack != null) ...[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(r.s(6)),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: r.s(18),
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: r.s(4)),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Driver Dashboard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.s(20),
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: r.s(4)),
              Text(
                "See what you're really earning.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: r.s(14),
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.all(r.s(6)),
          constraints: BoxConstraints(minWidth: r.s(40), minHeight: r.s(40)),
          onPressed: onNotificationTap ?? () {},
          icon: Icon(
            Icons.notifications_none_rounded,
            size: r.s(24),
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: r.s(2)),
        _HeaderAvatar(onTap: onAvatarTap),
      ],
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(
      children: List.generate(labels.length, (i) {
        return Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(r.s(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: r.s(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedIndex == i ? AppColors.textPrimary : AppColors.textSecondary,
                        fontSize: r.s(15),
                        fontWeight: selectedIndex == i ? FontWeight.w700 : FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: r.s(8)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      height: r.s(3),
                      decoration: BoxDecoration(
                        color: selectedIndex == i ? AppColors.driverAccentBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(r.s(2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Grey track + proportional teal fill; [rateLabel] centered in the fill.
class _EarningsRateBar extends StatelessWidget {
  const _EarningsRateBar({
    required this.rateLabel,
    required this.barFraction,
  });

  final String rateLabel;
  final double barFraction;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final height = r.s(28);
    final radius = r.s(7);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackW = constraints.maxWidth;
        final f = barFraction.isFinite ? barFraction.clamp(0.0, 1.0) : 1.0;
        final raw = trackW * f;
        final minLabel = r.s(58);
        final fillW = math.min(trackW, math.max(raw, minLabel));

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.driverEarningsTrack,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: SizedBox(width: trackW, height: height),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.driverEarningsRateTeal,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: SizedBox(
                    width: fillW,
                    height: height,
                    child: Center(
                      child: Text(
                        rateLabel,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: r.s(12.5),
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EarningsPlatformRow extends StatelessWidget {
  const _EarningsPlatformRow({
    required this.selected,
    required this.leading,
    required this.name,
    required this.rateLabel,
    required this.totalLabel,
    required this.barFraction,
    required this.onTap,
  });

  final bool selected;
  final Widget leading;
  final String name;
  final String rateLabel;
  final String totalLabel;
  final double barFraction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final inner = Padding(
      padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          SizedBox(width: r.s(10)),
          SizedBox(
            width: r.s(52),
            child: Text(
              name,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.s(15),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: _EarningsRateBar(
              rateLabel: rateLabel,
              barFraction: barFraction,
            ),
          ),
          SizedBox(width: r.s(10)),
          Text(
            totalLabel,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.s(16),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.s(22)),
        child: DecoratedBox(
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.driverEarningsRowHighlight,
                  borderRadius: BorderRadius.circular(r.s(22)),
                  border: Border.all(color: AppColors.driverAccentBlue, width: 1),
                )
              : const BoxDecoration(),
          child: inner,
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(r.s(12)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(14), r.s(14), r.s(14), r.s(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: r.s(22), color: AppColors.driverAccentBlue),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.s(12),
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            SizedBox(height: r.s(4)),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.s(16),
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyroCircle extends StatelessWidget {
  const _AyroCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.driverAccentBlue,
      ),
      alignment: Alignment.center,
      child: Text(
        'A',
        style: TextStyle(
          color: AppColors.surface,
          fontSize: r.s(18),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _UberCircle extends StatelessWidget {
  const _UberCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.platformUberBlack,
        child: Image.asset('assets/images/uber.png', fit: BoxFit.contain),
      ),
    );
  }
}

class _LyftCircle extends StatelessWidget {
  const _LyftCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.platformLyftMagenta,
        child: Image.asset('assets/images/lyft.png', fit: BoxFit.contain),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final s = r.s(44);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 2),
            image: const DecorationImage(
              image: AssetImage('assets/images/Profilepicture.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pushed route: same dashboard with a back affordance in the header.
class DriverPrimaryDashboardScreen extends StatelessWidget {
  const DriverPrimaryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundSoft,
        body: SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.r.contentMaxWidth),
              child: DriverEarningsDashboardView(
                onBack: () => Navigator.of(context).maybePop(),
                onAvatarTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

