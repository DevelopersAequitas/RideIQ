import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class LocationSummaryHeader extends ConsumerWidget {
  final String pickup;
  final List<String> stops;
  final String dropoff;
  final VoidCallback onEditTap;

  const LocationSummaryHeader({
    super.key,
    required this.pickup,
    required this.stops,
    required this.dropoff,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(color: const Color(0xFFF2F2F2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 18.sp, color: Colors.black),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.edit_locations,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
          SizedBox(height: 30.h),

          // Horizontal Route Timeline - DOTS ONLY
          Row(
            children: [
              _buildDot(isCircle: true),
              Expanded(child: _buildDottedLine()),
              _buildDot(isCircle: true, isOutline: true),
              Expanded(child: _buildDottedLine()),
              _buildDot(isCircle: false),
            ],
          ),
          SizedBox(height: 12.h),

          // Labels & Addresses Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLabelColumn(
                  l10n.pickup_location,
                  pickup,
                  CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: _buildLabelColumn(
                  stops.length > 1 ? l10n.stops_label : l10n.stop_label,
                  stops.isNotEmpty
                      ? stops.join(', ')
                      : l10n.none,
                  CrossAxisAlignment.center,
                ),
              ),
              Expanded(
                child: _buildLabelColumn(
                  l10n.drop_location,
                  dropoff,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isCircle, bool isOutline = false}) {
    return Container(
      height: 12.w,
      width: 12.w,
      decoration: BoxDecoration(
        color: isOutline ? Colors.white : const Color(0xFF1D72DD),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(3.w),
        border: isOutline
            ? Border.all(color: const Color(0xFF1D72DD), width: 2.w)
            : null,
      ),
    );
  }

  Widget _buildLabelColumn(
    String label,
    String address,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF999999),
            fontFamily: 'Figtree',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              (constraints.constrainWidth() / 6).floor(),
              (index) => SizedBox(
                width: 3.w,
                height: 1.5.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D72DD).withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
