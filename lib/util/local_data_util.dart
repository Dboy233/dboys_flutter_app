import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

///本地数据持久化工具 抽象类
abstract class LocalData {
  ///默认实现
  static LocalData? _default;

  static LocalData get() {
    return _default ??= _LocalDataHive();
  }

  ///初始化
  Future init();

  ///是否存在key
  Future<bool> containsKey(String key);

  ///保存数据
  Future<dynamic> putData(String key, dynamic value);

  ///获取数据
  Future<S?> getData<S>(String key, {S defValue});

  ///删除数据
  Future<bool> delete(String key);
}

///使用前要确保 Hive 数据库已经初始化
class _LocalDataHive extends LocalData {
  Box? _box;

  @override
  Future init() async {
    _box = await Hive.openBox("local_data");
  }

  @override
  Future<bool> containsKey(String key) async {
    return _box?.containsKey(key) ?? false;
  }

  @override
  Future<S?> getData<S>(String key, {S? defValue}) async {
    var value = _box?.get(key, defaultValue: defValue);
    if (value == null) return null;
    if (value.runtimeType == S) {
      if (kDebugMode) {
        print("get data $key : $value");
      }
      return value as S;
    } else {
      throw Exception("获取的data数据类型${value.runtimeType} 与 目标类型不一致 ${S}");
    }
  }

  @override
  Future putData(String key, value) async {
    if (kDebugMode) {
      print("put data ${key} : $value");
    }
    return _box?.put(key, value);
  }

  @override
  Future<bool> delete(String key) {
    return _box?.delete(key).then<bool>((value) => true).catchError(
          (error) async {
            print("delete data error $error");
          },
          test: (error) => false,
        ) ??
        Future.value(false);
  }
}

// @Deprecated("所依赖的 path_provider 有问题")
// class _LocalDataMMKv extends LocalData {
//   // MMKV? mmkv;
//
//   @override
//   Future init() async {
//     // final rootDir = await MMKV.initialize();
//     // mmkv = MMKV.defaultMMKV();
//
//     return 'rootDir';
//   }
//
//   @override
//   Future<dynamic> putData(String key, value) async {
//     print("put $key data $value");
//     switch (value.runtimeType) {
//       case int:
//         break;
//       case String:
//         break;
//       case bool:
//         break;
//       case double:
//         break;
//     }
//   }
//
//   @override
//   Future<S?> getData<S>(String key) async {
//     switch (S) {
//       case int:
//         print("get $key data int ");
//         break;
//       case String:
//         print("get $key data string ");
//         break;
//       case bool:
//         print("get $key data bool ");
//         break;
//       case double:
//         print("get $key data double ");
//         break;
//     }
//     return null;
//   }
//
//   @override
//   delete(String kye) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }
// }
