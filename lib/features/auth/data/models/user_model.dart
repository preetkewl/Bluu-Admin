import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.token,
    super.name,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Token may be under 'accessToken' or 'token' at root or nested under 'data'
    final String token =
        json['accessToken'] as String? ??
        json['token'] as String? ??
        (json['data'] as Map<String, dynamic>?)?['accessToken'] as String? ??
        (json['data'] as Map<String, dynamic>?)?['token'] as String? ??
        '';

    // User info may be nested under 'user' or flat at root
    final userMap = json['user'] as Map<String, dynamic>?;

    final String email =
        userMap?['email'] as String? ??
        json['email'] as String? ??
        (json['data'] as Map<String, dynamic>?)?['email'] as String? ??
        '';

    final String? name =
        userMap?['fullName'] as String? ??
        userMap?['name'] as String? ??
        json['name'] as String? ??
        (json['data'] as Map<String, dynamic>?)?['name'] as String?;

    final String? role =
        userMap?['role'] as String? ??
        json['role'] as String? ??
        (json['data'] as Map<String, dynamic>?)?['role'] as String?;

    return UserModel(email: email, token: token, name: name, role: role);
  }

  UserModel copyWith({String? email, String? token, String? name, String? role}) {
    return UserModel(
      email: email ?? this.email,
      token: token ?? this.token,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
        if (name != null) 'name': name,
        if (role != null) 'role': role,
      };
}
