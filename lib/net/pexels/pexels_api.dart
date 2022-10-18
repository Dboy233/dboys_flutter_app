import 'dart:io';
import 'dart:typed_data';

import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/net/pexels/bean/video_popular.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_v3/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../net_request.dart';
import '../net_state.dart';
import '../net_util.dart';
import 'bean/curated_photos.dart';
import 'pexels_net_config.dart';

class PexelsApi {
  // ///获取精选照片列表
  // ///[pageIndex] 请求的页码
  // ///[pageSize] 一页数据量
  // static Future<Request<CuratedPhotos>> getPictureList(
  //     {int pageIndex = 1, int pageSize = 15}) async {
  //   return NetUtil.instance.dio().get(
  //     apiCuratedPhotos,
  //     queryParameters: {"page": pageIndex, "per_page": pageSize},
  //   ).then<Request<CuratedPhotos>>((value) {
  //     //数据检查，是否超过请求限制、或是否请求成功。请求失败了就返回空数据
  //     if (!_checkMaxRequestSize(value.headers) && value.statusCode == 200) {
  //       return Request(NetState.success,
  //           data: CuratedPhotos.fromJson(value.data));
  //     } else {
  //       return Request(NetState.error);
  //     }
  //   }).onError((error, stackTrace) {
  //     return Request(NetState.error);
  //   });
  // }

  ///获取精选照片列表 简易版
  static Future<Request<CuratedPhotos>> getPictureListForUrl(String url,
      {CancelToken? cancel}) async {
    return NetUtil.instance.dio().get(url, cancelToken: cancel).then((value) {
      if (_checkMaxRequestSize(value.headers)) {
        return Request<CuratedPhotos>(NetState.error, errorMsg: "到达最大数据请求限制");
      } else if (value.statusCode == 200) {
        return Request<CuratedPhotos>(NetState.success,
            data: CuratedPhotos.fromJson(value.data));
      } else {
        return Request<CuratedPhotos>(NetState.error, errorMsg: value.data);
      }
    }).onError((error, stackTrace) => Request<CuratedPhotos>(NetState.error));
  }

  //获取热门视频列表，简易版
  static Future<Request<VideoPopular>> getVideoPopularSimple(String url,
      {CancelToken? cancel}) async {
    return NetUtil.instance.dio().get(url, cancelToken: cancel).then((value) {
      if (_checkMaxRequestSize(value.headers)) {
        return Request<VideoPopular>(NetState.error, errorMsg: "到达最大数据请求限制");
      } else if (value.statusCode == 200) {
        return Request<VideoPopular>(NetState.success,
            data: VideoPopular.fromJson(value.data));
      } else {
        return Request<VideoPopular>(NetState.error, errorMsg: "${value.data}");
      }
    }).onError((error, stackTrace) {
      Get.log("错误：$stackTrace");
      return Request<VideoPopular>(NetState.error);
    });
  }

  ///请求单个视频内容.
  static Future<Request<Video>> getVideoInfo(
      String id, CancelToken cancelToken) async {
    var pexelsVideoInfoUrl = getPexelsVideoInfoUrl(id);
    Get.log("url ========== $pexelsVideoInfoUrl");
    return NetUtil.instance
        .dio()
        .get(pexelsVideoInfoUrl, cancelToken: cancelToken)
        .then((value) {
          print("1111111111111111111111111");
      if (_checkMaxRequestSize(value.headers)) {
        return Request<Video>(NetState.error, errorMsg: "到达最大数据请求限制");
      } else if (value.statusCode == 200) {
        return Request<Video>(NetState.success,
            data: Video.fromJson(value.data));
      } else {
        return Request<Video>(NetState.error, errorMsg: "${value.data}");
      }
      return Request<Video>(NetState.error);
    }).onError((error, stackTrace) {
      print(stackTrace);
      return Request<Video>(NetState.error);
    });
  }

  ///获取搜索列表
  ///[search] 搜索的内容
  ///[pageIndex] 请求的页码
  ///[pageSize] 一页数据量
  // static Future<Request<SearchPhotos>> getSearchList(String search,
  //     {int pageIndex = 1, int pageSize = 15}) async {
  //   return NetUtil.instance.dio().get(apiSearch, queryParameters: {
  //     "query": search,
  //     "page": pageIndex,
  //     "per_page": pageSize
  //   }).then<Request<SearchPhotos>>((value) {
  //     if (!_checkMaxRequestSize(value.headers) && value.statusCode == 200) {
  //       return Request(NetState.success,
  //           data: SearchPhotos.fromJson(value.data));
  //     } else {
  //       return Request(NetState.error);
  //     }
  //   }).onError((error, stackTrace) {
  //     return Request(NetState.error);
  //   });
  // }

  ///获取我的收藏列表
  // static Future<Request<CollectionInfoMine>> getMineCollections(
  //     {int pageIndex = 1, int pageSize = 10, CancelToken? cancelToken}) {
  //   return NetUtil.instance
  //       .dio()
  //       .get(apiCollectionMine,
  //           queryParameters: {"per_page": pageSize, "page": pageIndex},
  //           cancelToken: cancelToken)
  //       .then<Request<CollectionInfoMine>>((value) {
  //     if (value.statusCode == 200 && !_checkMaxRequestSize(value.headers)) {
  //       return Request(NetState.success,
  //           data: CollectionInfoMine.fromJson(value.data));
  //     } else {
  //       Get.log("错误");
  //       return Request(NetState.error);
  //     }
  //   }).onError((error, stackTrace) {
  //     Get.log("$stackTrace");
  //     return Request(NetState.error);
  //   });
  // }

  /// 获取用户某个收藏集的图片
  // static Future<Request<CollectionContentsInfo>> getCollectionContentsMedia(
  //     String id,
  //     {String type = "photos",
  //     int page = 1,
  //     int pageSize = 3,
  //     CancelToken? cancelToken}) async {
  //   return NetUtil()
  //       .dio()
  //       .get(apiCollectionContentMedia(id),
  //           queryParameters: {"type": type, "page": page, "per_page": pageSize},
  //           cancelToken: cancelToken)
  //       .then<Request<CollectionContentsInfo>>((value) {
  //     if (value.statusCode == 200 && !_checkMaxRequestSize(value.headers)) {
  //       return Request(NetState.success,
  //           data: CollectionContentsInfo.fromJson(value.data));
  //     }
  //     return Request(NetState.error);
  //   }).onError((error, stackTrace) {
  //     return Request(NetState.error);
  //   });
  // }

  ///下载图片，，前提是已经有读写权限
  ///[saveName] 图片保存的名字
  ///[downloadUrl] 图片下载地址
  static Future<bool> downloadPhoto(
      String saveName, String downloadUrl, CancelToken cancelToken) async {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      //移动端平台直接下载图片的字节流
      var result = await NetUtil.instance.dio().get(
            downloadUrl,
            cancelToken: cancelToken,
            options: Options(responseType: ResponseType.bytes),
          );
      Get.log("cancel Token ${cancelToken.isCancelled}");
      if (result.statusCode == 200) {
        //开始保存图片
        await ImageGallerySaver.saveImage(Uint8List.fromList(result.data),
            name: saveName);

        return true;
      } else {
        return false;
      }
    } else {
      //todo 其他平台适配
      // _getSavePath()
      // return NetUtil.instance.dio().download(
      //       downloadUrl,
      //       savePath,
      //       deleteOnError: true,
      //       cancelToken: cancelToken,
      //     );
      return false;
    }
  }

  //下载视频
  static Future<bool> downloadVideo(
    String saveName,
    String downloadUrl,
    CancelToken cancelToken,
  ) async {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/$saveName";
      var response =
          await NetUtil.instance.dio().download(downloadUrl, savePath);
      if (response.statusCode == 200) {
        await ImageGallerySaver.saveFile(savePath, name: saveName);
        return true;
      }
      return false;
    } else {
      //todo 其他平台.
      return false;
    }
  }

  ///检查是否超过或已到达最大API请求次数限制
  ///true超过了最大限制，没有数据
  ///false没有超过最大限制，可能有数据
  static bool _checkMaxRequestSize(Headers headers) {
    var maxLimit = headers["X-Ratelimit-Limit"];
    var currentRequest = headers["X-Ratelimit-Remaining"];
    if (maxLimit != null && currentRequest != null) {
      try {
        return num.parse(currentRequest[0]) <= 0;
      } catch (e) {
        Get.log("已到达数据请求限制,明天再看吧。");
      }
    }
    return false;
  }

  ///获取保存路径
  static Future<String?> _getSavePath(
      String fileName, String downloadUrl) async {
    String? savePath;
    if (GetPlatform.isDesktop) {
      Directory? dir = await getDownloadsDirectory();
      if (dir != null) {
        savePath = dir.path + r"\" + fileName;
      }
    } else if (GetPlatform.isWeb) {
      //web
      if (await canLaunch(downloadUrl)) {
        launch(downloadUrl, enableJavaScript: true, headers: {
          "Content-type": "application/octet-stream",
          "Content-Disposition": "attachment;filename=$fileName"
        });
        return null;
      }
    }
    return savePath;
  }
}
