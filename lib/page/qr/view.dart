import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/page/qr/logic.dart';
import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'nest_scroll_sheet.dart';

///预计实现 扫码 解码 历史扫码 历史解码功能
class QrPage extends StatefulWidget {
  QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  ///扫码控制器
  final MobileScannerController _cameraController = MobileScannerController();

  final logic = Get.find<QrLogic>();

  ///多码队列最大长度
  final max_queue_size = 4;

  bool isShowResult = false;

  //二维码结果,展示二维码结果，然后保存到数据库中.如果扫描到了多个二维码，会多次调用这个函数，头疼妈的
  _onDetect(Barcode barcode, MobileScannerArguments? args) async {
    logic.addBar(barcode);
    if (isShowResult) {
      return;
    }
    isShowResult = true;
    await _showResult();
    isShowResult = false;
  }

  //显示结果.
  _showResult() async {
    _cameraController.stop();
    //弹出扫码结果展示框
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return NestScrollSheet(
          (scrollController, scrollBan) =>
              QrResultDialog(scrollController, scrollBan),
        );
      },
    );
    logic.qrResult.clear();
    _cameraController.start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '扫码',
          style: TextStyle(
            fontSize: 70.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          //扫码器
          VisibilityDetector(
            key: const ValueKey('MobileScanner'),
            onVisibilityChanged: (VisibilityInfo info) {
              Get.log("可见比例 ${info.visibleFraction}");
              if (info.visibleFraction == 0) {
                _cameraController.stop();
              } else {
                _cameraController.start();
              }
            },
            child: MobileScanner(
              fit: BoxFit.cover,
              allowDuplicates: false,
              controller: _cameraController,
              onDetect: _onDetect,
            ),
          ), //下方菜单
          _bottomMenu()
        ],
      ),
    );
  }

  ///下方菜单
  Align _bottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 300.r),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50.r, right: 50.r),
                child: IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: _cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state as TorchState) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off,
                              color: Colors.grey);
                        case TorchState.on:
                          return const Icon(Icons.flash_on,
                              color: Colors.yellow);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => _cameraController.toggleTorch(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.r, right: 50.r),
                child: IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: _cameraController.cameraFacingState,
                    builder: (context, state, child) {
                      switch (state as CameraFacing) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => _cameraController.switchCamera(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.r, right: 50.r),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 32.0,
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {
                    Get.toNamed(Routes.qr_create);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.r, right: 50.r),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 32.0,
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    Get.toNamed(Routes.qr_history);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QrResultDialog extends GetView<QrLogic> {
  ScrollController scrollController;

  bool scrollBan;

  QrResultDialog(this.scrollController, this.scrollBan, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 0.5.sh,
      child: GetBuilder<QrLogic>(
          id: controller.qrResultNotifyId,
          builder: (_) {
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              controller: scrollController,
              physics: scrollBan
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _ItemInfo(controller.qrResult[index]);
              },
              itemCount: controller.qrResult.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1.0, color: Colors.black12);
              },
            );
          }),
    );
  }

  Widget _ItemInfo(QrData qrData) {
    return Column(
      key: ValueKey(qrData.id),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(qrData.type.iconData,color: qrData.type.color),
          title: Text("${qrData.type.name}"),
          subtitle: Text("${qrData.date}"),
          trailing: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: qrData.orgData));
              Get.showSnackbar(const GetSnackBar(
                backgroundColor: Colors.blueAccent,
                messageText: Text("复制成功"),
                duration: Duration(seconds: 2),
              ));
            },
            color: Colors.lightBlue,
            iconSize: 70.r,
            icon: const Icon(Icons.copy),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70, right: 24,bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: Text(qrData.orgData),
          ),
        )
      ],
    );
  }
}
