import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class QrCreatePage extends GetWidget<QrCreateLogic> {
  const QrCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '创建二维码',
          style: TextStyle(),
        ),
      ),
      body: const OptionsView(),
    );
  }
}

///菜单View
class OptionsView extends GetView<QrCreateLogic> {
  const OptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrCreateLogic>(
        id: controller.optionsNotifyId,
        builder: (_) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              var type = controller.options[index];
              return Ink(
                color: type.color,
                child: InkWell(
                  key: ValueKey(type.name),
                  splashColor: repairColor(type.color),
                  onTap: () {
                    Get.toNamed(Routes.qr_create_type(type));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type.iconData,
                        color: Colors.black87,
                        size: 120.r,
                      ),
                      Text(
                        type.name,
                        style: TextStyle(fontSize: 55.sp),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.options.length,
          );
        });
  }
}
