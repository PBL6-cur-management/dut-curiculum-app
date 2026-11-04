import 'package:injectable/injectable.dart';

import '../model/session_user.dart';
import '../repository/auth_repository.dart';

@injectable
class AuthUseCases {
  AuthUseCases(this._repository);

  final AuthRepository _repository;

  Future<SessionUser> login(String username, String password) =>
      _repository.login(username, password);

  Future<SessionUser?> currentUser() => _repository.currentUser();

  Future<void> logout() => _repository.logout();

  Future<void> changePassword(String currentPassword, String newPassword) =>
      _repository.changePassword(currentPassword, newPassword);
}
