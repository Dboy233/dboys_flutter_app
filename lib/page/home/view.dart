import 'package:dboy_flutter_app/database/bean/home_page_item_data.dart';
import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/widget/slide_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic.dart';

class HomePage extends GetView<HomeLogic> {
  HomePage({Key? key}) : super(key: key);

  final List<HomeAppItem> _apps = <HomeAppItem>[
    //开发者
    HomeAppItem(
      'images/img_deveper_cover.png',
      'images/icon_deveper.jpg',
      '开发者',
      Uri.parse('https://github.com/Dboy233'),
      null,
    ),
    //Pexels
    HomeAppItem(
      'images/img_pexels_cover.jpg',
      'images/icon_pexels.png',
      'Pexels',
      Uri.https('www.pexels.com', 'zh-cn'),
      Routes.pexels,
    ),
    HomeAppItem(
      'images/img_scanner_cover.jpg',
      'images/icon_scanner.png',
      '扫码',
      Uri.parse('https://github.com/Dboy233'),
      Routes.scanner,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: PageView.builder(
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 20.r, right: 20.r),
          child: AppPage(
              key: ValueKey(_apps[index].appName), homeAppItem: _apps[index]),
        ),
        itemCount: _apps.length,
        controller: PageController(viewportFraction: 0.86, keepPage: true),
      ),
    );
  }
}

///应用卡片展示Widget
class AppPage extends StatelessWidget {
  ///应用信息
  final HomeAppItem homeAppItem;

  const AppPage({Key? key, required this.homeAppItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 350.h, bottom: 350.h),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                // 这里设置了边缘装饰，但是 SlideImageView的边缘裁切装饰时独立的所以SlideImageView也要设置一样的属性
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: SlideImageView(
                imageProvider: AssetImage(homeAppItem.coverImg),
                slideDuration: const Duration(seconds: 7),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                enableScanAnim: false,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (homeAppItem.appIcon != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 24.r, left: 48.r),
                            child: Image.asset(
                              homeAppItem.appIcon!,
                              width: 200.r,
                              height: 200.r,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          homeAppItem.appName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 100.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60.r,right: 60.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                            onPressed: () => launchUrl(homeAppItem.openUrl),
                            child: Text('打开网站')),
                        if (homeAppItem.routerUrl != null)
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(homeAppItem.routerUrl!);
                                // context.navigation.toNamed(Routes.pexels);
                                // Get.searchDelegate('/').toNamed(Routes.pexels);
                              },
                              child: Text('进入App'))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
