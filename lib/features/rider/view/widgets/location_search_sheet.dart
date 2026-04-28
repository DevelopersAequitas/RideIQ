import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/shared/widgets/app_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class LocationSearchSheet extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onDone;

  const LocationSearchSheet({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onDone,
  });

  @override
  State<LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<LocationSearchSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.w)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 14.sp,
                    fontFamily: 'Figtree',
                  ),
                ),
                _buildCurrentLocationBtn(context),
              ],
            ),
            SizedBox(height: 24.h),

            AppTextField(
              controller: _controller,
              label: l10n.search_location,
              prefix: Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF1D72DD),
                size: 20.sp,
              ),
            ),

            SizedBox(height: 32.h),
            const Divider(color: Color(0xFFF2F2F2)),

            // Suggestions
            _buildSuggestion("2458 Maple Ave", "Apt 3B — Brooklyn, NY"),
            _buildSuggestion("2458 Maple Ave", "Apt 3B — Brooklyn, NY"),

            SizedBox(height: 40.h),

            PrimaryButton(
              text: l10n.done,
              onPressed: () {
                widget.onDone(_controller.text);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationBtn(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Row(
        children: [
          Icon(Icons.my_location, color: const Color(0xFF1D72DD), size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            l10n.current_location,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(Icons.north_east, color: const Color(0xFF999999), size: 20.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Figtree',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade().slideX(begin: 0.05);
  }
}

