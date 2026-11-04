import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';

void main() {
  ApiException failure(Object? body, {int? status = 400}) {
    final request = RequestOptions(path: '/synthetic');
    return ApiException.fromDio(
      DioException(
        requestOptions: request,
        message: 'HTTP transport detail',
        response: status == null
            ? null
            : Response<Object?>(
                requestOptions: request,
                statusCode: status,
                data: body,
              ),
      ),
      networkMessage: 'Mất kết nối',
    );
  }

  test('server message and code are preserved', () {
    final error = failure({
      'code': 'SESSION_REQUIRED',
      'message': 'Hết phiên',
    }, status: 401);
    expect(error.toString(), 'Hết phiên');
    expect(error.isSessionRequired, isTrue);
    expect(error.statusCode, 401);
  });

  test('validation messages join without being discarded', () {
    expect(
      failure({
        'message': ['Lỗi một', 'Lỗi hai'],
      }).message,
      'Lỗi một\nLỗi hai',
    );
  });

  test('network and malformed HTTP bodies have non-silent fallbacks', () {
    final network = failure(null, status: null);
    expect(network.message, 'Mất kết nối');
    expect(network.code, 'NETWORK');
    expect(failure('<html>failure</html>').message, 'HTTP transport detail');
  });

  test('forced password errors are identified independently of status', () {
    expect(
      failure({
        'code': 'PASSWORD_CHANGE_REQUIRED',
        'message': 'Đổi mật khẩu',
      }).isPasswordChangeRequired,
      isTrue,
    );
  });
}
