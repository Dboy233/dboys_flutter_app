import 'package:hive_flutter/hive_flutter.dart';

class DataBase {

  static final _instance = DataBase();

  static DataBase get() => _instance;

  //初始化
  Future init() async {
    await Hive.initFlutter();
  }

  void _adapterBox() {}
}
