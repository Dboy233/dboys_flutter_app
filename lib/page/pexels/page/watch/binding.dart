import 'package:get/get.dart';

import 'logic.dart';

class WatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WatchLogic());
  }
}
