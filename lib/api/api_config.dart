/// API Configuration
class ApiConfig {
  // Base URL for the backend API
  // Change this to your server's IP address if testing on physical device
  // For Android emulator, use 10.0.2.2
  // For iOS simulator, use localhost or 127.0.0.1
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints
  static const String authEndpoint = '/auth';
  static const String offersEndpoint = '/offers';
  
  // Full URLs
  static String get registerUrl => '$baseUrl$authEndpoint/register';
  static String get loginUrl => '$baseUrl$authEndpoint/login';
  static String get offersUrl => '$baseUrl$offersEndpoint';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithAuth(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
