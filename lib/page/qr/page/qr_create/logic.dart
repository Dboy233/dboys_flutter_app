import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:get/get.dart';

class QrCreateLogic extends GetxController {

  ///二维码创建选项
  var options = <QrOption>[];
  final optionsNotifyId = "optionsNotifyId";

  @override
  void onReady() {
    _initQrOptions();
    super.onReady();
  }

  void _initQrOptions() async {
    QrType.values.toList()
      ..removeWhere(
          (qrType) => qrType == QrType.unknown || qrType == QrType.isbn)
      ..forEach((qrType) {
        options.add(QrOption(qrType));
      });

    update([optionsNotifyId]);
  }

}

///创建二维码选项 项目
class QrOption {
  bool isChoice = false;
  QrType type;
  QrOption(this.type);
}
