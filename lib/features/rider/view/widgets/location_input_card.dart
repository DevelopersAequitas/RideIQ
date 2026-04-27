import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class LocationInputCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final List<String> stops;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final Function(int) onStopTap;
  final Function(int) onRemoveStop; // New: Callback to remove stop
  final VoidCallback onAddStopTap;

  const LocationInputCard({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.stops,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onStopTap,
    required this.onRemoveStop,
    required this.onAddStopTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pickup
          _LocationField(
            label: "Pickup location",
            value: pickup,
            onTap: onPickupTap,
            indicator: _buildIndicator(isCircle: true, showLine: true),
          ),

          // Dynamic Stops
          ...List.generate(stops.length, (index) {
            return _LocationField(
              label: "Stop ${index + 1}",
              value: stops[index],
              onTap: () => onStopTap(index),
              onRemove: () => onRemoveStop(index), // Pass remove callback
              indicator: _buildIndicator(isCircle: true, showLine: true),
            );
          }),

          // Divider & Add Stop Row with connected line
          Row(
            children: [
              // Continuous line segment for the Add Stop section
              _buildIndicator(isCircle: false, showLine: true, isGhost: true),
              SizedBox(width: 20.w),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 40.h,
                        color: const Color(0xFFF2F2F2),
                      ),
                    ),
                    GestureDetector(
                      onTap: onAddStopTap,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: const Color(0xFF1D72DD),
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Add Stop",
                            style: TextStyle(
                              color: const Color(0xFF1D72DD),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Dropoff
          _LocationField(
            label: "Drop location",
            value: dropoff,
            onTap: onDropoffTap,
            indicator: _buildIndicator(isCircle: false, showLine: false),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({
    required bool isCircle,
    required bool showLine,
    bool isGhost = false, // New: if true, only show the line, not the dot
  }) {
    return Column(
      children: [
        if (!isGhost)
          Container(
            height: 12.w,
            width: 12.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1D72DD),
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(3.w),
            ),
          )
        else
          SizedBox(height: 12.w, width: 12.w), // Placeholder for dot space
        if (showLine)
          CustomPaint(size: Size(1.5, 42.h), painter: DottedLinePainter()),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D72DD)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashHeight = 3;
    const double dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _LocationField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final Widget indicator;

  const _LocationField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onRemove,
    required this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        indicator,
        SizedBox(width: 20.w),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 12.sp,
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
        if (onRemove != null)
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.close,
                color: const Color(0xFF999999),
                size: 18.sp,
              ),
            ),
          ),
      ],
    );
  }
}
