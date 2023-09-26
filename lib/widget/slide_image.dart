import 'package:flutter/material.dart';

///可滑动展示图片的Widget
///海报展示
class SlideImageView extends StatelessWidget {
  ///图片加载器
  final ImageProvider imageProvider;

  ///滑动时长
  final Duration slideDuration;

  ///缩放时长 当图片展示加载成功后，会从 BoxFit.contain 到 BoxFit.cover 转换。
  ///此时长就是转换时的过度时长
  final Duration scaleDuration;

  ///打开展示缩放动画
  final bool enableScanAnim;

  ///图片加载过程中的占位widget
  final Widget? placeholder;

  const SlideImageView({
    Key? key,
    required this.imageProvider,
    this.slideDuration = const Duration(seconds: 5),
    this.scaleDuration = const Duration(seconds: 1),
    this.enableScanAnim = true,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: LayoutBuilder(
        builder: (_, constraint) {
          return _ImageView(
            imageProvider,
            constraint.maxWidth,
            constraint.maxHeight,
            slideDuration,
            scaleDuration,
            enableScanAnim,
            placeholder,
          );
        },
      ),
    );
  }
}

//需要多次build的ImageView。
class _ImageView extends StatefulWidget {
  //父宽度
  final double layoutWidth;

  //父高度
  final double layoutHeight;

//图片加载器
  final ImageProvider imageProvider;

  //滚动时长
  final Duration slideDuration;

  //缩放展示时长
  final Duration scaleDuration;

  //打开展示缩放动画
  final bool enableScanAnim;

  //图片加载过程中的占位widget
  final Widget? placeholder;

  const _ImageView(
    this.imageProvider,
    this.layoutWidth,
    this.layoutHeight,
    this.slideDuration,
    this.scaleDuration,
    this.enableScanAnim,
    this.placeholder,
  );

  @override
  State<_ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<_ImageView> with TickerProviderStateMixin {
  //图片原始宽度
  var orgWidth = 0;

  //图片原始高度
  var orgHeight = 0;

  //图片加载流
  ImageStream? resolve;

  //流监听器
  ImageStreamListener? imageStreamListener;

  //缩放动画控制器
  AnimationController? _scaleController;

  //缩放动画控制器
  AnimationController? _slideController;

  @override
  void initState() {
    resolve = widget.imageProvider.resolve(const ImageConfiguration());
    super.initState();
  }

  @override
  void dispose() {
    //移除动画控制器
    _disposeAnimController();
    //移除图片流监听器
    _disposeImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //监听并获取图片宽高
    if (orgWidth == 0 && orgHeight == 0) {
      _listenerImageSize((width, height) {
        setState(() {
          orgWidth = width;
          orgHeight = height;
        });
      });
    }

    //显示一个占位Widget用于Image加载
    if (orgWidth == 0 || orgHeight == 0) {
      return widget.placeholder ?? Container(color: Colors.black45);
    }

    //检查需要缩放的方向，获取缩放后的宽高
    final checkData = _checkScaleDirection(orgWidth * 1.0, orgHeight * 1.0,
        widget.layoutWidth, widget.layoutHeight);
    // print(checkData);
    var direction = checkData[0];
    var fixWidth = checkData[1];
    var fixHeight = checkData[2];
    //图像缩放比例
    var maxScale = 1.0;
    //平移偏移比例
    var offsetBegin = const Offset(0, 0);
    var offsetEnd = const Offset(0, 0);
    //方向判断
    if (direction == 1) {
      //计算高度缩放比
      maxScale = fixHeight / widget.layoutHeight;
      //计算平移便宜比例
      final offsetP = (fixHeight - widget.layoutHeight) /
          (2 * maxScale) *
          (1 / widget.layoutHeight);
      // print("偏移比例：$offsetP");
      offsetBegin = Offset(0, -offsetP);
      offsetEnd = Offset(0, offsetP);
    } else if (direction == 2) {
      maxScale = fixWidth / widget.layoutWidth;
      final offsetP = (fixWidth - widget.layoutWidth) /
          (2 * maxScale) *
          (1 / widget.layoutWidth);
      // print("偏移比例：$offsetP");
      offsetBegin = Offset(-offsetP, 0);
      offsetEnd = Offset(offsetP, 0);
    }
    // print("缩放大小:$maxScale");
    //初始化缩放控制器
    _initAnimationController();

    return ScaleTransition(
      //缩放动画
      scale: Tween<double>(
        begin: widget.enableScanAnim ? 1 : maxScale,
        end: maxScale,
      ).animate(_scaleController!),
      child: SlideTransition(
        //平移动画
        position: Tween(
          begin: offsetBegin,
          end: offsetEnd,
        ).animate(_slideController!),
        child: Image(
          image: widget.imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  ///初始化缩放控制器
  void _initAnimationController() {
    _scaleController ??=
        AnimationController(vsync: this, duration: widget.scaleDuration)
          ..forward();
    _slideController ??=
        AnimationController(vsync: this, duration: widget.slideDuration)
          ..repeat(reverse: true);
  }

  ///释放动画控制器
  void _disposeAnimController() {
    _scaleController?.dispose();
    _scaleController = null;
    _slideController?.dispose();
    _slideController = null;
  }

  ///移除图片流监听器
  void _disposeImageStream() {
    if (imageStreamListener != null) {
      resolve?.removeListener(imageStreamListener!);
    }
    resolve = null;
    imageStreamListener = null;
  }

  ///监听图片大小
  void _listenerImageSize(ImageSizeListener sizeListener) {
    //重复调用的话要先移除之前的监听器，重新创建
    if (imageStreamListener != null) {
      resolve?.removeListener(imageStreamListener!);
    }

    imageStreamListener = ImageStreamListener((image, synchronousCall) {
      var iWidth = image.image.width;
      var iHeight = image.image.height;
      if (iWidth != 0 && iHeight != 0) {
        sizeListener.call(iWidth, iHeight);
      }
      //处理完成后移除监听器
      if (imageStreamListener != null) {
        resolve?.removeListener(imageStreamListener!);
      }
    });

    //添加监听器
    if (imageStreamListener != null) {
      resolve?.addListener(
        imageStreamListener!,
      );
    }
  }
}

typedef ImageSizeListener = void Function(int width, int height);

///检查缩放方向 并返回缩放后的大小。
///返回数据为data=[0,w,h] data[0] 时方向
/// data[0] = 1是等比宽度缩放
/// data[0] = 2是等比高度缩放
/// data[0] = 0是不需要等比缩放
/// data[1] 和 data[2] 是 修正后的宽度和高度。
///
///目标图片 宽高 1080/720宽度比高大，容器为1080/1920高比宽大
///1080/720 = 1.5   1080/1920=0.5625， 图片1.5>容器0.5625 图片需要等比高度缩放。
///反过来，图片比是0.5625，容器比是1.5，   图片0.5625<容器1.5  图片需要等比宽度缩放。
List<num> _checkScaleDirection(
    double width, double height, double targetWidth, double targetHeight) {
  double orgP = width / height;
  double targetP = targetWidth / targetHeight;
  // print("checkScaleDirection");
  // print("原宽高$width/$height=$orgP,目标宽高$targetWidth/$targetHeight=$targetP");
  if (orgP > targetP) {
    //等比高度
    final scaleWidth = targetHeight / height * width;
    // print("等比高度缩放 当height=targetHeight:$targetHeight时，width=$scaleWidth");
    return [2, scaleWidth, targetHeight];
  } else if (orgP < targetP) {
    //等比宽度
    final scaleHeight = targetWidth / width * height;
    // print("等比宽度缩放 当width=targetWidth:$targetWidth，height=$scaleHeight");
    return [1, targetWidth, scaleHeight];
  } else {
    //无需放大
    // print("无需放大 和容器一样就可以");
    return [0, targetWidth, targetHeight];
  }
}
