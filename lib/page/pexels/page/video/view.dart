import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:dboy_flutter_app/widget/widget_download_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item_video_widget.dart';
import 'logic.dart';

class PexelsVideoPage extends GetWidget<PexelsVideoLogic> {
  const PexelsVideoPage({super.key});

  ///加载更多视频
  _fetchData([bool isRefresh = true]) async {
    var msg = await controller.fetchVideos(isRefresh);
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

  ///下载视频
  _downloadVideo(name, url) async {
    Get.log("下载: $name \n $url");
    var navigator = Navigator.of(Get.context!);
    //显示dialog
    Get.dialog(
      DownloadDialog(
        onCancel: () {
          controller.cancelDownload();
        },
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
    var msg = await controller.downloadVideo(name, url);
    navigator.pop(); //关闭dialog
    //显示提示消息
    showMsg(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        refreshOnStart: true,
        onRefresh: _fetchData,
        onLoad: () async {
          await _fetchData(false);
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
                      Get.toNamed(Routes.pexels_video_watch("${video.id}"));
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
