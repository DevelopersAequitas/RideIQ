import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/notifications/viewmodel/notification_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationViewModelProvider);
    final notifier = ref.read(notificationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.notifications_title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 12.h),
            child: OutlinedButton(
              onPressed: notifier.clearAll,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF2F2F2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.w),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text(
                l10n.clear,
                style: TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 32.h,
                thickness: 1,
                color: const Color(0xFFF2F2F2),
                indent: 20.w,
                endIndent: 20.w,
              ),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        height: 48.w,
                        width: 48.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        padding: EdgeInsets.all(10.w),
                        child: SvgPicture.asset(
                          item.icon,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1E74E9),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                                fontFamily: 'Figtree',
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              item.content,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF666666),
                                fontFamily: 'Figtree',
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF999999),
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(delay: (index * 100).ms).slideX(begin: 0.1);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64.sp, color: const Color(0xFFF2F2F2)),
          SizedBox(height: 16.h),
          Text(
            l10n.no_notifications_yet,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF999999),
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }
}

