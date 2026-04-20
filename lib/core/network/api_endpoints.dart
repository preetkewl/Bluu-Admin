class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:5000';

  static const String login = '/auth/login';
  static const String productsByStatus = '/products/by-status';

  static String updateProductStatus(String id) => '/products/$id/status';
}
