import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/page/pexels/binding.dart';
import 'package:dboy_flutter_app/page/pexels/page/watch/binding.dart';
import 'package:dboy_flutter_app/page/pexels/page/watch/view.dart';
import 'package:dboy_flutter_app/page/pexels/view.dart';
import 'package:dboy_flutter_app/page/qr/binding.dart';
import 'package:dboy_flutter_app/page/qr/middlewares/permission_middlewares.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create/binding.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create/view.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create_type/binding.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_create_type/view.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_history/binding.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_history/view.dart';
import 'package:dboy_flutter_app/page/qr/view.dart';
import 'package:dboy_flutter_app/routers/route_keys.dart';
import 'package:get/get.dart';

import '../page/home/binding.dart';
import '../page/home/view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = _Paths.home;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: _Paths.home,
      transition: Transition.cupertino,
      page: () => HomePage(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.pexels,
          transition: Transition.cupertino,
          binding: PexelsBinding(),
          page: () => PexelsPage(),
          children: [
            GetPage(
              name: _Paths.pexels_video + _Paths.pexels_video_watch,
              transition: Transition.cupertino,
              binding: WatchBinding(),
              page: () => WatchPage(),
            )
          ],
        ),
        GetPage(
            name: _Paths.qr,
            transition: Transition.cupertino,
            middlewares: [PermissionMiddl()],
            binding: QrBinding(),
            page: () => QrPage(),
            children: [
              GetPage(
                  name: _Paths.qr_create,
                  transition: Transition.cupertino,
                  binding: QrCreateBinding(),
                  page: () => const QrCreatePage(),
                  children: [
                    GetPage(
                      name: _Paths.qr_create_type,
                      transition: Transition.cupertino,
                      binding: QrCreateTypeBinding(),
                      page: () => QrCreateTypePage(),
                    )
                  ]),
              GetPage(
                name: _Paths.qr_history,
                transition: Transition.cupertino,
                binding: QrHistoryBinding(),
                page: () => const QrHistoryPage(),
              )
            ])
      ],
    )
  ];
}
