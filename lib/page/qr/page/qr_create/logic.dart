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
