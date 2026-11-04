import 'package:equatable/equatable.dart';

class SessionUser extends Equatable {
  const SessionUser({
    required this.id,
    required this.username,
    required this.userCode,
    required this.fullName,
    required this.email,
    required this.mustChangePassword,
    required this.roleNames,
  });

  final String id;
  final String username;
  final String userCode;
  final String fullName;
  final String? email;
  final bool mustChangePassword;
  final List<String> roleNames;

  SessionUser copyWith({bool? mustChangePassword}) => SessionUser(
    id: id,
    username: username,
    userCode: userCode,
    fullName: fullName,
    email: email,
    mustChangePassword: mustChangePassword ?? this.mustChangePassword,
    roleNames: roleNames,
  );

  @override
  List<Object?> get props => [
    id,
    username,
    userCode,
    fullName,
    email,
    mustChangePassword,
    roleNames,
  ];
}
