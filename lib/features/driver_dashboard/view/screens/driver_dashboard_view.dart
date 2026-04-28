import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/profile/view/screens/link_platform_screen.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:rideiq/features/notifications/view/screens/notifications_screen.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class DriverDashboardView extends ConsumerStatefulWidget {
  const DriverDashboardView({super.key});

  @override
  ConsumerState<DriverDashboardView> createState() => _DriverDashboardViewState();
}

class _DriverDashboardViewState extends ConsumerState<DriverDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(truvViewModelProvider.notifier).checkStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final notifier = ref.read(dashboardViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (!state.isDashboardActive)
                      _buildLinkView(context, notifier, l10n, ref)
                    else ...[
                      _buildTabs(state, notifier, l10n),
                      if (state.selectedTab == DashboardTab.today)
                        _buildTodayStats(state, notifier, l10n, ref)
                      else if (state.selectedTab == DashboardTab.weekly)
                        _buildWeeklyStats(context, state, notifier, l10n, ref)
                      else
                        _buildAllTimeStats(state, notifier, l10n, ref),
                    ],
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileViewModelProvider);
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driver_dashboard_title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.driver_dashboard_subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: SvgPicture.asset(AppAssets.bellSvg, width: 24.w),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfileScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 0.05);
                            const end = Offset.zero;
                            const curve = Curves.easeOutQuart;

                            var slideTween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var fadeTween = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeOut));

                            return SlideTransition(
                              position: animation.drive(slideTween),
                              child: FadeTransition(
                                opacity: animation.drive(fadeTween),
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 22.w,
                  backgroundColor: const Color(0xFF1E74E9),
                  child: Text(
                    profileState.initials,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(
    DashboardState state,
    DashboardViewModel notifier,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
      ),
      child: Row(
        children: [
          _buildTabItem(
            l10n.tab_today,
            state.selectedTab == DashboardTab.today,
            () => notifier.selectTab(DashboardTab.today),
          ),
          _buildTabItem(
            l10n.tab_weekly,
            state.selectedTab == DashboardTab.weekly,
            () => notifier.selectTab(DashboardTab.weekly),
          ),
          _buildTabItem(
            l10n.tab_all_time,
            state.selectedTab == DashboardTab.allTime,
            () => notifier.selectTab(DashboardTab.allTime),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFF999999),
                ),
              ),
            ),
            if (isActive)
              Container(height: 2.h, color: const Color(0xFF1E74E9)),
          ],
        ),
      ),
    );
  }

  // --- TODAY VIEW ---
  Widget _buildTodayStats(
    DashboardState state,
    DashboardViewModel notifier,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final truvState = ref.watch(truvViewModelProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.todays_earnings,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                ),
              ),
              SizedBox(height: 16.h),
              _buildEarningsRow(
                "Uber",
                AppAssets.uberLogoPng,
                truvState.getPlatformStats("Uber")["rate"]!,
                truvState.getPlatformStats("Uber")["total"]!,
                truvState.getEarningsProgress("Uber"),
                state.selectedPlatform == "Uber",
                () => notifier.selectPlatform("Uber"),
              ),
              SizedBox(height: 12.h),
              _buildEarningsRow(
                "Lyft",
                AppAssets.lyftLogoPng,
                truvState.getPlatformStats("Lyft")["rate"]!,
                truvState.getPlatformStats("Lyft")["total"]!,
                truvState.getEarningsProgress("Lyft"),
                state.selectedPlatform == "Lyft",
                () => notifier.selectPlatform("Lyft"),
              ),
              // SizedBox(height: 12.h),
              // _buildEarningsRow(
              //   "Ayro",
              //   AppAssets.uberLogoPng,
              //   truvState.getPlatformStats("Ayro")["rate"]!,
              //   truvState.getPlatformStats("Ayro")["total"]!,
              //   truvState.getEarningsProgress("Ayro"),
              //   state.selectedPlatform == "Ayro",
              //   () => notifier.selectPlatform("Ayro"),
              // ),
            ],
          ),
        ).animate().fade().slideY(begin: 0.1),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quick_stats_platform(
                  state.selectedPlatform ?? 'all platforms',
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20.h),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(
                    l10n.trips_today,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["trips"]!,
                    AppAssets.carProfileSvg,
                  ),
                  _buildStatCard(
                    l10n.online_hours,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["hours"]!,
                    AppAssets.moneyWavySvg,
                  ),
                  _buildStatCard(
                    l10n.miles_driven,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["miles"]!,
                    AppAssets.roadHorizonSvg,
                  ),
                  _buildStatCard(
                    l10n.tips_earned,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["tips"]!,
                    AppAssets.clockCountdownSvg,
                  ),

                  _buildStatCard(
                    l10n.idle_time,
                    truvState.idleTime,
                    AppAssets.moneyWavySvg,
                  ),
                  _buildStatCard(
                    l10n.acceptance_rate,
                    truvState.acceptanceRate,
                    AppAssets.thumbsUpSvg,
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildInsightCard(l10n.insight_today_uber),
            ],
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
      ],
    );
  }

  // --- WEEKLY VIEW ---
  Widget _buildWeeklyStats(
    BuildContext context,
    DashboardState state,
    DashboardViewModel notifier,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final truvState = ref.watch(truvViewModelProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: _buildInsightCard(l10n.insight_weekly_uber),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.earnings_by_day,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF666666),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  _buildPlatformDropdown(context, state, notifier),
                ],
              ),
              SizedBox(height: 24.h),
              _buildBarChart(truvState, state.selectedPlatform),
            ],
          ),
        ).animate().fade().slideY(begin: 0.1),
        SizedBox(height: 32.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quick_stats_for_platform(state.selectedPlatform ?? 'Uber'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20.h),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(
                    l10n.total_earnings,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["total"]!,
                    AppAssets.currencyCircleDollarSvg,
                  ),
                  _buildStatCard(
                    l10n.earnings_per_hour,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["rate"]!,
                    AppAssets.coinsSvg,
                  ),
                  _buildStatCard(
                    l10n.total_trips,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["trips"]!,
                    AppAssets.carProfileSvg,
                  ),
                  _buildStatCard(
                    l10n.total_hours,
                    truvState.getPlatformStats(
                      state.selectedPlatform ?? "Uber",
                    )["hours"]!,
                    AppAssets.clockCountdownSvg,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
      ],
    );
  }

  // --- ALL TIME VIEW ---
  Widget _buildAllTimeStats(
    DashboardState state,
    DashboardViewModel notifier,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final truvState = ref.watch(truvViewModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.platform_earnings_comparison,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                  fontFamily: 'Figtree',
                ),
              ),
              SizedBox(height: 20.h),
              _buildEarningsComparisonRow(
                "Uber",
                "${truvState.getPlatformStats("Uber")["rate"]!}",
                truvState.getEarningsProgress("Uber"),
              ),
              SizedBox(height: 12.h),
              _buildEarningsComparisonRow(
                "Lyft",
                "${truvState.getPlatformStats("Lyft")["rate"]!}",
                truvState.getEarningsProgress("Lyft"),
              ),
              // SizedBox(height: 12.h),
              // _buildEarningsComparisonRow(
              //   "Ayro",
              //   "${truvState.getPlatformStats("Ayro")["rate"]!}",
              //   truvState.getEarningsProgress("Ayro"),
              // ),
            ],
          ),
        ).animate().fade().slideY(begin: 0.1),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(24.w),
            ),
            child: Column(
              children: [
                Image.asset(AppAssets.trophySvg, height: 100.h),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Text(
                    l10n.best_platform,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E74E9),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.sp),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        color: Colors.black,
                        child: Image.asset(
                          AppAssets.uberLogoPng,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Uber",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.per_hour(truvState.earningsPerHour),

                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E74E9),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(delay: 200.ms).scale(curve: Curves.easeOutBack),

        SizedBox(height: 32.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            l10n.milestones,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Builder(
          builder: (context) {
            final int trips = int.tryParse(truvState.totalTrips) ?? 0;
            final double trips500 = (trips / 500.0).clamp(0.0, 1.0);
            final double trips1000 = (trips / 1000.0).clamp(0.0, 1.0);
            final double trips1500 = (trips / 1500.0).clamp(0.0, 1.0);

            final double earnings = double.tryParse(truvState.totalEarnings.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
            final double earn10k = (earnings / 10000.0).clamp(0.0, 1.0);
            final double earn25k = (earnings / 25000.0).clamp(0.0, 1.0);
            final double earn30k = (earnings / 30000.0).clamp(0.0, 1.0);

            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      _buildMilestoneCircle(
                        trips500 >= 1.0 ? l10n.milestone_completed : (trips500 > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "500",
                        l10n.trips,
                        trips500,
                        trips500 > 0 ? const Color(0xFF1E74E9) : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        trips1000 >= 1.0 ? l10n.milestone_completed : (trips1000 > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "1000",
                        l10n.trips,
                        trips1000,
                        trips1000 > 0 ? const Color(0xFF1E74E9) : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        trips1500 >= 1.0 ? l10n.milestone_completed : (trips1500 > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "1500",
                        l10n.trips,
                        trips1500,
                        trips1500 > 0 ? const Color(0xFF1E74E9) : const Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 300.ms).slideX(begin: 0.1),

                SizedBox(height: 24.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      _buildMilestoneCircle(
                        earn10k >= 1.0 ? l10n.milestone_earned : (earn10k > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "\$10k",
                        "",
                        earn10k,
                        earn10k > 0 ? const Color(0xFF00C897) : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        earn25k >= 1.0 ? l10n.milestone_earned : (earn25k > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "\$25k",
                        "",
                        earn25k,
                        earn25k > 0 ? const Color(0xFF00C897) : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        earn30k >= 1.0 ? l10n.milestone_earned : (earn30k > 0 ? l10n.milestone_in_progress : l10n.milestone_locked),
                        "\$30k",
                        "",
                        earn30k,
                        earn30k > 0 ? const Color(0xFF00C897) : const Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 400.ms).slideX(begin: 0.1),
              ],
            );
          }
        ),

        SizedBox(height: 32.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quick_stats,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20.h),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(
                    l10n.total_earnings,
                    truvState.totalEarnings,
                    AppAssets.currencyCircleDollarSvg,
                  ),
                  _buildStatCard(
                    l10n.total_trips,
                    truvState.totalTrips,
                    AppAssets.carProfileSvg,
                  ),
                  _buildStatCard(
                    l10n.total_hours,
                    truvState.totalHours,
                    AppAssets.clockCountdownSvg,
                  ),
                  _buildStatCard(l10n.avg_rating, truvState.averageRating, AppAssets.coinsSvg),
                ],
              ),
            ],
          ),
        ).animate().fade(delay: 500.ms).slideY(begin: 0.1),
      ],
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildEarningsComparisonRow(
    String name,
    String rate,
    double progress,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 250.w,
          height: 36.h,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C897),
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          rate,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCircle(
    String status,
    String value,
    String unit,
    double progress,
    Color color,
  ) {
    final bool isCompleted = progress >= 1.0;
    final bool isLocked = status == "Locked";
    final statusColor = isCompleted ? color : const Color(0xFF999999);

    return Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom Arc Progress Indicator (Uniform 110-degree Gap)
          SizedBox(
            width: 100.w,
            height: 100.w,
            child: CustomPaint(
              painter: MilestoneArcPainter(
                progress: progress,
                color: isLocked ? const Color(0xFFE0E0E0) : color,
                backgroundColor: const Color(0xFFF2F2F2),
              ),
            ),
          ),

          // Content inside the circle
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isLocked
                      ? const Color(0xFF999999)
                      : const Color(0xFF1A1A1A),
                  fontFamily: 'Figtree',
                ),
              ),
              if (unit.isNotEmpty)
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
            ],
          ),

          // Status Text (Uniform size 12)
          Positioned(
            top: 0.h,
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12.sp,
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkView(
    BuildContext context,
    DashboardViewModel notifier,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final truvState = ref.watch(truvViewModelProvider);
    final isUberConnected = truvState.isPlatformConnected("Uber");

    final isLyftConnected = truvState.isPlatformConnected("Lyft");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Uber",
            logo: AppAssets.uberLogoPng,
            isConnected: isUberConnected,
            status: isUberConnected ? l10n.connected : l10n.not_linked,
            l10n: l10n,
            ref: ref,
            onLinkTap: isUberConnected
                ? null
                : () => _openDriverLinkFlow(context, "Uber"),
          ),
          SizedBox(height: 16.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Lyft",
            logo: AppAssets.lyftLogoPng,
            isConnected: isLyftConnected,
            status: isLyftConnected ? l10n.connected : l10n.not_linked,
            l10n: l10n,
            ref: ref,
            onLinkTap: isLyftConnected
                ? null
                : () => _openDriverLinkFlow(context, "Lyft"),
          ),
          // SizedBox(height: 16.h),
          // _buildPlatformLinkCard(
          //   context: context,
          //   name: "Ayro",
          //   logo: AppAssets.uberLogoPng,
          //   isConnected: truvState.isPlatformConnected("Ayro"),
          //   status: truvState.isPlatformConnected("Ayro") ? l10n.connected : l10n.not_linked,
          //   l10n: l10n,
          //   ref: ref,
          //   onLinkTap: truvState.isPlatformConnected("Ayro")
          //       ? null
          //       : () => _openDriverLinkFlow(context, "Ayro"),
          // ),

          SizedBox(height: 40.h),
          PrimaryButton(
            text: l10n.go_to_dashboard,
            onPressed: () => notifier.activateDashboard(),
          ),
        ],
      ).animate().fade().slideY(begin: 0.1),
    );
  }

  Widget _buildPlatformLinkCard({
    required BuildContext context,
    required String name,
    required String logo,
    required bool isConnected,
    required String status,
    required AppLocalizations l10n,
    required WidgetRef ref,
    VoidCallback? onLinkTap,
  }) {
    final isUber = name.toLowerCase() == "uber";
    final truvState = ref.watch(truvViewModelProvider);

    // Extract company name from report data if available
    String companyName = name;
    if (isConnected && truvState.reportData != null) {
      try {
        final employments =
            truvState.reportData!['data']['employments'] as List;
        if (employments.isNotEmpty) {
          companyName = employments[0]['company']['name'] ?? name;
        }
      } catch (_) {}
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.sp),
            child: Container(
              width: 48.w,
              height: 48.w,
              color: isUber ? Colors.black : const Color(0xFFFF00BF),
              child: Image.asset(logo, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? companyName : name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (isConnected)
                      Icon(
                        Icons.verified,
                        color: const Color(0xFF1ABC9C),
                        size: 14.sp,
                      ),
                    if (isConnected) SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        isConnected ? l10n.income_source_connected : status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isConnected
                              ? const Color(0xFF1ABC9C)
                              : const Color(0xFF999999),
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  ],
                ),
                if (isConnected) ...[
                  SizedBox(height: 2.h),
                  Text(
                    l10n.verified_employer,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF999999),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isConnected && onLinkTap != null)
            TextButton(
              onPressed: onLinkTap,
              child: Text(
                l10n.link_btn,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E74E9),
                ),
              ),
            )
          else if (isConnected)
            Icon(
              Icons.check_circle,
              color: const Color(0xFF1ABC9C),
              size: 24.sp,
            ),
        ],
      ),
    );
  }

  // Future<void> _openDriverLinkFlow(BuildContext context) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => DriverTruvVerificationScreen(
  //         openTruvBridge: (bridgeToken) async {
  //           final controller = TextEditingController();
  //           final token = await showDialog<String?>(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: const Text('Truv public_token'),
  //               content: TextField(
  //                 controller: controller,
  //                 decoration: const InputDecoration(
  //                   hintText: 'Paste public_token from Truv SDK',
  //                 ),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(ctx, null),
  //                   child: const Text('Cancel'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () => Navigator.pop(ctx, controller.text.trim()),
  //                   child: const Text('Continue'),
  //                 ),
  //               ],
  //             ),
  //           );
  //           controller.dispose();
  //           return token;
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEarningsRow(
    String name,
    String logo,
    String rate,
    String total,
    double progress,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isUber = name.toLowerCase() == "uber";
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F2FF) : Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E74E9)
                : const Color(0xFFF2F2F2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.sp),
              child: Container(
                width: 36.w,
                height: 36.w,
                color: isUber ? Colors.black : const Color(0xFFFF00BF),
                padding: EdgeInsets.all(8.w),
                child: Image.asset(logo, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              name,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C897),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 12.w),
                      child: Text(
                        rate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              total,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999)),
          ),
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 20.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1E74E9),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String content) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2FF),
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.trending_up, color: const Color(0xFF1E74E9), size: 28.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Insight",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E74E9),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF4D4D4D),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformDropdown(
    BuildContext context,
    DashboardState state,
    DashboardViewModel notifier,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        elevation: 10,
        color: Colors.white,
        onSelected: (value) {
          if (value == "All") {
            if (state.selectedPlatform != null) {
              notifier.selectPlatform(state.selectedPlatform!);
            }
          } else {
            notifier.selectPlatform(value);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            border: Border.all(color: const Color(0xFFF2F2F2)),
          ),
          child: Row(
            children: [
              Text(
                state.selectedPlatform ?? "All",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20.sp,
                color: const Color(0xFF1A1A1A),
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          _buildPopupMenuItem("All", null, state.selectedPlatform == null),
          _buildPopupMenuItem(
            "Uber",
            AppAssets.uberLogoPng,
            state.selectedPlatform == "Uber",
          ),
          _buildPopupMenuItem(
            "Lyft",
            AppAssets.lyftLogoPng,
            state.selectedPlatform == "Lyft",
          ),
          // _buildPopupMenuItem(
          //   "Ayro",
          //   AppAssets.uberLogoPng,
          //   state.selectedPlatform == "Ayro",
          // ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String title,
    String? logo,
    bool isSelected,
  ) {
    return PopupMenuItem<String>(
      value: title,
      height: 48.h,
      child: Row(
        children: [
          if (logo != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(30.sp),
              child: Container(
                width: 24.w,
                height: 24.w,
                color: title == "Uber" ? Colors.black : const Color(0xFFFF00BF),
                padding: EdgeInsets.all(4.w),
                child: Image.asset(logo, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          if (logo == null) SizedBox(width: 4.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF00C897)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: const Color(0xFF00C897), size: 18.sp),
        ],
      ),
    );
  }

  Widget _buildBarChart(TruvState truvState, String? selectedPlatform) {
    final rawData = truvState.getWeeklyEarningsData(selectedPlatform);
    final maxValue = rawData.isEmpty
        ? 1.0
        : rawData.reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue == 0 ? 1.0 : maxValue;
    final values = rawData.map((e) => e / safeMax).toList();
    final labels = ["M", "T", "W", "T", "F", "S", "S"];
    return SizedBox(
      height: 200.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 32.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: values[index],
                      child: Container(
                        width: 32.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C897),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                labels[index],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _openDriverLinkFlow(BuildContext context, String platformName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LinkPlatformScreen(platformName: platformName, isDriverMode: true),
      ),
    );
  }
}

class MilestoneArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  MilestoneArcPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.w;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Fixed 110-degree gap fits "In Progress" at size 12 perfectly
    const gapAngleRad = 110 * (math.pi / 180);
    const sweepAngleRad = (2 * math.pi) - gapAngleRad;

    // Gap centered exactly at the top (270 degrees)
    const startAngle = (270 * (math.pi / 180)) + (gapAngleRad / 2);

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleRad,
      false,
      bgPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleRad * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MilestoneArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
