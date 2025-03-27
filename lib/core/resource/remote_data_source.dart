import 'package:dio/dio.dart';
import 'package:work_order_app/config/app_config.dart';
import '/core/utils/debug_log.dart';

enum ContentType { json, form, multipart }

class RemoteDatasource {
  late Dio dio;
  static final List<Function(Response response)> _onResponseSideEffects = [];
  static late final Function authTokenGetter;

  RemoteDatasource({
    String? domain,
    String baseEndPoint = '/api',
  }) {
    dio = Dio(BaseOptions(
      baseUrl: (domain ?? AppConfig.backendDomain) + baseEndPoint,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _addDefaultInterceptors();
  }

  static void setAuthTokenGetter(Function getter) {
    authTokenGetter = getter;
  }

  static void addOnResponseSideEffect(
      Function(Response response) afterResponse) {
    _onResponseSideEffects.add(afterResponse);
  }

  Future<Response<T>> get<T>({
    String? path,
    Map<String, dynamic>? queryParameters,
    Object? data,
    ContentType? contentType,
  }) async {
    return dio.get<T>(
      path ?? '',
      queryParameters: queryParameters,
      options: Options(headers: headers(contentType: contentType)),
      data: data,
    );
  }

  Future<Response<T>> post<T>({
    String? path,
    Map<String, dynamic>? queryParameters,
    Object? data,
    ContentType? contentType,
  }) async {
    return dio.post<T>(
      path ?? '',
      queryParameters: queryParameters,
      options: Options(headers: headers(contentType: contentType)),
      data: data,
    );
  }

  Future<Response<T>> put<T>({
    String? path,
    Map<String, dynamic>? queryParameters,
    Object? data,
    ContentType? contentType,
  }) async {
    return dio.put<T>(
      path ?? '',
      queryParameters: queryParameters,
      options: Options(headers: headers(contentType: contentType)),
      data: data,
    );
  }

  Future<Response<T>> delete<T>({
    String? path,
    Map<String, dynamic>? queryParameters,
    Object? data,
    ContentType? contentType,
  }) async {
    return dio.delete<T>(
      path ?? '',
      queryParameters: queryParameters,
      options: Options(headers: headers(contentType: contentType)),
      data: data,
    );
  }

  Future<Response<T>> patch<T>({
    String? path,
    Map<String, dynamic>? queryParameters,
    Object? data,
    ContentType? contentType,
  }) async {
    return dio.patch<T>(
      path ?? '',
      queryParameters: queryParameters,
      options: Options(headers: headers(contentType: contentType)),
      data: data,
    );
  }

  Map<String, dynamic> headers({ContentType? contentType}) {
    final token = authTokenGetter != null ? authTokenGetter() : '';
    return {
      'Content-Type': contentType == null || contentType == ContentType.json
          ? 'application/json'
          : contentType == ContentType.form
              ? 'application/x-www-form-urlencoded'
              : 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void _addDefaultInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          DebugLog.info(message: 'Request: ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          DebugLog.info(message: 'Response: ${response.statusCode}');
          for (final sideEffect in _onResponseSideEffects) {
            sideEffect(response);
          }
          handler.next(response);
        },
        onError: (DioException e, handler) {
          DebugLog.error(
            message: 'Error: ${e.message}, response: ${e.response?.data}',
            stackTrace: e.stackTrace,
          );
          handler.next(e);
        },
      ),
    );
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}
