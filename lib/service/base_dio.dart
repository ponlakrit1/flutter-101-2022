import 'package:dio/dio.dart';
import 'package:flutter_101/utils/global.dart';

abstract class BaseDio {
  late Dio _dio;
  Dio get dioMethod => _dio;

  BaseDio()  {
    var baseUrl = Global.rootURL;

    var options = BaseOptions(
      receiveTimeout: 60000,
      connectTimeout: 60000,
      baseUrl: baseUrl,
    );
    _dio = Dio(options);
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == null) {
            RequestOptions options = error.requestOptions;

            var response = await _dio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                )
            );

            return handler.resolve(response);
          }

          return handler.next(error);
        }
    ));
  }

}