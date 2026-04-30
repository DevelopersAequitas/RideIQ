import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class DashboardTabs extends ConsumerWidget {
  const DashboardTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final notifier = ref.read(dashboardViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
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
}
