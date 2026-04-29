import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class TodayStatsView extends ConsumerWidget {
  const TodayStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dashboardViewModelProvider);
    final notifier = ref.read(dashboardViewModelProvider.notifier);
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
              SizedBox(height: 12.h),
              _buildEarningsRow(
                "Ayro",
                AppAssets.ayroLogoPng,
                truvState.getPlatformStats("Ayro")["rate"]!,
                truvState.getPlatformStats("Ayro")["total"]!,
                truvState.getEarningsProgress("Ayro"),
                state.selectedPlatform == "Ayro",
                () => notifier.selectPlatform("Ayro"),
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
