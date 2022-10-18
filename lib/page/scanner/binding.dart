import 'package:get/get.dart';

import 'logic.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerLogic());
  }
}
