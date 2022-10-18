import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';

///本地数据持久化工具 抽象类
abstract class LocalData {
  ///默认实现
  static LocalData? _default;

  static LocalData get() {
    return _default ??= _LocalDataMMKv();
  }

  ///初始化
  Future init();

  ///是否存在key
  Future<bool> containsKey(String key);

  ///保存数据
  Future<dynamic> putData(String key, dynamic value);

  ///获取数据
  Future<S?> getData<S>(String key, {S? defValue});

  ///删除数据
  Future<bool> delete(String key);
}

class _LocalDataMMKv extends LocalData {
  MMKV? mmkv;

  @override
  Future init() async {
    await MMKV.initialize();
    mmkv = MMKV.defaultMMKV(cryptKey: "Dboy233");
    return 'rootDir';
  }

  @override
  Future<dynamic> putData(String key, value) {
    return Future.sync(() {
      assert(mmkv != null, "mmkv 还没初始化完成");
      Get.log("本地存储-保存 key=$key value=$value");
      switch (value.runtimeType) {
        case int:
          mmkv?.encodeInt(key, value);
          break;
        case String:
          mmkv?.encodeString(key, value);
          break;
        case bool:
          mmkv?.encodeBool(key, value);
          break;
        case double:
          mmkv?.encodeDouble(key, value);
          break;
      }
    });
  }

  @override
  Future<bool> delete(String key) {
    assert(mmkv != null, "mmkv 还没初始化完成");
    return Future.sync(() {
      mmkv?.removeValue(key);
      return true;
    });
  }

  @override
  Future<bool> containsKey(String key) {
    assert(mmkv != null, "mmkv 还没初始化完成");
    return Future.sync(() => mmkv?.containsKey(key) ?? false);
  }

  @override
  Future<S?> getData<S>(String key, {S? defValue}) {
    return Future.sync(() {
      S? result;
      switch (S) {
        case int:
          result = mmkv?.decodeInt(key) as S?;
          break;
        case String:
          result = mmkv?.decodeString(key) as S?;
          break;
        case bool:
          result = mmkv?.decodeBool(key) as S?;
          break;
        case double:
          result = mmkv?.decodeDouble(key) as S?;
          break;
        default:
          result = null;
          break;
      }
      Get.log("本地存储-获取 key=$key : value=$result");
      return result ?? defValue;
    });
  }
}
