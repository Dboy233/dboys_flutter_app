import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

///高德Ios Key
String getGdIosKey() {
  return "4b6048da361bae762c86c24246b16fde";
}

///高德Android key 妈蛋的 经过测试tmd 这个key是需要配置在AndroidManifest.xml文件中才可以，我真操了。
String getGdAndroidKey() {
  return "";
}

///高德地图定位工具简单封装
class LocationUtil {
  ///定位监听
  StreamSubscription<Map<String, Object>>? _locationListener;

  ///定位工具
  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  ///先调用[requestPermission]请求权限.
  void init() {
    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作
    AMapFlutterLocation.updatePrivacyAgree(true);

    ///设置高德key
    AMapFlutterLocation.setApiKey(getGdAndroidKey(), getGdIosKey());
  }

  ///销毁资源
  void dispose() {
    ///移除定位监听
    _locationListener?.cancel();

    ///销毁定位
    _locationPlugin.destroy();
  }

  ///开始定位
  void startLocation() {
    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///注册定结果监听
  void registerLocationListener(
      void Function(Map<String, Object> data) onData) {
    ///注册定位结果监听
    _locationListener = _locationPlugin.onLocationChanged().listen(onData);
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      Get.log("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      Get.log("模糊定位类型");
    } else {
      Get.log("未知定位类型");
    }
  }

  /// 动态申请定位权限
  Future<bool> requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (hasLocationPermission) {
      Get.log("定位权限申请通过");
      return true;
    } else {
      Get.log("定位权限申请不通过");
      return false;
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
