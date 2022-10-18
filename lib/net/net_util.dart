import 'dart:convert';

import 'package:dboy_flutter_app/net/interceptors/pexels_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';

///网络工具简单封装
class NetUtil {
  ///创建对象的时候调用_getInstance()获取对象
  factory NetUtil() => _getInstance();

  ///使用instance对象的时候调用_getInstance()获取对象
  static NetUtil get instance => _getInstance();

  ///这个才是全局唯一单例
  static NetUtil? _instance;

  ///dio请求对象
  final Dio _dio = Dio();

  NetUtil._internal() {
    //设置拦截器
    _dio.interceptors.add(PexelsAuthInterceptors());
    _dio.interceptors.add(LoggerInterceptors());
  }

  static NetUtil _getInstance() {
    _instance ??= NetUtil._internal();
    return _instance!;
  }

  ///一般上传下载的时候不要带有拦截器，否则会有异常
  Dio dio() {
    return _dio;
  }
}

///自定义网络请求拦截器
class LoggerInterceptors extends InterceptorsWrapper {
  static const TAG = "Http::";

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Get.log("$TAG 请求[${options.method}] => PATH: ${options.uri}");
    Get.log("$TAG 请求[${options.method}] => HEAD: ${options.headers}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Get.log(
        "$TAG 响应[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    var opt = response.requestOptions;
    if (opt.responseType == ResponseType.plain ||
        opt.responseType == ResponseType.json) {
      var data = jsonEncode(response.data);
      Get.log("====================");
      Get.log(data);
      Get.log("====================");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Get.log(
        "$TAG 错误[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} \n MSG:${err.message}");
    super.onError(err, handler);
  }
}
