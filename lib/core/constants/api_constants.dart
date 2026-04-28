class ApiConstants {
  static const String baseUrl = 'https://amiee-daimonic-shantelle.ngrok-free.dev/api';
  
  // Auth Endpoints
  static const String verifyAuth = '/v1/auth/verify';

  // User Profile
  static const String userProfile = '/v1/user/profile';
  static const String userProfileUpdate = '/v1/user/profile/update';

  // Driver Truv Endpoints
  static const String driverTruvCreateToken = '/driver/truv/create-token';
  static const String driverTruvExchangeToken = '/driver/truv/exchange-token';
  static const String driverTruvStatus = '/driver/truv/status';
  static const String driverTruvReport = '/driver/truv/report';
}
