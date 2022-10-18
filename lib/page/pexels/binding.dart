import 'package:get/get.dart';

import 'logic.dart';
import 'page/photo/logic.dart';
import 'page/video/logic.dart';

class PexelsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PexelsLogic());
    Get.lazyPut(() => PexelsPhotoLogic());
    Get.lazyPut(() => PexelsVideoLogic());
  }

}