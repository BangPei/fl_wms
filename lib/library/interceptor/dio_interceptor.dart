// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  final Dio dio;
  DioInterceptors(this.dio);
  // final NavigationService _nav = locator<NavigationService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(err, ErrorInterceptorHandler handler) async {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
