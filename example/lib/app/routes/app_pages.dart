import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/home/me/me_binding.dart';
import '../modules/home/me/me_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.me,
          page: () => const MePage(),
          binding: MeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.me,
      page: () => const MePage(),
      binding: MeBinding(),
    ),
  ];
}
