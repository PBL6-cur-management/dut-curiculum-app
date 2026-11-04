import '../model/session_user.dart';

abstract class AuthRepository {
  Future<SessionUser> login(String username, String password);
  Future<SessionUser?> currentUser();
  Future<void> logout();
  Future<void> changePassword(String currentPassword, String newPassword);
}
