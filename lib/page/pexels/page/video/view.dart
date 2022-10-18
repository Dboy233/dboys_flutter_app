import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/widget/widget_download_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item_video_widget.dart';
import 'logic.dart';

class PexelsVideoPage extends GetWidget<PexelsVideoLogic> {
  const PexelsVideoPage({super.key});

  _loadMoreVideo() async {
    var msg = await controller.loadVideos();
    if (msg != null) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.white,
        messageText: Text(
          msg,
          style: const TextStyle(color: Colors.red),
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  _downloadVideo(name, url) async {
    Get.log("下载: $name \n $url");
    var navigator = Navigator.of(Get.context!);
    //显示dialog
    Get.dialog(
      const DownloadDialog(),
      barrierDismissible: false,
      useSafeArea: false,
    );
    var msg = await controller.downloadVideo(name, url);
    navigator.pop(); //关闭dialog
    //显示提示消息
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.blue,
      messageText: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          var pixels = notification.metrics.pixels;
          var maxScrollExtent = notification.metrics.maxScrollExtent;

          ///这里等于0是因为在没有数据的时候，下拉刷新的时候进行的通知，此时两个都是0。
          if (maxScrollExtent != 0 &&
              pixels.toInt() == maxScrollExtent.toInt()) {
            /// 这里就判定已经滚动到底部了。进行加载下一页数据。
            _loadMoreVideo();
          }
          return false;
        },
        child: GetBuilder<PexelsVideoLogic>(
            id: controller.videosNotifyId,
            builder: (_) {
              return ListView.builder(
                itemCount: controller.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemVideoWidget(
                    key: ValueKey(controller.videos[index].id!),
                    video: controller.videos[index],
                    downloadTap: () {
                      var video = controller.videos[index];
                      var file = video.videoFiles!.first;
                      var type = file.fileType
                              ?.substring(file.fileType!.indexOf("/") + 1) ??
                          "mp4";
                      var downloadName =
                          "${video.user?.name ?? "Unknown user"}-${video.id}.$type";
                      var downloadUrl = file.link;
                      _downloadVideo(downloadName, downloadUrl);
                    },
                    openTap: () {
                      Get.log("打开页面");
                      var video = controller.videos[index];
                      Get.toNamed(Routes.getPexelsVideoWatchUrl("${video.id}"));
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
