import 'package:dboy_flutter_app/page/photo_review/view.dart';
import 'package:dboy_flutter_app/widget/widget_download_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item_photo_widget.dart';
import 'logic.dart';

class PexelsPhotoPage extends GetWidget<PexelsPhotoLogic> {
  const PexelsPhotoPage({super.key});

  //加载图片
  Future<dynamic> _loadPhoto() async {
    String? msg = await controller.loadPhoto(false);
    if (msg != null) {
      _showMsg(msg);
    }
  }

  //
  Future<dynamic> _refreshPhoto() async {
    var s = await controller.loadPhoto(true);
    if (s != null) {
      _showMsg(s);
    }
  }

  ///下载图片
  void _downloadPhoto(downloadName, downloadUrl) async {
    var navigator = Navigator.of(Get.context!);
    //显示dialog
    Get.dialog(
      DownloadDialog(
        onCancel: () {
          controller.cancelDownloadPhoto();
        },
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
    var downloadMsg = await controller.downloadPhoto(downloadName, downloadUrl);
    navigator.pop(); //关闭dialog
    //显示提示消息
    _showMsg(downloadMsg);
  }

  void _showMsg(msg) {
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
      body: EasyRefresh(
        refreshOnStart: true,
        onRefresh:  _refreshPhoto,
        onLoad: _loadPhoto,
        child: GetBuilder<PexelsPhotoLogic>(
          id: controller.photoListNotifyId,
          builder: (_) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return PhotoItemWidget(
                  photo: controller.photoList[index],
                  downloadTap: _downloadPhoto,
                  reviewPhoto: (heroId, photoUrl) {
                    Get.to(PhotoReviewPage(
                      NetworkImage(photoUrl),
                      heroId: heroId,
                    ));
                  },
                );
              },
              itemCount: controller.photoList.length,
            );
          },
        ),
      ),
    );
  }
}
