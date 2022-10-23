import 'package:get/get.dart';

import 'logic.dart';

class QrCreateTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrCreateTypeLogic());
  }
}
