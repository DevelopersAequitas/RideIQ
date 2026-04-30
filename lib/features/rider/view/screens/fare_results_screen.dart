import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/rider/model/fare_result.dart';
import 'package:rideiq/features/rider/view/widgets/location_summary_header.dart';
import 'package:rideiq/features/rider/view/widgets/fare_list_item.dart';
import 'package:rideiq/features/rider/viewmodel/fare_comparison_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

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

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Fixed Summary Header
            LocationSummaryHeader(
              pickup: locationState.pickup.split(',').first,
              stops: locationState.stops
                  .map((s) => s.split(',').first)
                  .toList(),
              dropoff: locationState.dropoff.split(',').first,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: [
                            _buildFilterPill("All", l10n.filter_all),
                            SizedBox(width: 12.w),
                            _buildFilterPill("Economy", l10n.filter_economy),
                            SizedBox(width: 12.w),
                            _buildFilterPill("Premium", l10n.filter_premium),
                          ],
                        ),
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

  Widget _buildFilterPill(String category, String label) {
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
          label,
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
