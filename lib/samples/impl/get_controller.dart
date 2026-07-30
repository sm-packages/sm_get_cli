import 'package:sm_get_cli/common/utils/pubspec/pubspec_utils.dart';
import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class ControllerSample extends Sample {
  final String _fileName;
  final bool _isServer;
  final String? _stateDir;
  ControllerSample(
    super.path,
    this._fileName,
    this._stateDir,
    this._isServer, {
    super.overwrite,
  });

  String get import => _stateDir != null && _stateDir!.isNotEmpty
      ? '''import 'package:${PubspecUtils.projectName}/$_stateDir';'''
      : '';

  @override
  String get content => _isServer ? serverController : flutterController;

  String get serverController => '''import 'package:get_server/get_server.dart';

class ${_fileName.pascalCase}Controller extends GetxController {
  // TODO: Implement ${_fileName.pascalCase}Controller

  $state

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

}
''';

  String get flutterController => '''import 'package:get/get.dart';
$import

class ${_fileName.pascalCase}Controller extends GetxController {
  // TODO: Implement ${_fileName.pascalCase}Controller

  $state

  ${_stateDir == null ? 'final count = 0.obs;' : ''}
  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }
  ${_stateDir == null ? 'void increment() => count.value++;' : ''}
}
''';

  String get state => _stateDir != null
      ? 'final ${_fileName.pascalCase}State state = ${_fileName.pascalCase}State();'
      : '';
}
