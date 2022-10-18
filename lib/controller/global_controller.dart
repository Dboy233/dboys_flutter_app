import 'package:get/get.dart';

///全局控制Controller,一些全局数据可以放在这里进行处理
class AppController extends GetxController {
  @override
  void onClose() {
    print("GlobalController 关闭了");
    super.onClose();
  }
}
