import 'package:recase/recase.dart';

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
    super.templatePath,
  });

  @override
  String get content =>
      renderTemplate() ?? (_isServer ? serverController : flutterState);

  String get serverController => '''import 'package:get_server/get_server.dart';

class ${_fileName.pascalCase}State {
  // TODO: Implement ${_fileName.pascalCase}State

}
''';

  String get flutterState => '''import 'package:get/get.dart';

class ${_fileName.pascalCase}State {
  // TODO: Implement ${_fileName.pascalCase}State
  final count = 0.obs;

  void increment() => count.value++;
}
''';

  @override
  Map<String, String>? get variables => {
        'name': _fileName.pascalCase,
      };
}
