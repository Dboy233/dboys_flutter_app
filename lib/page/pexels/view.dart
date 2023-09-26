import 'package:dboy_flutter_app/page/pexels/page/photo/view.dart';
import 'package:dboy_flutter_app/page/pexels/page/video/view.dart';
import 'package:dboy_flutter_app/util/local_data_key.dart';
import 'package:dboy_flutter_app/util/local_data_util.dart';
import 'package:dboy_flutter_app/widget/lazy_indexed_stack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PexelsPage extends GetWidget<PexelsLogic> {
  const PexelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<PexelsLogic>(
          id: controller.currentIndexUpDateId,
          builder: (controller) {
            return IndexedStack(
              index: controller.getCurrentIndex(),
              children: const [
                PexelsPhotoPage(key: ValueKey('PexelsPhotoPage')),
                PexelsVideoPage(key: ValueKey('PexelsVideoPage')),
              ],
            );
          }),
      bottomNavigationBar: GetBuilder<PexelsLogic>(
          id: controller.currentIndexUpDateId,
          builder: (controller) {
            return BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    label: '图片',
                    icon: Icon(
                      CupertinoIcons.photo_fill_on_rectangle_fill,
                    )),
                BottomNavigationBarItem(
                    label: '视频',
                    icon: Icon(
                      CupertinoIcons.play_circle_fill,
                    )),
                BottomNavigationBarItem(
                    label: '认证',
                    icon: Icon(
                      Icons.key,
                    )),
              ],
              currentIndex: controller.getCurrentIndex(),
              onTap: (index) {
                if (index == 0 || index == 1) {
                  controller.changePageIndex(index);
                } else {
                  //显示认证Dialog widget
                  Get.dialog(SettingPexelsAuthDialog());
                }
              },
              backgroundColor: Colors.white,
              elevation: 10,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme: const IconThemeData(color: Colors.black),
              unselectedIconTheme: const IconThemeData(color: Colors.black45),
            );
          }),
    );
  }
}

class SettingPexelsAuthDialog extends StatelessWidget {
  ///弹窗输入的控制器
  final _textEditingController = TextEditingController();

  //编辑框焦点管理
  final _focusNode = FocusNode();

  SettingPexelsAuthDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 900.w,
        height: 700.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(35.w)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '请填写你的 Pexels Auth',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: 35.w, top: 120.h, left: 35.w, bottom: 35.w),
              width: double.infinity,
              height: 200.h,
              child: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: () async {
                  _focusNode.unfocus();
                  var auth = _textEditingController.value.text;
                  var navigation = Navigator.of(context);
                  LocalData.get().putData(LocalDataKey.PEXELS_AUTH_KEY, auth);
                  navigation.pop();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  fillColor: const Color(0x80e2e2e3),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xfff6f7f8)),
                      borderRadius: BorderRadius.all(Radius.circular(30.r))),
                  hintText: '  --auth--',
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xfff6f7f8)),
                      borderRadius: BorderRadius.all(Radius.circular(30.r))),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                var navigation = Navigator.of(context);
                await LocalData.get().delete(LocalDataKey.PEXELS_AUTH_KEY);
                navigation.pop();
              },
              child: const Text('使用默认Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
