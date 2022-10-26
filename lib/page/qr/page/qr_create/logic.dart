import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:get/get.dart';

class QrCreateLogic extends GetxController {
  ///二维码创建选项
  var options = <QrType>[];
  final optionsNotifyId = "optionsNotifyId";

  @override
  void onReady() {
    _initQrOptions();
    super.onReady();
  }

  ///初始化列表，这里派出了部分没有实现的类型
  void _initQrOptions() async {
    var list = QrType.values.toList()
      ..removeWhere((qrType) =>
          qrType == QrType.unknown ||
          qrType == QrType.isbn ||
          qrType == QrType.calendarEvent ||
          qrType == QrType.driverLicense);
    options.addAll(list);
    update([optionsNotifyId]);
  }
}
