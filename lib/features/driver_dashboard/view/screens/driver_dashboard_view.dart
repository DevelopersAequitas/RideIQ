import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/all_time_stats_view.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/dashboard_header.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/dashboard_link_view.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/dashboard_tabs.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/today_stats_view.dart';
import 'package:rideiq/features/driver_dashboard/view/widgets/weekly_stats_view.dart';
import 'package:rideiq/features/driver_dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart';

class DriverDashboardView extends ConsumerStatefulWidget {
  const DriverDashboardView({super.key});

  @override
  ConsumerState<DriverDashboardView> createState() =>
      _DriverDashboardViewState();
}

class _DriverDashboardViewState extends ConsumerState<DriverDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(truvViewModelProvider.notifier).checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (!state.isDashboardActive)
                      DashboardLinkView()
                    else ...[
                      DashboardTabs(),
                      if (state.selectedTab == DashboardTab.today)
                        TodayStatsView()
                      else if (state.selectedTab == DashboardTab.weekly)
                        WeeklyStatsView()
                      else
                        AllTimeStatsView(),
                    ],
                    // SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
