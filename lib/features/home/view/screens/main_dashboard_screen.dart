import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/rider/view/screens/select_location_screen.dart';
import 'package:rideiq/features/driver_dashboard/view/screens/driver_dashboard_view.dart';
import 'package:rideiq/features/rider/view/widgets/fare_bottom_nav.dart';
import 'package:rideiq/features/home/viewmodel/home_viewmodel.dart';

class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({super.key});

  final List<Widget> _screens = const [
    SelectLocationScreen(),
    DriverDashboardView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: FareBottomNav(
        currentIndex: currentIndex,
        onTabChanged: notifier.setTab,
      ),
    );
  }
}
