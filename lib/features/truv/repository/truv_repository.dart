import 'dart:convert';
import 'package:rideiq/core/constants/api_constants.dart';
import 'package:rideiq/core/services/api_service.dart';
import 'package:rideiq/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'truv_repository.g.dart';

@riverpod
TruvRepository truvRepository(Ref ref) {
  return TruvRepository(ref.read(apiServiceProvider));
}

class TruvRepository {
  final ApiService _apiService;

  TruvRepository(this._apiService);

  Future<Map<String, dynamic>?> createBridgeToken({String? companyId}) async {
    final response = await _apiService.post(
      ApiConstants.driverTruvCreateToken,
      data: companyId != null ? {'company_mapping_id': companyId} : null,
    );
    AppLogger.info('Truv Response Data: ${response.data}', tag: 'TruvRepo');
    
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['status'] == true) {
        return data;
      }
    } else if (data is String) {
      // Manual fallback if Dio didn't parse it
      try {
        final decoded = jsonDecode(data);
        if (decoded['status'] == true) {
          return decoded;
        }
      } catch (_) {}
    }
    return null;
  }

  Future<bool> exchangeToken(String publicToken) async {
    final response = await _apiService.post(
      ApiConstants.driverTruvExchangeToken,
      data: {'public_token': publicToken},
    );
    return response.data['status'] == true;
  }

  Future<Map<String, dynamic>?> checkStatus() async {
    final response = await _apiService.get(ApiConstants.driverTruvStatus);
    if (response.data['status'] == true) {
      return response.data['data'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchReport() async {
    final response = await _apiService.get(ApiConstants.driverTruvReport);
    if (response.data['status'] == true) {
      return response.data['data'];
    }
    return null;
  }
}
