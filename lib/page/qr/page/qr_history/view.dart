import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_details/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

///二维码历史记录页面
class QrHistoryPage extends GetWidget<QrHistoryLogic> {
  const QrHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫码历史'),
        leading: const BackButton(),
        actions: [
          GetBuilder<QrHistoryLogic>(
              id: controller.historiesNotifyId,
              builder: (_) {
                return IconButton(
                    onPressed: () {
                      if (controller.getHistory().isNotEmpty) {
                        controller.removeAll();
                      }
                    },
                    icon: controller.getHistory().isEmpty
                        ? const Icon(Icons.delete_outline)
                        : const Icon(Icons.delete));
              })
        ],
      ),
      body: GetBuilder<QrHistoryLogic>(
          id: controller.historiesNotifyId,
          builder: (_) {
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) {
                var qrData = controller.getHistory()[index];
                return Dismissible(
                  key: ValueKey("${qrData.id}"),///需要标记key，不然移除item，刷新的时候会乱
                  onDismissed: (direction) {
                    controller.removeHistory(qrData.id);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.delete_forever),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.delete_forever),
                        ),
                      ],
                    ),
                  ),
                  child: _ItemInfo(qrData),
                );
              },
              itemCount: controller.getHistory().length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1.0, color: Colors.black12);
              },
            );
          }),
    );
  }

  Widget _ItemInfo(QrData qrData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(qrData.type.iconData, color: qrData.type.color),
          title: Text(qrData.type.label),
          subtitle: Text("${qrData.date}"),
          onTap: () {
            Get.to(
              QrDetails(qrData: qrData),
              transition: Transition.cupertino,
            );
          },
          trailing: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: qrData.orgData ?? ""));
              Get.showSnackbar(const GetSnackBar(
                backgroundColor: Colors.blueAccent,
                messageText: Text("复制成功"),
                duration: Duration(seconds: 2),
              ));
            },
            color: Colors.lightBlue,
            iconSize: 70.r,
            icon: const Icon(Icons.copy),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              QrDetails(qrData: qrData),
              transition: Transition.cupertino,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 70, right: 24, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              child: Text(qrData.orgData),
            ),
          ),
        )
      ],
    );
  }
}
