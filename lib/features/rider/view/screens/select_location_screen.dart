import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/rider/viewmodel/fare_comparison_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/features/rider/view/widgets/location_input_card.dart';
import 'package:rideiq/features/rider/view/widgets/recent_location_item.dart';
import 'package:rideiq/features/rider/view/widgets/location_search_sheet.dart';
import 'package:rideiq/features/rider/view/screens/fare_results_screen.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelectLocationScreen extends ConsumerWidget {
  const SelectLocationScreen({super.key});

  void _openLocationSheet(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onDone,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LocationSearchSheet(
          title: title,
          initialValue: initialValue,
          onDone: onDone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fareComparisonViewModelProvider);
    final notifier = ref.read(fareComparisonViewModelProvider.notifier);
    final profileState = ref.watch(profileViewModelProvider);

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.surface.withValues(alpha: 0.8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // Standardized Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.search_location,
                      style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ProfileScreen(isDriverMode: false),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
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
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20.w,
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
                SizedBox(height: 25.h),

                // 1. Location Input Card
                LocationInputCard(
                  pickup: state.pickup,
                  dropoff: state.dropoff,
                  stops: state.stops,
                  onPickupTap: () => _openLocationSheet(
                    context,
                    l10n.pickup_location,
                    state.pickup,
                    notifier.updatePickup,
                  ),
                  onDropoffTap: () => _openLocationSheet(
                    context,
                    l10n.drop_location,
                    state.dropoff,
                    notifier.updateDropoff,
                  ),
                  onStopTap: (index) => _openLocationSheet(
                    context,
                    "${l10n.stop_label} ${index + 1}",
                    state.stops[index],
                    (val) => notifier.updateStop(index, val),
                  ),
                  onRemoveStop: (index) => notifier.removeStop(index),
                  onAddStopTap: () => notifier.addStop(),
                ).animate().fade().slideY(begin: 0.1),

                SizedBox(height: 24.h),

                // 2. Main Action Button
                PrimaryButton(
                  text: l10n.compare_fares,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FareResultsScreen(),
                      ),
                    );
                  },
                ).animate().scale(delay: 200.ms),

                SizedBox(height: 32.h),
                Divider(height: 1, color: const Color(0xFFE6E8EB)),
                SizedBox(height: 20.h),
                // 3. Recent Locations Section
                Text(
                  l10n.recent_locations,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 16.h),

                // List of Recents
                ...[
                  {
                    "title": "2458 Maple Ave",
                    "subtitle": "Apt 3B — Brooklyn, NY",
                  },
                  {
                    "title": "Grand Central Terminal",
                    "subtitle": "89 E 42nd St, New York",
                  },
                  {
                    "title": "Brooklyn Bridge",
                    "subtitle": "New York, NY 10038",
                  },
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final loc = entry.value;
                  return RecentLocationItem(
                        title: loc["title"]!,
                        subtitle: loc["subtitle"]!,
                        onTap: () {
                          notifier.updateDropoff(loc["title"]!);
                        },
                      )
                      .animate()
                      .fade(delay: (300 + (index * 100)).ms)
                      .slideX(begin: 0.05);
                }),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
