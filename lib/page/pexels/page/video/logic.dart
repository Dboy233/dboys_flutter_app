import 'package:dboy_flutter_app/net/net_state.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_api.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_net_config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PexelsVideoLogic extends GetxController {
  var videos = <Video>[];
  final videosNotifyId = "videosId";

  String? nextPage = "";

  CancelToken? _cancelTokenVideo;

  CancelToken? _cancelTokenDownload;

  bool _isLoadingVideo = false;
  bool _isDownload = false;
  @override
  void onReady() async {
    String? initDataMsg =
        await loadVideos(urlPaht: getPexelsVideoPopularFirstPage());
    Get.log("初始化Video：$initDataMsg");
    super.onReady();
  }

  @override
  void onClose() {
    _cancelTokenVideo?.cancel();
    _cancelTokenDownload?.cancel();
    super.onClose();
  }

  Future<String?> loadVideos({String? urlPaht}) async {
    if (_isLoadingVideo) {
      return "正在加载视频列表，请稍后再试。";
    }
    _isLoadingVideo = true;

    var url = urlPaht ?? nextPage;
    if (url == null) {
      return "已没有更多资源！";
    }

    _cancelTokenVideo = CancelToken();

    var request =
        await PexelsApi.getVideoPopularSimple(url, cancel: _cancelTokenVideo);

    _isLoadingVideo = false;

    if (request.netState == NetState.success) {
      nextPage = request.data!.nextPage;
      videos.addAll(request.data!.videos);
      update([videosNotifyId]);
      return null;
    } else {
      return request.errorMsg ?? "视频列表请求失败！";
    }
  }

  Future<String> downloadVideo(name, url) async {
    if (_isDownload) {
      return "正在下载请稍后";
    }
    _isDownload = true;

    //权限申请
    if (GetPlatform.isIOS) {
      var permission = await Permission.photos.status;
      if (permission.isDenied) {
        //申请权限，如果被拒绝了提示
        var requestPermission = await Permission.photos.request();
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
        await PexelsApi.downloadVideo(name, url, _cancelTokenDownload!);
    _isDownload = false;

    if (isSuccess) {
      return "下载成功";
    } else {
      return "下载失败了。。。";
    }
  }
}
