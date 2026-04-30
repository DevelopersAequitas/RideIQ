import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/milestone_circle.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class AllTimeStatsView extends ConsumerWidget {
  const AllTimeStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
                "Ayro",
                truvState.getPlatformStats("Ayro")["rate"]!,
                truvState.getEarningsProgress("Ayro"),
              ),
              SizedBox(height: 12.h),
              _buildEarningsComparisonRow(
                "Uber",
                truvState.getPlatformStats("Uber")["rate"]!,
                truvState.getEarningsProgress("Uber"),
              ),
              SizedBox(height: 12.h),
              _buildEarningsComparisonRow(
                "Lyft",
                truvState.getPlatformStats("Lyft")["rate"]!,
                truvState.getEarningsProgress("Lyft"),
              ),
            ],
          ),
        ).animate().fade().slideY(begin: 0.1),

        if (truvState.bestPlatform != null)
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
                      _getPlatformLogo(
                        truvState.bestPlatform!['name'] as String,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        truvState.bestPlatform!['name'] as String,
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
                    l10n.per_hour("\$${truvState.bestPlatform!['rate']}"),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E74E9),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(delay: 200.ms).scale(curve: Curves.easeOutBack)
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(24.w),
              ),
              child: Center(
                child: Text(
                  "Comparing platform data...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ),
            ),
          ),

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

            final double earnings =
                double.tryParse(
                  truvState.totalEarnings.replaceAll(RegExp(r'[^0-9.]'), ''),
                ) ??
                0.0;
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
                        context,
                        trips500 >= 1.0
                            ? l10n.milestone_completed
                            : (trips500 > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        trips.toString(),
                        l10n.trips,
                        trips500,
                        trips500 > 0
                            ? const Color(0xFF1E74E9)
                            : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        context,
                        trips1000 >= 1.0
                            ? l10n.milestone_completed
                            : (trips1000 > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        trips.toString(),
                        l10n.trips,
                        trips1000,
                        trips1000 > 0
                            ? const Color(0xFF1E74E9)
                            : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        context,
                        trips1500 >= 1.0
                            ? l10n.milestone_completed
                            : (trips1500 > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        trips.toString(),
                        l10n.trips,
                        trips1500,
                        trips1500 > 0
                            ? const Color(0xFF1E74E9)
                            : const Color(0xFFE0E0E0),
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
                        context,
                        earn10k >= 1.0
                            ? l10n.milestone_earned
                            : (earn10k > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        truvState.totalEarnings,
                        "",
                        earn10k,
                        earn10k > 0
                            ? const Color(0xFF00C897)
                            : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        context,
                        earn25k >= 1.0
                            ? l10n.milestone_earned
                            : (earn25k > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        truvState.totalEarnings,
                        "",
                        earn25k,
                        earn25k > 0
                            ? const Color(0xFF00C897)
                            : const Color(0xFFE0E0E0),
                      ),
                      SizedBox(width: 16.w),
                      _buildMilestoneCircle(
                        context,
                        earn30k >= 1.0
                            ? l10n.milestone_earned
                            : (earn30k > 0
                                  ? l10n.milestone_in_progress
                                  : l10n.milestone_locked),
                        truvState.totalEarnings,
                        "",
                        earn30k,
                        earn30k > 0
                            ? const Color(0xFF00C897)
                            : const Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 400.ms).slideX(begin: 0.1),
              ],
            );
          },
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
                  _buildStatCard(
                    l10n.avg_rating,
                    truvState.averageRating,
                    AppAssets.coinsSvg,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fade(delay: 500.ms).slideY(begin: 0.1),
      ],
    ); // Copy your _buildAllTimeStats code here
  }
}

// --- REUSABLE COMPONENTS ---

Widget _buildEarningsComparisonRow(String name, String rate, double progress) {
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

Widget _buildStatCard(String label, String value, String icon) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20.w),
      // border: Border.all(color: const Color(0xFFF2F2F2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          // spreadRadius: 2,
          offset: const Offset(0, 2),
        ),
      ],
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

Widget _buildMilestoneCircle(
  BuildContext context,
  String status,
  String value,
  String unit,
  double progress,
  Color color,
) {
  final l10n = AppLocalizations.of(context)!;
  final bool isCompleted = progress >= 1.0;
  final bool isLocked =
      status == l10n.milestone_locked ||
      status == "Locked" ||
      status == "Milestone";
  // final bool isInProgress =
  //     status == l10n.milestone_in_progress || status == "In Progress";

  // Only use the active color if the milestone is 100% completed
  final statusColor = isCompleted ? color : const Color(0xFF999999);

  // Force "Milestone" text for locked items if that's what's requested
  final String statusText = isLocked ? "Milestone" : status;

  return Container(
    width: 140.w,
    // height: 160.h,
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),

    child: Stack(
      alignment: Alignment.center,
      children: [
        // Custom Arc Progress Indicator (Uniform 110-degree Gap)
        SizedBox(
          width: 130.w,
          height: 130.w,
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
            statusText,
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

Widget _getPlatformLogo(String name) {
  String logo = AppAssets.uberLogoPng;
  bool isBlack = true;
  if (name.toLowerCase().contains("lyft")) {
    logo = AppAssets.lyftLogoPng;
    isBlack = false;
  } else if (name.toLowerCase().contains("ayro")) {
    logo = AppAssets.ayroLogoPng;
    isBlack = true;
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(30.sp),
    child: Container(
      width: 32.w,
      height: 32.w,
      color: isBlack ? Colors.black : const Color(0xFFFF00BF),
      child: Image.asset(logo, fit: BoxFit.contain),
    ),
  );
}
