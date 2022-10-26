import 'package:dboy_flutter_app/net/net_state.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_api.dart';
import 'package:dboy_flutter_app/net/pexels/pexels_net_config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PexelsPhotoLogic extends GetxController {
  ///图片列表
  final photoList = [];
  final String photoListNotifyId = "photoList";

  //下一页网络请求地址
  String? nextPage = null;

  //网路操作取消token
  CancelToken? _cancelTokenPhoto;

  //下载取消token
  CancelToken? _cancelTokenDownload;

  ///下载状态 true正在下载；false下载结束。
  var _isDownload = false;

  ///判断是否正在加载数据，放置重复加载
  var _isLoading = false;

  @override
  void onReady() {
    //加载精选照片,当逻辑层第一次加载的时候请求第一页
    loadPhoto(urlPath: getPexelsPhotosFirstPage());
    super.onReady();
  }

  @override
  void onClose() {
    _cancelTokenPhoto?.cancel('逻辑层被销毁');
    super.onClose();
  }

  ///加载图片
   Future<String?> loadPhoto({String? urlPath}) async {
    if (_isLoading) {
      return"正在加载更多，请稍后。。。";
    }
    _isLoading = true;
    //判断url
    String? url = urlPath ?? nextPage;
    if (url == null) {
      return "没有请求地址";
    }
    _cancelTokenPhoto = CancelToken();
    var request = await PexelsApi.getPictureListForUrl(urlPath ?? nextPage!,
        cancel: _cancelTokenPhoto);
    _isLoading = false;
    if (request.netState == NetState.success) {
      nextPage = request.data!.nextPage;
      photoList.addAll(request.data!.photos);
      update([photoListNotifyId]);
      return null;
    } else {
      if (isClosed) {
        return null;
      }
      return "请求数据失败了";
    }

  }

  void cancelDownloadPhoto(){
    _cancelTokenDownload?.cancel("取消下载图片");
  }

  ///下载图片
  ///[saveName] 图片保存的名字
  ///[downloadUrl] 图片下载地址
  Future<String> downloadPhoto(String? saveName, String? downloadUrl) async {
    if (_isDownload) return "正在下载中...";
    _isDownload = true;
    if (saveName == null || saveName.isEmpty == true) {
      _isDownload = false;
      return "文件名称错误~";
    }
    if (downloadUrl == null || downloadUrl.isEmpty) {
      _isDownload = false;
      return "下载地址获取失败~";
    }
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

    //创建取消下载token
    _cancelTokenDownload = CancelToken();

    //开始下载
    var result = await PexelsApi.downloadPhoto(
        saveName, downloadUrl, _cancelTokenDownload!).onError((error, stackTrace) => false);

    //修改下载状态
    _isDownload = false;

    //通过结果判断弹出提示
    if (result) {
      return "保存成功";
    } else {
      return "保存失败了";
    }
  }
}
