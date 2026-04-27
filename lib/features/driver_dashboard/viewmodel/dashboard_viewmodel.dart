import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_viewmodel.g.dart';

enum DashboardTab { today, weekly, allTime }

class DashboardState {
  final DashboardTab selectedTab;
  final String? selectedPlatform; // null means 'all platforms'
  final bool isDashboardActive; // false means show 'Link Platform' cards
  final bool isLoading;

  DashboardState({
    this.selectedTab = DashboardTab.today,
    this.selectedPlatform,
    this.isDashboardActive = false,
    this.isLoading = false,
  });

  DashboardState copyWith({
    DashboardTab? selectedTab,
    String? selectedPlatform,
    bool? isDashboardActive,
    bool? isLoading,
  }) {
    return DashboardState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedPlatform: selectedPlatform,
      isDashboardActive: isDashboardActive ?? this.isDashboardActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  DashboardState build() => DashboardState();

  void selectTab(DashboardTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void selectPlatform(String platform) {
    if (state.selectedPlatform == platform) {
      state = state.copyWith(selectedPlatform: null);
    } else {
      state = state.copyWith(selectedPlatform: platform);
    }
  }

  void activateDashboard() {
    state = state.copyWith(isDashboardActive: true);
  }
}
