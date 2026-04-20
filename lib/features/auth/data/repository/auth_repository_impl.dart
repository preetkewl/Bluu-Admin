import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SharedPreferences _prefs;

  const AuthRepositoryImpl(this._remoteDataSource, this._prefs);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password,
      deviceId: AppConstants.loginDeviceId,
      deviceName: AppConstants.loginDeviceName,
      platform: AppConstants.loginPlatform,
    );

    final user = await _remoteDataSource.login(request);

    if (user.token.isNotEmpty) {
      await _prefs.setString(AppConstants.authTokenKey, user.token);
      await _prefs.setString(AppConstants.userEmailKey, user.email);
    }

    return user;
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(AppConstants.authTokenKey);
    await _prefs.remove(AppConstants.userEmailKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(AppConstants.authTokenKey);
    return token != null && token.isNotEmpty;
  }
}
