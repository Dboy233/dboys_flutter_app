import 'package:chewie/chewie.dart';
import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:dboy_flutter_app/widget/slide_image.dart';
import 'package:dboy_flutter_app/widget/widget_download_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'logic.dart';

///视频详情页面吧算是。
class WatchPage extends GetWidget<WatchLogic> {
  const WatchPage({super.key});

  ///加载视频
  _loadVideo() async {
    var videoId = Get.parameters['id'];
    print("视频id:$videoId");
    if (videoId == null) {
      showMsg("没有视频id");
      return;
    }
    var result = await controller.loadVideo(videoId);
    if (result != null) {
      showMsg(result);
    }
  }


  _downloadVideo(name, url) async{
    Get.log("下载: $name \n $url");
    var navigator = Navigator.of(Get.context!);
    //显示dialog
    Get.dialog(
      DownloadDialog(onCancel: (){
        controller.cancelDownload();
      },),
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
    //这个页面只build一次，所以放这里
    _loadVideo();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black54),
      ),
      body: GetBuilder<WatchLogic>(
          id: controller.videoNotifyId,
          builder: (_) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _VideoView(
                    key: const ValueKey("VideoView"),
                    video: controller.video,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _userInfoWidget(),
                ),
                if (_hasPictures())
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        '截图',
                        style: TextStyle(
                            fontSize: 80.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                if (_hasPictures())
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 800.r,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var pictures =
                              controller.video!.videoPictures![index];
                          return SizedBox(
                            width: Get.width - 100.r,
                            height: 800.r,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SlideImageView(
                                imageProvider: NetworkImage(pictures.picture!),
                                enableScanAnim: false,
                              ),
                            ),
                          );
                        },
                        itemCount: controller.video!.videoPictures!.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        var video = controller.video;
                        if(video==null)return;
                        var file = video.videoFiles!.first;
                        var type = file.fileType
                            ?.substring(file.fileType!.indexOf("/") + 1) ??
                            "mp4";
                        var downloadName =
                            "${video.user?.name ?? "Unknown user"}-${video.id}.$type";
                        var downloadUrl = file.link;
                        _downloadVideo(downloadName, downloadUrl);
                      },
                      icon: const Icon(Icons.download),
                      label: Text(
                        '下载视频',
                        style: TextStyle(fontSize: 50.sp),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  ///判断是否有截图
  bool _hasPictures() {
    return controller.video != null &&
        controller.video!.videoPictures != null &&
        controller.video!.videoPictures!.isNotEmpty;
  }

  ///展示用户信息的widget
  Row _userInfoWidget() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //作者名字
            Padding(
              padding: EdgeInsets.only(top: 80.h, left: 30.w, bottom: 24.h),
              child: Text(
                controller.video?.user?.name ?? "***",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff0d111b),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ), //作者主页
            Padding(
              padding: EdgeInsets.only(left: 30.w, bottom: 30.h),
              child: GestureDetector(
                onTap: () {
                  //打开用户主页
                  if (controller.video?.user?.url?.isNotEmpty == true) {
                    launchUrl(Uri.parse(controller.video!.user!.url!));
                  }
                },
                child: Text(
                  controller.video?.user?.url ?? "https://***",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff757576),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class VideoCoverImg extends StatelessWidget {
  const VideoCoverImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

///视频展示播放控件
class _VideoView extends StatefulWidget {
  Video? video;

  _VideoView({Key? key, this.video}) : super(key: key);

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  _initializePlayer() async {
    //初始化控制器
    if (widget.video == null || _chewieController != null) return;
    //视频控制器
    _videoController =
        VideoPlayerController.network(widget.video!.videoFiles!.first.link!);
    await _videoController?.initialize();
    //封装库控制器
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _videoController = null;
    _chewieController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video == null || null == _chewieController) {
      //初始化的时候会判断视频是否为null。如果为null不会初始化，当视频不会null。的时候初始化
      //_chewieController，当控制器初始化完成，便不会再进行初始化走这里了。
      _initializePlayer();
      return Container(
        width: double.infinity,
        height: Get.width / 2,
        color: Colors.black12,
      );
    } else {
      final width = Get.width;
      final height = zoom(
          widget.video!.width!.toInt(), widget.video!.height!.toInt(),
          width: width);
      return SizedBox(
        width: width,
        height: height,
        child: Theme(
          data: ThemeData.dark().copyWith(platform: TargetPlatform.iOS),
          child: Chewie(
            controller: _chewieController!,
          ),
        ),
      );
    }
  }
}
