import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class WeeklyStatsView extends ConsumerWidget {
  const WeeklyStatsView({super.key});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
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
          "Ayro",
          AppAssets.ayroLogoPng,
          state.selectedPlatform == "Ayro",
        ),
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
              color: (title == "Uber" || title == "Ayro") ? Colors.black : const Color(0xFFFF00BF),
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
