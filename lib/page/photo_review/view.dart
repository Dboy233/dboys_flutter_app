import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
///图片预览。
class PhotoReviewPage extends StatelessWidget {

  ImageProvider imageProvider;

  //进行Hero专场动画的id
  String? heroId;

  PhotoReviewPage(this.imageProvider, {super.key, this.heroId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            heroAttributes:
                heroId == null ? null : PhotoViewHeroAttributes(tag: heroId!),
            imageProvider: imageProvider,
          ),
          Positioned(
            top: Get.statusBarHeight.h + 30.h,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          )
        ],
      ),
    );
  }
}
