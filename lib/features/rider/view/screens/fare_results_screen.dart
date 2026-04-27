import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/rider/model/fare_result.dart';
import 'package:rideiq/features/rider/view/widgets/location_summary_header.dart';
import 'package:rideiq/features/rider/view/widgets/fare_list_item.dart';
import 'package:rideiq/features/rider/viewmodel/fare_comparison_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FareResultsScreen extends ConsumerStatefulWidget {
  const FareResultsScreen({super.key});

  @override
  ConsumerState<FareResultsScreen> createState() => _FareResultsScreenState();
}

class _FareResultsScreenState extends ConsumerState<FareResultsScreen> {
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(fareComparisonViewModelProvider);

    final filteredFares = _selectedCategory == "All"
        ? mockFares
        : mockFares.where((f) => f.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Fixed Summary Header
            LocationSummaryHeader(
              pickup:
                  '${locationState.pickup.split(' ').first}...', // Shorten for UI
              stop: locationState.stops.isNotEmpty ? "Stop" : "None",
              dropoff: '${locationState.dropoff.split(' ').first}...',
              onEditTap: () => Navigator.pop(context),
            ),

            // 2. Filters & List Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // Category Filters
                      Row(
                        children: [
                          _buildFilterPill("All"),
                          SizedBox(width: 12.w),
                          _buildFilterPill("Economy"),
                          SizedBox(width: 12.w),
                          _buildFilterPill("Premium"),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Fare List
                      ...filteredFares.map(
                        (fare) => FareListItem(
                          fare: fare,
                        ).animate().fade().slideY(begin: 0.1),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF2FD) : Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D72DD).withValues(alpha: 0.1)
                : const Color(0xFFF2F2F2),
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF1D72DD)
                : const Color(0xFF1A1A1A),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14.sp,
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }
}
