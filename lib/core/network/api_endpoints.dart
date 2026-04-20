class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://cruelly-unblistered-hedy.ngrok-free.dev';

  static const String login = '/auth/login';
  static const String productsByStatus = '/products/by-status';

  static String updateProductStatus(String id) => '/products/$id/status';
}
