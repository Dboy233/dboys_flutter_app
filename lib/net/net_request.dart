import 'net_state.dart';

///包装网络请求，对数据进行一次包装，增加数据的状态码
class Request<T> {
  //数据状态 200 = success
  NetState netState;

  ///数据
  T? data;

  ///当[netState]=[NetState.error]的时候附加对应的错误信息
  String? errorMsg;

  Request(this.netState, {this.data, this.errorMsg});
}
