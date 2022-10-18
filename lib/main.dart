import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/util/local_data_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'database/data_base.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await frontInit();

  runApp(DBoy(key: GlobalKey()));
}

///服务初始化 SDK初始化
frontInit() async {
  await DataBase.get().init();
  await LocalData.get().init();
}

class DBoy extends StatelessWidget {
  const DBoy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2400),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          getPages: AppPages.routes,
          initialRoute: AppPages.initial,
        );
      },
    );
  }
}
