import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

///预计实现 扫码 解码 历史扫码 历史解码功能
class ScannerPage extends StatelessWidget {
  final logic = Get.find<ScannerLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(child: Text('扫码'),));
  }
}
