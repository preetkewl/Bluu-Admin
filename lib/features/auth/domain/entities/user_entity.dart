import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String token;
  final String? name;

  const UserEntity({
    required this.email,
    required this.token,
    this.name,
  });

  @override
  List<Object?> get props => [email, token, name];
}
