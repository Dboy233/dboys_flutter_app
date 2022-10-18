import 'package:get/get.dart';

import 'logic.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrLogic());
  }
}
