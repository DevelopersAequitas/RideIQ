import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fare_comparison_viewmodel.g.dart';

class FareComparisonState {
  final String pickup;
  final String dropoff;
  final List<String> stops;

  FareComparisonState({
    this.pickup = "2458 Maple Ave",
    this.dropoff = "123 Main St",
    this.stops = const [],
  });

  FareComparisonState copyWith({
    String? pickup,
    String? dropoff,
    List<String>? stops,
  }) {
    return FareComparisonState(
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      stops: stops ?? this.stops,
    );
  }
}

@riverpod
class FareComparisonViewModel extends _$FareComparisonViewModel {
  @override
  FareComparisonState build() => FareComparisonState();

  void updatePickup(String value) => state = state.copyWith(pickup: value);
  void updateDropoff(String value) => state = state.copyWith(dropoff: value);
  
  void addStop() {
    state = state.copyWith(stops: [...state.stops, "Select stop"]);
  }

  void updateStop(int index, String value) {
    final newStops = List<String>.from(state.stops);
    newStops[index] = value;
    state = state.copyWith(stops: newStops);
  }

  void removeStop(int index) {
    final newStops = List<String>.from(state.stops);
    newStops.removeAt(index);
    state = state.copyWith(stops: newStops);
  }
}
