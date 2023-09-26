import 'dart:io';
import 'dart:ui';

import 'package:dboy_flutter_app/database/bean/home_page_item_data.dart';
import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:dboy_flutter_app/util/local_data_key.dart';
import 'package:dboy_flutter_app/util/local_data_util.dart';
import 'package:dboy_flutter_app/widget/privacy_auth_dialog.dart';
import 'package:dboy_flutter_app/widget/slide_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<HomeAppItem> _apps = <HomeAppItem>[
    //开发者
    HomeAppItem(
      'images/img_deveper_cover.png',
      'images/icon_deveper.jpg',
      '开发者',
      Uri.parse('https://github.com/Dboy233/dboys_flutter_app'),
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
      Routes.qr,
    ),
  ];

  ///当前背景
  var currentBg = "";

  @override
  void initState() {
    currentBg = _apps[0].coverImg;
    _checkPrivacy();
    super.initState();
  }

  ///隐私政策检查
  _checkPrivacy() async {
    Get.log("隐私政策中间件检查");
    var isAgree =
        await LocalData.get().getData<bool>(LocalDataKey.PRIVACY_AUTH_KEY) ??
            false;
    if (!isAgree) {
      Get.log("展示隐私政策弹窗");
      await Get.dialog(PrivacyAuthDialog(
        onAgree: () {
          Get.log("同意了");
          LocalData.get().putData(LocalDataKey.PRIVACY_AUTH_KEY, true);
          Get.back();
        },
        onRefuse: () {
          Get.log("拒绝了");
          //直接tm退出app
          exit(0);
        },
      ));
    } else {
      Get.log("隐私政策检查通过");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            currentBg,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withAlpha(0),
            ),
          ),
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                currentBg = _apps[value].coverImg;
              });
            },
            itemBuilder: (context, index) =>
                Padding(
                  padding: EdgeInsets.only(left: 20.r, right: 20.r),
                  child: AppPage(
                      key: ValueKey(_apps[index].appName),
                      homeAppItem: _apps[index]),
                ),
            itemCount: _apps.length,
            controller: PageController(viewportFraction: 0.86, keepPage: true),
          ),
        ],
      ),
    );
  }
}

///应用卡片展示Widget
class AppPage extends StatelessWidget {
  ///应用信息
  final HomeAppItem homeAppItem;

  const AppPage({Key? key, required this.homeAppItem}) : super(key: key);


  List<BoxShadow> _createShadow() {
    var shadowColor = Colors.blue.withAlpha(50);
    var shadowSize = 5.0;
    return [
      BoxShadow(
          color: shadowColor,
          offset: Offset(0, shadowSize),
          blurRadius: 5),
      BoxShadow(
          color: shadowColor,
          offset: Offset(0, -shadowSize),
          blurRadius: 5),
      BoxShadow(
          color: shadowColor,
          offset: Offset(shadowSize, 0),
          blurRadius: 5),
      BoxShadow(
          color: shadowColor,
          offset: Offset(-shadowSize, 0),
          blurRadius: 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 350.h, bottom: 350.h),
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: _createShadow()),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: SlideImageView(
                imageProvider: AssetImage(homeAppItem.coverImg),
                slideDuration: const Duration(seconds: 7),
                // borderRadius: const BorderRadius.only(
                //     topLeft: Radius.circular(10),
                //     topRight: Radius.circular(10)),
                enableScanAnim: false,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
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
                      padding: EdgeInsets.only(left: 60.r, right: 60.r),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
