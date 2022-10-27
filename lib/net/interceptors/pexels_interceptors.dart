import 'package:dio/dio.dart';

import '../../util/local_data_key.dart';
import '../../util/local_data_util.dart';
import '../pexels/pexels_net_config.dart';

///Pexels的Api Auth配置拦截器
class PexelsAuthInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //仅当网络操作是pexels的时候进行认证
    if (options.uri.toString().contains(PEXELS_BASE_URL)) {
      var authKey =
          await LocalData.get().getData<String>(LocalDataKey.PEXELS_AUTH_KEY) ??
              PEXELS_KEY_DEF;
      options.headers["Authorization"] = authKey;
    }
    super.onRequest(options, handler);
  }
}
