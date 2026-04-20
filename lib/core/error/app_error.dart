import 'package:dio/dio.dart';

class AppError {
  final String message;
  final int? statusCode;

  const AppError({required this.message, this.statusCode});

  factory AppError.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppError(message: 'Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppError(message: 'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        String message = 'An error occurred.';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else if (data is Map && data['error'] != null) {
          message = data['error'].toString();
        }
        return AppError(message: message, statusCode: statusCode);
      default:
        return const AppError(message: 'Something went wrong. Please try again.');
    }
  }

  factory AppError.fromException(Exception e) {
    return AppError(message: e.toString());
  }
}
