import 'package:dboy_flutter_app/net/net_state.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_api.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class WatchLogic extends GetxController {
  ///视频资源
  Video? video;
  var videoNotifyId = "videoNotifyId";

  ///取消load token
  CancelToken? _cancelTokenLoad;

  ///下载任务cancel token
  CancelToken? _cancelTokenDownload;

  ///判断是否加载视频信息
  bool _isLoading = false;

  ///判断是否下载视频
  bool _isDownload = false;

  ///加载视频信息
  Future<String?> loadVideo(String videoId) async {
    if (video != null) return null;
    if (_isLoading) return "正在加载资源";
    _isLoading = true;
    _cancelTokenLoad = CancelToken();
    var videoInfo = await PexelsApi.getVideoInfo(videoId, _cancelTokenLoad!);
    _isLoading = false;
    if (videoInfo.netState == NetState.success && videoInfo.data != null) {
      video = videoInfo.data;
      update([videoNotifyId]);
      return null;
    } else {
      return "数据请求失败";
    }
  }

  ///取消下载
  void cancelDownload(){
    Get.log("取消下载");
    _cancelTokenDownload?.cancel("取消下载");
  }


  ///下载视频
  Future<String> downloadVideo(name, url) async {
    if (_isDownload) {
      return "正在下载请稍后";
    }
    _isDownload = true;

    //权限申请
    if (GetPlatform.isIOS) {
      var permission = await Permission.storage.status;
      if (permission.isDenied) {
        //申请权限，如果被拒绝了提示
        var requestPermission = await Permission.storage.request();
        if (requestPermission.isDenied) {
          _isDownload = false;
          return "没有权限,请开启访问相册权限～";
        }
      }
    } else if (GetPlatform.isAndroid) {
      var permission = await Permission.storage.status;
      if (permission.isDenied) {
        var requestPermission = await Permission.storage.request();
        if (requestPermission.isDenied) {
          _isDownload = false;
          return "没有权限,请开启读写权限～";
        }
      }
    }

    _cancelTokenDownload = CancelToken();
    var isSuccess =
        await PexelsApi.downloadVideo(name, url, _cancelTokenDownload!)
            .onError((error, stackTrace) => false);
    _isDownload = false;

    if (isSuccess) {
      return "下载成功";
    } else {
      return "下载失败了。。。";
    }
  }

  @override
  void dispose() {
    _cancelTokenLoad?.cancel();
    super.dispose();
  }
}
