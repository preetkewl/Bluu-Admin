class LoginRequestModel {
  final String email;
  final String password;
  final String deviceId;
  final String deviceName;
  final String platform;

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'platform': platform,
      };
}
