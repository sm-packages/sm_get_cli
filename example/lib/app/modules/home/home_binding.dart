import 'package:example/app/modules/home/tab_controller.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

/// HomeBinding
class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<TabController>(
        TabController.new,
      ),
      Bind.lazyPut<HomeController>(
        HomeController.new,
      ),
    ];
  }
}
