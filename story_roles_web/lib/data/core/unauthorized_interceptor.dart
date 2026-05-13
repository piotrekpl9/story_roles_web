import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';

class UnauthorizedInterceptor extends Interceptor {
  final StorageDataSource storageDataSource;
  void Function()? onUnauthorized;

  UnauthorizedInterceptor({required this.storageDataSource});

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      await storageDataSource.removeToken();
      onUnauthorized?.call();
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
      return;
    }
    handler.next(response);
  }
}
