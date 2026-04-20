import 'package:dio/dio.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
      throw const AppError(message: 'Invalid response format');
    } on DioException catch (e) {
      throw AppError.fromDioException(e);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(message: e.toString());
    }
  }
}
