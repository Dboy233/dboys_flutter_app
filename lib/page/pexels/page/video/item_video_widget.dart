import 'package:chewie/chewie.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ItemVideoWidget extends StatelessWidget {
  final Video video;

  final Function()? openTap;

  final Function()? downloadTap;

  const ItemVideoWidget(
      {super.key, required this.video, this.openTap, this.downloadTap});

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height =
        zoom(video.width!.toInt(), video.height!.toInt(), width: width);

    var list = video.videoFiles ?? [];
    //找到尺寸最小的Video进行预览播放
    VideoFiles last = list.last;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //作者名字
        Padding(
          padding: EdgeInsets.only(top: 80.h, left: 30.w, bottom: 24.h),
          child: Text(
            video.user?.name ?? "",
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
              //打开用户主页
              if (video.user?.url?.isNotEmpty == true) {
                launchUrl(Uri.parse(video.user!.url!));
              }
            },
            child: Text(
              video.user?.url ?? "",
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
            openTap?.call();
          },
          child: SizedBox(
            width: width,
            height: height,
            child: AbsorbPointer(
              absorbing: true,
              child: _VideoView(key: ValueKey(last.link!), url: last.link!),
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
            IconButton(
              onPressed: () {
                downloadTap?.call();
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

class _VideoView extends StatefulWidget {
  final String url;

  const _VideoView({Key? key, required this.url}) : super(key: key);

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    _initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  _initializePlayer() async {
    //视频控制器
    _videoController = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    await _videoController?.initialize();
    //封装库控制器
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      showControls: false,
    );
    _chewieController?.setVolume(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController == null
        ? Container(color: Colors.black26)
        : Chewie(
            controller: _chewieController!,
          );
  }
}
