import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_v3/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:widgets_to_image/widgets_to_image.dart';

///二维码详情。查看二维码，保存二维码。
class QrDetails extends StatelessWidget {
  final QrData qrData;

  final WidgetsToImageController _controller = WidgetsToImageController();

  QrDetails({Key? key, required this.qrData}) : super(key: key);

  ///保存二维码为图片
  _saveToImage() async {
    //权限申请
    if (GetPlatform.isIOS) {
      var permission = await Permission.photos.status;
      if (permission.isDenied) {
        //申请权限，如果被拒绝了提示
        var requestPermission = await Permission.photos.request();
        if (requestPermission.isDenied) {
          return "没有权限,请开启访问相册权限～";
        }
      }
    } else if (GetPlatform.isAndroid) {
      var permission = await Permission.storage.status;
      if (permission.isDenied) {
        var requestPermission = await Permission.storage.request();
        if (requestPermission.isDenied) {
          return "没有权限,请开启读写权限～";
        }
      }
    }

    Uint8List? uint8list = await _controller.capture();
    if (uint8list == null) {
      showMsg("图片保存失败");
      return;
    }

    final result = await ImageGallerySaver.saveImage(uint8list,
        name: DateTime.now().toString());

    if (result["isSuccess"] == true) {
      showMsg("保存成功");
    } else {
      showMsg("保存失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("二维码"),
        actions: [
          IconButton(
            onPressed: _saveToImage,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 70.h),
          Center(
            child: WidgetsToImage(
              controller: _controller,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    //为二维码设置一个阴影，这样看起来立体
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                    )
                  ],
                ),
                child: QrImage(
                  data: qrData.orgData,
                  size: 0.7.sw,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 45.sp,top: 80.sp,right: 45.sp),
            child: Text(
              qrData.orgData,
              style: TextStyle(color: Colors.black, fontSize: 65.sp),
            ),
          ),
        ],
      ),
    );
  }
}
