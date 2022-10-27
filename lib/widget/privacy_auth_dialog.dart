import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyAuthDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback onRefuse;

  PrivacyAuthDialog({super.key, required this.onAgree, required this.onRefuse});

  ///协议内容
  final content = """
  1.图库权限，目的是保存图片到你的手机中。
  2.存储权限，保存视频文件到你的手机中。
  3.定位权限，用于生成定位二维码和天气定位。

  本app不会随意读取你的设备信息。(协议草案)
  """
      .removeAllWhitespace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: AlertDialog(
          title: const Text('隐私协议'),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: onRefuse,
                child: const Text(
                  '拒绝',
                  style: TextStyle(color: Colors.redAccent),
                )),
            TextButton(
                onPressed: onAgree,
                child: const Text(
                  '同意',
                  style: TextStyle(color: Colors.black45),
                )),
          ],
        ),
      ),
    );
  }
}
