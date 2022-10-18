
typedef CallBack = Function();

class HomeAppItem {
  ///封面
  String coverImg;
  //app icon
  String? appIcon;
  //app name
  String appName;
  //app 官网
  Uri openUrl;
  //打开app回调函数
  String? routerUrl;

  HomeAppItem(
    this.coverImg,
    this.appIcon,
    this.appName,
    this.openUrl,
    this.routerUrl,
  );
}
