import 'package:dboy_flutter_app/page/pexels/binding.dart';
import 'package:dboy_flutter_app/page/pexels/page/watch/binding.dart';
import 'package:dboy_flutter_app/page/pexels/page/watch/view.dart';
import 'package:dboy_flutter_app/page/pexels/view.dart';
import 'package:dboy_flutter_app/page/qr/binding.dart';
import 'package:dboy_flutter_app/page/qr/middlewares/permission_middlewares.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create/binding.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create/view.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_history/binding.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_history/view.dart';
import 'package:dboy_flutter_app/page/qr/view.dart';
import 'package:get/get.dart';

import '../page/home/binding.dart';
import '../page/home/view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = _Paths.home;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: _Paths.home,
      page: () => HomePage(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.pexels,
          binding: PexelsBinding(),
          page: () => PexelsPage(),
          children: [
            GetPage(
              name: _Paths.pexels_video + _Paths.pexels_video_watch,
              binding: WatchBinding(),
              page: () => WatchPage(),
            )
          ],
        ),
        GetPage(
            name: _Paths.qr,
            middlewares: [PermissionMiddl()],
            binding: QrBinding(),
            page: () => QrPage(),
            children: [
              GetPage(
                name: _Paths.qr_create,
                binding: QrCreateBinding(),
                page: () => const QrCreatePage(),
              ),
              GetPage(
                name: _Paths.qr_history,
                binding: QrHistoryBinding(),
                page: () => const QrHistoryPage(),
              )
            ])
      ],
    )
  ];
}
