part of 'app_pages.dart';

abstract class Routes {
  static const home = _Paths.home;

  //region pexels
  static const pexels = _Paths.home + _Paths.pexels;

  static const pexels_video = pexels + _Paths.pexels_video;

  static String pexels_video_watch(String videoId) => "$pexels_video/$videoId";

  @Deprecated('暂时不实现')
  static const pexels_photo = pexels + _Paths.pexels_photo;

  //endregion

  //region  扫码
  static const qr = home + _Paths.qr;

  static const qr_history = qr + _Paths.qr_history;

  static const qr_create = qr + _Paths.qr_create;

  static String qr_create_type(QrType type) => "$qr_create/${type.enumName}";

  //endregion

  Routes._();
}

abstract class _Paths {
  static const home = "/home";
  static const pexels = '/pexels';
  @Deprecated('暂时不实现')
  static const pexels_photo = '/photo';
  static const pexels_video = '/video';
  static const pexels_video_watch = '/:id';

  static const qr = "/qr";
  static const qr_history = "/history";
  static const qr_create = "/create";
  static const qr_create_type = "/:${RouteKeys.TYPE}";
}
