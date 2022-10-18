import 'package:dboy_flutter_app/routers/app_pages.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionMiddl extends GetMiddleware  {
  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    if (!await Permission.camera.isGranted) {
      var permissionStatus = await Permission.camera.request();
      if(!permissionStatus.isGranted){
        return GetNavConfig.fromRoute(Routes.home);
      }
    }
    return super.redirectDelegate(route);
  }
}
