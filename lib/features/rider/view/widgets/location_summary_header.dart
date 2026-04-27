import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/profile/view/screens/profile_screen.dart';

class LocationSummaryHeader extends StatelessWidget {
  final String pickup;
  final String stop;
  final String dropoff;
  final VoidCallback onEditTap;

  const LocationSummaryHeader({
    super.key,
    required this.pickup,
    required this.stop,
    required this.dropoff,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
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
                        "Edit locations",
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
                  backgroundImage: const NetworkImage(
                    "https://i.pravatar.cc/150?u=a042581f4e29026704d",
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
              _buildLabelColumn(
                "Pickup location",
                pickup,
                CrossAxisAlignment.start,
              ),
              _buildLabelColumn("Stop", stop, CrossAxisAlignment.center),
              _buildLabelColumn(
                "Drop location",
                dropoff,
                CrossAxisAlignment.end,
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
    return SizedBox(
      width: 100.w,
      child: Column(
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
      ),
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
