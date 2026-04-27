import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/core/constants/app_assets.dart';

part 'notification_viewmodel.g.dart';

class AppNotification {
  final String id;
  final String title;
  final String content;
  final String time;
  final String icon;

  AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.icon,
  });
}

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  @override
  List<AppNotification> build() {
    return [
      AppNotification(
        id: "1",
        title: "Fare Alert",
        content: "A ride is now cheaper on Lyft for your saved route Home -> Work",
        time: "2 hours ago",
        icon: AppAssets.currencyCircleDollarSvg,
      ),
      AppNotification(
        id: "2",
        title: "Driver Insight",
        content: "You earned more per hour on Uber this week compared to other platforms.",
        time: "2 hours ago",
        icon: AppAssets.trendUpSvg,
      ),
      AppNotification(
        id: "3",
        title: "Weekly Recap",
        content: "Your weekly earnings recap is ready. You completed 78 trips and earned \$1,245.",
        time: "2 days ago",
        icon: AppAssets.calendarDotSvg,
      ),
      AppNotification(
        id: "4",
        title: "Fare Alert",
        content: "Prices have dropped 15% for rides to Downtown.",
        time: "2 days ago",
        icon: AppAssets.currencyCircleDollarSvg,
      ),
    ];
  }

  void clearAll() {
    state = [];
  }
}
