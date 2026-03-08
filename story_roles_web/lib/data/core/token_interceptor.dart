import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class TokenInterceptor extends Interceptor {
  final StorageDataSource storageDataSource;

  TokenInterceptor({required this.storageDataSource});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageDataSource.readToken();
    if (token != null) {
      options.headers[DataConsts.apiParameters.authorization] =
          '${DataConsts.apiParameters.bearer} $token';
    }
    handler.next(options);
  }
}
