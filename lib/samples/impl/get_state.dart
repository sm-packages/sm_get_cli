import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../interface/sample_interface.dart';

/// [Sample] file from Module_State file creation.
class StateSample extends Sample {
  final String _fileName;
  final bool _isServer;
  StateSample(
    super.path,
    this._fileName,
    this._isServer, {
    super.overwrite,
  });

  @override
  String get content => _isServer ? serverController : flutterState;

  String get serverController => '''import 'package:get_server/get_server.dart';

class ${_fileName.pascalCase}State {
  // TODO: Implement ${_fileName.pascalCase}State

}
''';

  String get flutterState => '''${PubspecUtils.getPackageImport}

class ${_fileName.pascalCase}State {
  // TODO: Implement ${_fileName.pascalCase}State
  final count = 0.obs;

  void increment() => count.value++;
}
''';
}
