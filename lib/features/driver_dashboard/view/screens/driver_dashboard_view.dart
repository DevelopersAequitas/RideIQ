import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';
import 'package:rideiq/features/profile/view/screens/link_platform_screen.dart';
import 'package:rideiq/features/notifications/view/screens/notifications_screen.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DriverDashboardView extends ConsumerWidget {
  const DriverDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final notifier = ref.read(dashboardViewModelProvider.notifier);

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
                      _buildLinkView(context, notifier)
                    else ...[
                      _buildTabs(state, notifier),
                      if (state.selectedTab == DashboardTab.today)
                        _buildTodayStats(state, notifier)
                      else if (state.selectedTab == DashboardTab.weekly)
                        _buildWeeklyStats(context, state, notifier)
                      else
                        _buildAllTimeStats(state, notifier),
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
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Driver Dashboard",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  fontFamily: 'Figtree',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "See what you're really earning.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF999999),
                  fontFamily: 'Figtree',
                ),
              ),
            ],
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

                        var slideTween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var fadeTween =
                            Tween<double>(begin: 0.0, end: 1.0).chain(
                          CurveTween(curve: Curves.easeOut),
                        );

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
                  backgroundImage: const AssetImage(AppAssets.driverPng),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(DashboardState state, DashboardViewModel notifier) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
      ),
      child: Row(
        children: [
          _buildTabItem(
            "Today",
            state.selectedTab == DashboardTab.today,
            () => notifier.selectTab(DashboardTab.today),
          ),
          _buildTabItem(
            "Weekly",
            state.selectedTab == DashboardTab.weekly,
            () => notifier.selectTab(DashboardTab.weekly),
          ),
          _buildTabItem(
            "All Time",
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
  Widget _buildTodayStats(DashboardState state, DashboardViewModel notifier) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Earnings",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                ),
              ),
              SizedBox(height: 16.h),
              _buildEarningsRow(
                "Uber",
                AppAssets.uberLogoPng,
                "\$26/hr",
                "\$120",
                0.8,
                state.selectedPlatform == "Uber",
                () => notifier.selectPlatform("Uber"),
              ),
              SizedBox(height: 12.h),
              _buildEarningsRow(
                "Lyft",
                AppAssets.lyftLogoPng,
                "\$18/hr",
                "\$42",
                0.4,
                state.selectedPlatform == "Lyft",
                () => notifier.selectPlatform("Lyft"),
              ),
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
                "Quick Stats of ${state.selectedPlatform ?? 'all platforms'}",
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
                    "Trips Today",
                    state.selectedPlatform == "Uber" ? "10" : "14",
                    AppAssets.carProfileSvg,
                  ),
                  _buildStatCard(
                    "Online Hours",
                    state.selectedPlatform == "Uber" ? "1.5" : "6.2",
                    AppAssets.moneyWavySvg,
                  ),
                  _buildStatCard(
                    "Miles Driven",
                    state.selectedPlatform == "Uber" ? "50" : "92",
                    AppAssets.roadHorizonSvg,
                  ),
                  _buildStatCard(
                    "Tips Earned",
                    state.selectedPlatform == "Uber" ? "\$14" : "\$28",
                    AppAssets.clockCountdownSvg,
                  ),
                  _buildStatCard("Idle Time", "1h 10m", AppAssets.moneyWavySvg),
                  _buildStatCard(
                    "Acceptance Rate",
                    "87%",
                    AppAssets.thumbsUpSvg,
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildInsightCard(
                "You earned more per hour on Uber today compared to the other platforms.",
              ),
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
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: _buildInsightCard(
            "You earned more per hour on Uber this week compared to the other platforms.",
          ),
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
                    "Earnings by Day",
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
              _buildBarChart(),
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
                "Quick Stats for ${state.selectedPlatform ?? 'Uber'}",
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
                    "Total Earnings",
                    "\$1,245",
                    AppAssets.currencyCircleDollarSvg,
                  ),
                  _buildStatCard(
                    "Earnings per Hour",
                    "\$26.40",
                    AppAssets.coinsSvg,
                  ),
                  _buildStatCard("Total Trips", "78", AppAssets.carProfileSvg),
                  _buildStatCard(
                    "Total Hours",
                    "42.5",
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
  Widget _buildAllTimeStats(DashboardState state, DashboardViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Platform Earnings Comparison",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                  fontFamily: 'Figtree',
                ),
              ),
              SizedBox(height: 20.h),
              _buildEarningsComparisonRow("Uber", "\$24.80/hr", 0.9),
              SizedBox(height: 12.h),
              _buildEarningsComparisonRow("Lyft", "\$21.40/hr", 0.7),
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
                SvgPicture.asset(AppAssets.trophySvg, height: 100.h),
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
                    "Best Platform",
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
                        padding: EdgeInsets.all(6.w),
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
                  "\$24.80 per hour",
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
            "Milestones",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              _buildMilestoneCircle(
                "Completed",
                "500",
                "Trips",
                1.0,
                const Color(0xFF1E74E9),
              ),
              SizedBox(width: 16.w),
              _buildMilestoneCircle(
                "In Progress",
                "1000",
                "Trips",
                0.6,
                const Color(0xFF1E74E9),
              ),
              SizedBox(width: 16.w),
              _buildMilestoneCircle(
                "Locked",
                "1500",
                "Trips",
                0.0,
                const Color(0xFFE0E0E0),
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
                "Earned",
                "\$10k",
                "",
                1.0,
                const Color(0xFF00C897),
              ),
              SizedBox(width: 16.w),
              _buildMilestoneCircle(
                "In Progress",
                "\$25k",
                "",
                0.4,
                const Color(0xFF00C897),
              ),
              SizedBox(width: 16.w),
              _buildMilestoneCircle(
                "Locked",
                "\$30k",
                "",
                0.0,
                const Color(0xFFE0E0E0),
              ),
            ],
          ),
        ).animate().fade(delay: 400.ms).slideX(begin: 0.1),

        SizedBox(height: 32.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Stats",
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
                    "Total Earnings",
                    "\$1,245",
                    AppAssets.currencyCircleDollarSvg,
                  ),
                  _buildStatCard("Total Trips", "542", AppAssets.carProfileSvg),
                  _buildStatCard(
                    "Total Hours",
                    "542",
                    AppAssets.clockCountdownSvg,
                  ),
                  _buildStatCard("Avg Rating", "4.8", AppAssets.coinsSvg),
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
        Container(
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

  Widget _buildLinkView(BuildContext context, DashboardViewModel notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Uber",
            logo: AppAssets.uberLogoPng,
            isConnected: true,
            status: "Connected",
          ),
          SizedBox(height: 16.h),
          _buildPlatformLinkCard(
            context: context,
            name: "Lyft",
            logo: AppAssets.lyftLogoPng,
            isConnected: false,
            status: "Not Linked",
          ),
          SizedBox(height: 40.h),
          PrimaryButton(
            text: "Go to Dashboard",
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
  }) {
    final isUber = name.toLowerCase() == "uber";
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
              padding: EdgeInsets.all(10.w),
              child: Image.asset(logo, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (isConnected)
                      Icon(
                        Icons.check,
                        color: const Color(0xFF00C897),
                        size: 16.sp,
                      ),
                    if (isConnected) SizedBox(width: 4.w),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isConnected
                            ? const Color(0xFF00C897)
                            : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isConnected)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LinkPlatformScreen(
                      platformName: name,
                      isDriverMode: true,
                    ),
                  ),
                );
              },
              child: Text(
                "Link",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E74E9),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
            if (state.selectedPlatform != null)
              notifier.selectPlatform(state.selectedPlatform!);
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

  Widget _buildBarChart() {
    final values = [0.4, 0.6, 0.3, 0.7, 0.5, 0.65, 0.8];
    final labels = ["M", "T", "W", "T", "F", "S", "S"];
    return Container(
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
