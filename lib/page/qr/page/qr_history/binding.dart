import 'package:get/get.dart';

import 'logic.dart';

class QrHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrHistoryLogic());
  }
}
