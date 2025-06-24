import 'package:get/get.dart';

import 'me_controller.dart';

/// MeBinding
class MeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<MeController>(
        MeController.new,
      ),
    ];
  }
}
