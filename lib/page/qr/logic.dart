import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/database/data_base.dart';
import 'package:dboy_flutter_app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrLogic extends GetxController {
  ///多码队列
  final qrResult = <QrData>[];
  final qrResultNotifyId = "qrResult";

  late Box<QrData> _box;

  @override
  void onInit() {
    _box = DataBase.instance.getStore().box<QrData>();
    super.onInit();
  }

  void addBar(Barcode barcode) {
    QrData qrData = QrData()..orgData = barcode.rawValue ?? "null";
    qrData.type = _checkType(barcode);
    qrData.orgData = barcode.rawValue ?? "null";
    qrData.data = qrData.orgData;
    qrData.date = DateTime.now();
    //存数据库
    qrData.id = _box.put(qrData);
    //数据队列
    qrResult.add(qrData);
    //更新ui
    update([qrResultNotifyId]);
  }

  QrType _checkType(Barcode barcode) {
    switch (barcode.type) {
      case BarcodeType.unknown: //未知
        return QrType.unknown;
      case BarcodeType.contactInfo: //联系人
        return QrType.contactInfo;
      case BarcodeType.email: //邮件
        return QrType.email;
      case BarcodeType.isbn: //条码
        return QrType.isbn;
      case BarcodeType.phone: //手机
        return QrType.phone;
      case BarcodeType.product: //商品
        return QrType.product;
      case BarcodeType.sms: //短信
        return QrType.sms;
      case BarcodeType.text: //文本
        return QrType.text;
      case BarcodeType.url: //地址
        return QrType.url;
      case BarcodeType.wifi: //wifi
        return QrType.wifi;
      case BarcodeType.geo: //坐标
        return QrType.geo;
      case BarcodeType.calendarEvent: //日历
        return QrType.calendarEvent;
      case BarcodeType.driverLicense:
        return QrType.driverLicense; //驾照
    }
  }
}
