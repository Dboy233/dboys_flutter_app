part of 'app_pages.dart';

abstract class Routes {
  static const home = _Paths.home;

  //region pexels
  static const pexels =  _Paths.home+ _Paths.pexels;

  static const pexels_video = pexels +_Paths.pexels_video;

  static const pexels_video_watch = pexels +_Paths.pexels_video+_Paths.pexels_video_watch;

  @Deprecated('暂时不实现')
  static const pexels_photo = pexels + _Paths.pexels_photo;

  //endregion

  //region  扫码
  static const scanner = home+_Paths.scanner;

  //endregion

  Routes._();

  @Deprecated('暂时不实现')
  static String getPexelsPhotoReviewRoute(String url) {
    return '$pexels_photo';
  }

  static String getPexelsVideoWatchUrl(String videoId){
    return "$pexels_video/$videoId";
  }

}

abstract class _Paths {
  static const home = "/home";
  static const pexels = '/pexels';
  @Deprecated('暂时不实现')
  static const pexels_photo = '/photo';
  static const pexels_video = '/video';
  static const pexels_video_watch = '/:id';


  static const scanner ="/scanner";

}
