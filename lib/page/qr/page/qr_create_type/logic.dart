import 'package:dboy_flutter_app/util/location_util.dart';
import 'package:dboy_flutter_app/widget/dialog_controller.dart';
import 'package:dboy_flutter_app/widget/location_loading_dialog.dart';
import 'package:get/get.dart';

class QrCreateTypeLogic extends GetxController {
  ///定位工具
  LocationUtil? _locationUtil;

  ///弹窗控制器
  DialogController? _dialogController;

  @override
  void onReady() {
    super.onReady();
  }

  ///return的是初始化结果, [onData]是定位结果是个不可预期的异步回调.
  Future<String?> initLocation(
      void Function(Map<String, Object> data) onData) async {
    //初始化定位工具
    _locationUtil = LocationUtil();
    _locationUtil?.init();
    //初始化弹窗控制器
    _dialogController = DialogController();
    var pass = await _locationUtil?.requestPermission() ?? false;
    if (!pass) {
      return "没有定位权限";
    }
    //先弹出定位弹窗
    Get.dialog(
      LocationLoadingDialog(
        controller: _dialogController,
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
    _locationUtil?.registerLocationListener((data) {
      //停止定位
      _locationUtil?.stopLocation();
      //关闭弹窗
      _dialogController?.dismiss();
      //回调数据
      onData.call(data);
    });
    _locationUtil?.startLocation();
    return null;
  }

  @override
  void onClose() {
    _locationUtil?.dispose();
    _locationUtil = null;
    super.onClose();
  }
}
