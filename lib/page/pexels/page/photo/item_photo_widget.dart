//列表的每一个item部件
import 'package:dboy_flutter_app/net/pexels/bean/photo.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class PhotoItemWidget extends StatelessWidget {
  final Photo photo;

  final Function(String heroId,String photoUrl)? reviewPhoto;

  final Function(String downloadName,String downloadUrl)? downloadTap;

  const PhotoItemWidget({Key? key, required this.photo, this.reviewPhoto,this.downloadTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = zoom(photo.width ?? 0, photo.height ?? 0, width: width);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //作者名字
        Padding(
          padding: EdgeInsets.only(top: 80.h, left: 30.w, bottom: 24.h),
          child: Text(
            photo.photographer ?? "",
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xff0d111b),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        //作者主页
        Padding(
          padding: EdgeInsets.only(left: 30.w, bottom: 30.h),
          child: GestureDetector(
            onTap: () {
              if (photo.photographerUrl?.isNotEmpty == true) {
                launchUrl(  Uri.parse(photo.photographerUrl!));
              }
            },
            child: Text(
              photo.photographerUrl ?? "",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff757576),
              ),
            ),
          ),
        ),
        //图片
        GestureDetector(
          onTap: () {
            reviewPhoto?.call(photo.id.toString(), photo.src?.large2x ?? "");
          },
          child: Hero(
            tag: photo.id.toString(),
            child: Image.network(
              photo.src?.large2x ?? "",
              width: width,
              height: height,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                Get.log("图片尝试重新加载");
                return Image.network(
                  photo.src?.large2x ?? "",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: photo.liked,
              child: Tooltip(
                message: 'Auth用户的收藏,不可操作',
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.pink,
                  size: 80.r,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                //拼接名字 作者-图片id.jpg , 图片原始下载地址。
                downloadTap?.call("${photo.photographer}-${photo.id}.jpg", photo.src?.original??"");
              },
              icon: Icon(
                Icons.download,
                size: 80.r,
              ),
            ),
            SizedBox(
              width: 30.w,
            )
          ],
        ),
      ],
    );
  }
}

