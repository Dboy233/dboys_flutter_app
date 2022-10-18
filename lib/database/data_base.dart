import 'package:dboy_flutter_app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DataBase {
  ///单例对象
  static late DataBase instance;

  ///存储库
  late Store _store;

  //初始化
  static Future init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-dboy233"));
    instance = DataBase._create(store);
  }

  //存储库创建
  DataBase._create(Store store) {
    Get.log("存储库创建完成");
    _store = store;
    // var box = _store.box<QrData>();
    // var qrData = QrData();
    // qrData.type = QrType.text;
    // qrData.orgData = "测试文本";
    // qrData.date = DateTime.now();
    // box.put(qrData);
    // print("${box.getAll()}");
    // box.removeAll();
    // print("${box.getAll()}");
  }

  ///获取存储库
  Store getStore() => _store;
}
