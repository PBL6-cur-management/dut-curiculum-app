import 'package:cookie_jar/cookie_jar.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/contract_exception.dart';
import '../domain/model/session_user.dart';
import '../domain/repository/auth_repository.dart';
import 'remote/auth_api.dart';
import 'remote/dto/change_password_request_dto.dart';
import 'remote/dto/login_request_dto.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._jar);

  final AuthApi _api;
  final PersistCookieJar _jar;

  @override
  Future<SessionUser> login(String username, String password) async =>
      (await _api.login(
        LoginRequestDto(username: username, password: password),
      )).toDomain();

  @override
  Future<SessionUser?> currentUser() async {
    final saved = await _jar.loadForRequest(Uri.parse(ApiConfig.baseUrl));
    if (saved.isEmpty) {
      return null;
    }
    try {
      return (await _api.currentUser()).toDomain();
    } on ApiException catch (error) {
      if (error.isSessionRequired) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    Object? requestError;
    StackTrace? requestStack;
    try {
      await _api.logout();
    } catch (error, stack) {
      requestError = error;
      requestStack = stack;
    }
    try {
      await _jar.deleteAll();
    } catch (cleanupError) {
      if (requestError != null) {
        throw ContractException('$requestError\n$cleanupError');
      }
      rethrow;
    }
    if (requestError != null) {
      Error.throwWithStackTrace(requestError, requestStack!);
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) =>
      _api.changePassword(
        ChangePasswordRequestDto(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
}
