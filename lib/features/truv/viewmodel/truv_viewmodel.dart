import 'package:flutter/material.dart';
import 'package:rideiq/features/truv/repository/truv_repository.dart';
import 'package:rideiq/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideiq/core/utils/app_logger.dart';

import 'package:rideiq/core/services/local_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'truv_viewmodel.g.dart';

class TruvState {
  final bool isLoading;
  final String status;
  final Map<String, dynamic>? reportData;
  final Map<String, dynamic>? uberData;
  final Map<String, dynamic>? lyftData;
  final Map<String, dynamic>? ayroData;

  TruvState({
    this.isLoading = false,
    this.status = 'pending',
    this.reportData,
    this.uberData,
    this.lyftData,
    this.ayroData,
  });

  TruvState copyWith({
    bool? isLoading,
    String? status,
    Map<String, dynamic>? reportData,
    Map<String, dynamic>? uberData,
    Map<String, dynamic>? lyftData,
    Map<String, dynamic>? ayroData,
  }) {
    return TruvState(
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      reportData: reportData ?? this.reportData,
      uberData: uberData ?? this.uberData,
      lyftData: lyftData ?? this.lyftData,
      ayroData: ayroData ?? this.ayroData,
    );
  }

  Map<String, String> getPlatformStats(String platformName) {
    Map<String, dynamic>? data;
    if (platformName == "Uber") {
      data = uberData;
    } else if (platformName == "Lyft") {
      data = lyftData;
    } else if (platformName == "Ayro") {
      data = ayroData;
    } else {
      data = reportData;
    }
    debugPrint("data: $data");

    if (data == null) {
      return {
        "total": "\$0",
        "rate": "\$0/hr",
        "trips": "0",
        "hours": "0",
        "miles": "0",
        "tips": "\$0",
      };
    }

    try {
      final employment = data;
      final earnings =
          employment['total_earnings'] ?? employment['income']?['total'] ?? "0";
      final rate =
          employment['earnings_per_hour'] ??
          employment['income']?['hourly_rate'] ??
          "0";
      final trips =
          employment['total_trips'] ?? employment['trips_count'] ?? "0";
      final hours =
          employment['total_hours'] ?? employment['hours_worked'] ?? "0";
      final miles = employment['miles_driven'] ?? "0";
      final tips = employment['tips_earned'] ?? "0";

      return {
        "total": "\$${earnings.toString()}",
        "rate": "\$${rate.toString()}/hr",
        "trips": trips.toString(),
        "hours": hours.toString(),
        "miles": miles.toString(),
        "tips": "\$${tips.toString()}",
      };
    } catch (_) {
      return {
        "total": "\$0",
        "rate": "\$0/hr",
        "trips": "0",
        "hours": "0",
        "miles": "0",
        "tips": "\$0",
      };
    }
  }

  String get totalTrips {
    int total = 0;
    // Sum real trips
    final platforms = ["Uber", "Lyft", "Ayro"];
    bool hasAnyData = false;
    for (var p in platforms) {
      if (isPlatformConnected(p)) {
        final trips = int.tryParse(getPlatformStats(p)["trips"]!) ?? 0;
        if (trips > 0) {
          total += trips;
          hasAnyData = true;
        }
      }
    }

    // Fallback to mock for testing if connected but no data
    if (!hasAnyData) {
      if (isPlatformConnected("Uber")) total += 450;
      if (isPlatformConnected("Lyft")) total += 320;
    }

    return total.toString();
  }

  String get totalEarnings {
    double total = 0;
    bool hasAnyData = false;
    final platforms = ["Uber", "Lyft", "Ayro"];
    for (var p in platforms) {
      if (isPlatformConnected(p)) {
        final earningsStr = getPlatformStats(p)["total"]!.replaceAll("\$", "");
        final earnings = double.tryParse(earningsStr) ?? 0.0;
        if (earnings > 0) {
          total += earnings;
          hasAnyData = true;
        }
      }
    }

    // Fallback to mock for testing
    if (!hasAnyData) {
      if (isPlatformConnected("Uber")) total += 12450.50;
      if (isPlatformConnected("Lyft")) total += 8240.75;
    }

    return "\$${total.toStringAsFixed(2)}";
  }

  Map<String, dynamic>? get bestPlatform {
    final uber = getPlatformStats("Uber");
    final lyft = getPlatformStats("Lyft");
    final ayro = getPlatformStats("Ayro");

    final uberRate =
        double.tryParse(
          uber["rate"]!.replaceAll("\$", "").replaceAll("/hr", ""),
        ) ??
        0.0;
    final lyftRate =
        double.tryParse(
          lyft["rate"]!.replaceAll("\$", "").replaceAll("/hr", ""),
        ) ??
        0.0;
    final ayroRate =
        double.tryParse(
          ayro["rate"]!.replaceAll("\$", "").replaceAll("/hr", ""),
        ) ??
        0.0;

    // Fallback rates for mock testing if connected
    double finalUberRate = uberRate;
    double finalLyftRate = lyftRate;
    double finalAyroRate = ayroRate;

    if (uberRate == 0 && isPlatformConnected("Uber")) finalUberRate = 28.50;
    if (lyftRate == 0 && isPlatformConnected("Lyft")) finalLyftRate = 24.75;
    if (ayroRate == 0 && isPlatformConnected("Ayro")) finalAyroRate = 31.25;

    if (finalUberRate == 0 && finalLyftRate == 0 && finalAyroRate == 0) {
      return null;
    }

    if (finalAyroRate >= finalUberRate && finalAyroRate >= finalLyftRate) {
      return {"name": "Ayro", "rate": finalAyroRate.toStringAsFixed(2)};
    } else if (finalUberRate >= finalLyftRate) {
      return {"name": "Uber", "rate": finalUberRate.toStringAsFixed(2)};
    } else {
      return {"name": "Lyft", "rate": finalLyftRate.toStringAsFixed(2)};
    }
  }

  double getEarningsProgress(String platformName) {
    try {
      final stats = getPlatformStats(platformName);
      final earningsStr = stats["total"]!.replaceAll("\$", "");
      final earnings = double.tryParse(earningsStr) ?? 0.0;

      // Fallback progress for testing
      double finalEarnings = earnings;
      if (earnings == 0 && isPlatformConnected(platformName)) {
        finalEarnings = platformName == "Uber" ? 750.0 : 450.0;
      }

      // Example goal: \$1000
      final progress = (finalEarnings / 1000).clamp(0.0, 1.0);
      return progress;
    } catch (_) {
      return 0.0;
    }
  }

  List<double> getWeeklyEarningsData(String? platformName) {
    // 1. Check if the platform is connected
    if (platformName != null && !isPlatformConnected(platformName)) {
      return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    }

    // 2. Try to get real earnings history from the data
    Map<String, dynamic>? data;
    if (platformName == 'Uber') {
      data = uberData;
    } else if (platformName == 'Lyft') {
      data = lyftData;
    } else if (platformName == 'Ayro') {
      data = ayroData;
    } else {
      data = reportData;
    }

    if (data != null) {
      final earningsList = data['earnings'] as List?;
      if (earningsList != null && earningsList.isNotEmpty) {
        try {
          // Take the last 7 entries and map to amounts
          final lastSeven = earningsList.length > 7
              ? earningsList.sublist(earningsList.length - 7)
              : earningsList;

          return lastSeven.map((e) {
            final amount = e['amount'] ?? e['net_pay'] ?? 0.0;
            return double.tryParse(amount.toString()) ?? 0.0;
          }).toList();
        } catch (_) {
          // Fallback to mock data if parsing fails
        }
      }
    }

    // 3. Fallback to mock data for testing/demo
    if (platformName == 'Uber') {
      return [45, 82, 61, 95, 74, 58, 89];
    } else if (platformName == 'Lyft') {
      return [30, 60, 45, 80, 50, 40, 75];
    } else if (platformName == 'Ayro') {
      return [25, 45, 30, 50, 40, 35, 60];
    }
    return [45, 82, 61, 95, 74, 58, 89];
  }

  // ... (keeping other methods similar but updated for platform-specific data)

  bool isPlatformConnected(String platformName) {
    if (platformName == "Uber") {
      if (uberData != null) return true;
      // Safety fallback for sandbox: if verified globally, show as connected
      return status == 'verified' || status == 'done';
    }
    if (platformName == "Lyft") {
      if (lyftData != null) return true;
      // Safety fallback for sandbox: if verified globally, show as connected
      return status == 'verified' || status == 'done';
    }
    if (platformName == "Ayro") return ayroData != null;

    // Fallback to checking the aggregated report
    if (reportData == null) return false;
    try {
      final data = reportData!['data'];
      final employments = data['employments'] as List?;
      return employments?.any(
            (e) =>
                e['company']?['name']?.toString().toLowerCase().contains(
                  platformName.toLowerCase(),
                ) ??
                false,
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  // String get totalEarnings {
  //   if (reportData == null) return "\$0";
  //   try {
  //     final data = reportData!['data'];
  //     final earnings =
  //         data['total_earnings'] ?? data['earnings']?['total'] ?? 0;
  //     return "\$${earnings.toString()}";
  //   } catch (_) {
  //     return "\$0";
  //   }
  // }

  String get earningsPerHour {
    if (reportData == null) return "\$0.00";
    try {
      final data = reportData!['data'];
      final rate =
          data['earnings_per_hour'] ?? data['earnings']?['hourly_rate'] ?? 0;
      return "\$${rate.toString()}";
    } catch (_) {
      return "\$0.00";
    }
  }

  // String get totalTrips {
  //   if (reportData == null) return "0";
  //   try {
  //     final data = reportData!['data'];
  //     final trips = data['total_trips'] ?? data['trips_count'] ?? 0;
  //     return trips.toString();
  //   } catch (_) {
  //     return "0";
  //   }
  // }

  String get totalHours {
    if (reportData == null) return "0";
    try {
      final data = reportData!['data'];
      final hours = data['total_hours'] ?? data['hours_worked'] ?? 0;
      return hours.toString();
    } catch (_) {
      return "0";
    }
  }

  String get idleTime {
    if (reportData == null) return "0h 0m";
    try {
      final data = reportData!['data'];
      final idle = data['idle_time'] ?? "0h 0m";
      return idle.toString();
    } catch (_) {
      return "0h 0m";
    }
  }

  String get acceptanceRate {
    if (reportData == null) return "0%";
    try {
      final data = reportData!['data'];
      final rate = data['acceptance_rate'] ?? 0;
      return "$rate%";
    } catch (_) {
      return "0%";
    }
  }

  String get averageRating {
    if (reportData == null) return "0.0";
    try {
      final data = reportData!['data'];
      final rating = data['average_rating'] ?? data['rating'] ?? 0.0;
      return rating.toString();
    } catch (_) {
      return "0.0";
    }
  }

  //   Map<String, dynamic>? get bestPlatform {
  //     if (reportData == null) return null;
  //     try {
  //       final data = reportData!['data'];
  //       final employments = data['employments'] as List?;
  //       if (employments == null || employments.isEmpty) return null;

  //       var bestEmp = employments[0];
  //       double maxRate =
  //           double.tryParse(
  //             (bestEmp['earnings_per_hour'] ?? bestEmp['income']?['hourly_rate'])
  //                     ?.toString() ??
  //                 "0",
  //           ) ??
  //           0.0;

  //       for (var emp in employments) {
  //         double currentRate =
  //             double.tryParse(
  //               (emp['earnings_per_hour'] ?? emp['income']?['hourly_rate'])
  //                       ?.toString() ??
  //                   "0",
  //             ) ??
  //             0.0;
  //         if (currentRate > maxRate) {
  //           maxRate = currentRate;
  //           bestEmp = emp;
  //         }
  //       }

  //       return {
  //         "name": bestEmp['company']?['name']?.toString() ?? "Unknown",
  //         "rate": maxRate.toStringAsFixed(2),
  //       };
  //     } catch (_) {
  //       return null;
  //     }
  //   }
}

@riverpod
class TruvViewModel extends _$TruvViewModel {
  @override
  TruvState build() {
    return TruvState();
  }

  Future<String?> createBridgeToken() async {
    state = state.copyWith(isLoading: true);
    AppLogger.info('>>> Preparing Truv Flow...', tag: 'TruvFlow');

    try {
      // 1. Check if we have the backend bearer token
      String? backendToken = await LocalService.getAuthToken();

      if (backendToken == null || backendToken.isEmpty) {
        AppLogger.info(
          'Backend token missing. Attempting to sync with backend first...',
          tag: 'TruvFlow',
        );

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firebaseToken = await user.getIdToken(true);
          final nameParts = user.displayName?.split(' ') ?? [];
          final firstName = nameParts.isNotEmpty ? nameParts.first : '';
          final lastName = nameParts.length > 1 ? nameParts.last : '';

          await ref
              .read(authRepositoryProvider)
              .verifyBackend(
                token: firebaseToken.toString(),
                firstName: firstName,
                lastName: lastName,
                email: user.email ?? '',
                role: 'driver',
              );

          // Refresh local variable
          backendToken = await LocalService.getAuthToken();
        }
      }

      if (backendToken == null || backendToken.isEmpty) {
        AppLogger.error(
          'FAILED: Could not obtain backend bearer token',
          tag: 'TruvFlow',
        );
        return null;
      }

      // 2. Now call create-token with the backend token (handled by ApiService interceptor)
      AppLogger.info('Requesting Bridge Token...', tag: 'TruvFlow');
      final data = await ref.read(truvRepositoryProvider).createBridgeToken();
      if (!ref.mounted) return null;

      if (data != null) {
        final token = data['bridge_token'];
        if (token != null) {
          await LocalService.setBridgeToken(token);
          if (!ref.mounted) return token;
          AppLogger.info(
            'SUCCESS: Bridge Token cached: ${token.substring(0, 10)}...',
            tag: 'TruvFlow',
          );
          return token;
        }
      }
      AppLogger.error('FAILED: No bridge_token in response', tag: 'TruvFlow');
      return null;
    } catch (e) {
      if (!ref.mounted) return null;
      AppLogger.error(
        'CRITICAL: Error in createBridgeToken',
        error: e,
        tag: 'TruvFlow',
      );
      return null;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<bool> exchangeToken(String publicToken) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await ref
          .read(truvRepositoryProvider)
          .exchangeToken(publicToken);
      if (!ref.mounted) return success;
      return success;
    } catch (e) {
      if (!ref.mounted) return false;
      AppLogger.error('Error exchanging token', error: e, tag: 'TruvVM');
      return false;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<Map<String, dynamic>?> checkStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await ref.read(truvRepositoryProvider).checkStatus();
      if (!ref.mounted) return result;

      if (result != null) {
        final status = result['verification_status'] ?? 'pending';
        state = state.copyWith(status: status);

        // If verified, immediately fetch the report to populate platform data
        if (status == 'verified' || status == 'done') {
          fetchReport();
        }
      }

      return result;
    } catch (e) {
      if (!ref.mounted) return null;
      AppLogger.error('Error checking status', error: e, tag: 'TruvVM');
      return null;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<Map<String, dynamic>?> fetchReport() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await ref.read(truvRepositoryProvider).fetchReport();
      if (!ref.mounted) return result;

      if (result != null) {
        // Initial state update with aggregated report
        state = state.copyWith(reportData: result);

        // Filter and populate platform-specific data for accurate "Connected" UI
        final data = result['data'];
        if (data != null) {
          final employments = data['employments'] as List?;
          if (employments != null) {
            Map<String, dynamic>? uber;
            Map<String, dynamic>? lyft;
            Map<String, dynamic>? ayro;

            for (var emp in employments) {
              final companyName =
                  emp['company']?['name']?.toString().toLowerCase() ?? "";
              if (companyName.contains("uber")) {
                uber = emp;
              } else if (companyName.contains("lyft")) {
                lyft = emp;
              } else if (companyName.contains("ayro")) {
                ayro = emp;
              } else if (companyName.contains("acme")) {
                // For testing: map sandbox data to both Uber and Lyft
                uber = emp;
                lyft = emp;
              }
            }

            state = state.copyWith(
              isLoading: false,
              reportData: result,
              uberData: uber,
              lyftData: lyft,
              ayroData: ayro,
            );
          }
        }
        AppLogger.info(
          'SUCCESS: Report data cached and filtered by platform',
          tag: 'TruvFlow',
        );
      }

      return result;
    } catch (e) {
      if (!ref.mounted) return null;
      AppLogger.error('Error fetching report', error: e, tag: 'TruvVM');
      return null;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}
