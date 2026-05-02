class ApiEndpoints {
  ApiEndpoints._();

  // Pass at build time: flutter run --dart-define=BASE_URL=https://your-api.com
  // Falls back to localhost for development.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String login = '/auth/login';
  static const String productsByStatus = '/products/by-status';

  static String updateProductStatus(String id) => '/products/$id/status';
}
