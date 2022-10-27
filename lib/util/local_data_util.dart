import 'package:shared_preferences/shared_preferences.dart';

///本地数据持久化工具 抽象类
abstract class LocalData {
  ///默认实现
  static LocalData? _default;

  static LocalData get() {
    return _default ??= _SpLocalData();
  }

  ///初始化
  Future init();

  ///是否存在key
  Future<bool> containsKey(String key);

  ///保存数据
  Future<dynamic> putData(String key, dynamic value);

  ///获取数据
  Future<S?> getData<S>(String key);

  ///删除数据
  Future<bool> delete(String key);
}

class _SpLocalData extends LocalData {
  late SharedPreferences prefs;

  @override
  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> containsKey(String key) async {
    return prefs.containsKey(key);
  }

  @override
  Future<bool> delete(String key) {
    return prefs.remove(key);
  }

  @override
  Future<S?> getData<S>(String key) async {
    switch (S) {
      case int:
        return prefs.getInt(key) as S?;
      case String:
        return prefs.getString(key) as S?;
      case bool:
        return prefs.getBool(key) as S?;
      case double:
        return prefs.getDouble(key) as S?;
      default:
        throw UnimplementedError("不支持此类型 ${S}");
    }
  }

  @override
  Future<dynamic> putData(String key, value) {
    switch (value.runtimeType) {
      case int:
        return prefs.setInt(key, value);
      case String:
        return prefs.setString(key, value);
      case bool:
        return prefs.setBool(key, value);
      case double:
        return prefs.setDouble(key, value);
      default:
        throw UnimplementedError("不支持此类型数据 ${value.runtimeType}");
    }
  }
}
