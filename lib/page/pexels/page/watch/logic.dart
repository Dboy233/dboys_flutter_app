import 'package:dboy_flutter_app/net/net_state.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_api.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class WatchLogic extends GetxController {
  Video? video;
  var videoNotifyId = "videoNotifyId";

  CancelToken? _cancelToken;

  bool _isLoading = false;

  Future<String?> loadVideo(String videoId) async {
    if(video!=null) return null;
    if (_isLoading) return "正在加载资源";
    _isLoading = true;
    _cancelToken = CancelToken();
    var videoInfo = await PexelsApi.getVideoInfo(videoId, _cancelToken!);
    _isLoading = false;
    if (videoInfo.netState == NetState.success && videoInfo.data != null) {
      video = videoInfo.data;
      update([videoNotifyId]);
      return null;
    } else {
      return "数据请求失败";
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}
