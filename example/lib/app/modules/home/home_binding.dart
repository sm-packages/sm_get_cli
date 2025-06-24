import 'package:get/get.dart';

import 'home_controller.dart';
import 'tab_controller.dart';

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
