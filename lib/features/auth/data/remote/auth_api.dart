import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_paths.dart';
import '../../../../core/network/contract_exception.dart';
import 'dto/change_password_request_dto.dart';
import 'dto/login_request_dto.dart';
import 'dto/me_dto.dart';

@singleton
class AuthApi {
  AuthApi(this._dio, this._strings);

  final Dio _dio;
  final AppLocalizations _strings;

  Future<MeDto> login(LoginRequestDto request) =>
      _readUser(ApiPaths.login, request: request.toJson());

  // A short cap of its own: this call holds the splash screen, and an unreachable
  // server would otherwise wait out the general connect timeout.
  Future<MeDto> currentUser() async {
    final cancel = CancelToken();
    final timer = Timer(ApiConfig.sessionRestoreTimeout, cancel.cancel);
    try {
      return await _readUser(ApiPaths.me, cancelToken: cancel);
    } finally {
      timer.cancel();
    }
  }

  Future<void> logout() => _postEmpty(ApiPaths.logout);

  Future<void> changePassword(ChangePasswordRequestDto request) =>
      _postEmpty(ApiPaths.changePassword, request: request.toJson());

  Future<MeDto> _readUser(
    String path, {
    Map<String, dynamic>? request,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = request == null
          ? await _dio.get<Object?>(path, cancelToken: cancelToken)
          : await _dio.post<Object?>(path, data: request);
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw ContractException(
          _strings.invalidResponse(body.runtimeType.toString()),
        );
      }
      return MeDto.fromJson(body);
    } on DioException catch (error) {
      throw ApiException.fromDio(error, networkMessage: _strings.networkError);
    } on CheckedFromJsonException catch (error) {
      throw ContractException(_strings.invalidResponse(error.toString()));
    }
  }

  Future<void> _postEmpty(String path, {Map<String, dynamic>? request}) async {
    try {
      await _dio.post<void>(path, data: request);
    } on DioException catch (error) {
      throw ApiException.fromDio(error, networkMessage: _strings.networkError);
    }
  }
}
