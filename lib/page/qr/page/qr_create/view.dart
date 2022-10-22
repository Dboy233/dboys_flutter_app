import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class QrCreatePage extends GetWidget<QrCreateLogic> {
  const QrCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '创建二维码',
          style: TextStyle(),
        ),
      ),
      body: ListView(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(8),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return Container(
                color: QrType.values[index].color,
                child: IconButton(
                    onPressed: () {

                    },
                    icon: Icon(QrType.values[index].iconData)),
              );
            },
            itemCount: QrType.values.length-1,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
