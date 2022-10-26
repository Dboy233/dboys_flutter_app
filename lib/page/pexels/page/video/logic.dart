import 'package:dboy_flutter_app/net/net_state.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_api.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_net_config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PexelsVideoLogic extends GetxController {
  ///视频列表
  var videos = <Video>[];
  final videosNotifyId = "videosId";

  ///下一页数据请求url暂存
  String? nextPage = "";

  ///视频列表获取cancel token
  CancelToken? _cancelTokenVideo;

  ///下载任务cancel token
  CancelToken? _cancelTokenDownload;

  ///判断是否正在加载列表
  bool _isLoadingVideo = false;

  ///判断是否正在下载
  bool _isDownload = false;

  @override
  void onReady() {
    loadVideos(urlPath: getPexelsVideoPopularFirstPage());
    super.onReady();
  }

  @override
  void onClose() {
    _cancelTokenVideo?.cancel();
    _cancelTokenDownload?.cancel();
    super.onClose();
  }

  ///加载视频列表 加载下一页的时候不需要船urlPth
  Future<String?> loadVideos({String? urlPath}) async {
    if (_isLoadingVideo) {
      return "正在加载视频列表，请稍后再试。";
    }
    _isLoadingVideo = true;

    //地址检测
    var url = urlPath ?? nextPage;
    if (url == null) {
      return "已没有更多资源！";
    }
    //创建取消实力
    _cancelTokenVideo = CancelToken();
    //请求网络
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

  ///下载视频
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
