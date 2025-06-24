import 'package:get/get.dart';

import 'home_controller.dart';

/// HomeBinding
class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<HomeController>(
        HomeController.new,
      ),
    ];
  }
}
