import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/database/data_base.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

class QrHistoryLogic extends GetxController {
  ///数据库
  late Box<QrData> _box;

  ///历史数据
  final List<QrData> _histories = [];
  final historiesNotifyId = "historiesNotifyId";

  @override
  void onInit() {
    _box = DataBase.instance.getStore().box<QrData>();
    super.onInit();
  }

  @override
  void onReady() {
    _queryData();
    super.onReady();
  }

  //初始化查询数据
  _queryData() async {
    var all = _box.getAll().reversed;
    _histories.clear();
    _histories.addAll(all);
    print("数据个数 ${_histories}");
    update([historiesNotifyId]);
  }

  ///获取数据
  List<QrData> getHistory() => _histories;

  ///删除历史数据
  void removeHistory(int id) {
    _box.remove(id);
    _histories.removeWhere((element) => element.id == id);
    update([historiesNotifyId]);
  }

  void removeAll() {
    _box.removeAll();
    _histories.clear();
    update([historiesNotifyId]);
  }
}
