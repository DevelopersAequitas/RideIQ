import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  int build() => 0; // Default to Rider tab (index 0)

  void setTab(int index) {
    state = index;
  }
}
