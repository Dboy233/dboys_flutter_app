import 'package:get/get.dart';

import 'logic.dart';

class QrCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrCreateLogic());
  }
}
