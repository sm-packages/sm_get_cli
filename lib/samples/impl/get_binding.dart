import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../interface/sample_interface.dart';

/// [Sample] file from Module_Binding file creation.
class BindingSample extends Sample {
  final String _fileName;
  final String _controllerDir;
  final String _bindingName;
  final bool _isServer;
  final bool isVersion5;

  BindingSample(
    super.path,
    this._fileName,
    this._bindingName,
    this._controllerDir,
    this._isServer, {
    super.overwrite,
    this.isVersion5 = false,
    super.templatePath,
  });

  String get _import => _isServer
      ? "import 'package:get_server/get_server.dart';"
      : "import 'package:get/get.dart';";

  @override
  String get content =>
      renderTemplate() ??
      '''$_import
import 'package:${PubspecUtils.projectName}/$_controllerDir';

class $_bindingName extends Binding${isVersion5 ? '' : 's'} {
  @override
  ${isVersion5 ? 'List<Bind>' : 'void'} dependencies() {
    ${isVersion5 ? "return [\nBind" : "Get"}.lazyPut<${_fileName.pascalCase}Controller>(
      () => ${_fileName.pascalCase}Controller(),
    )${isVersion5 ? ",\n]" : ""};
  }
}
''';

  @override
  Map<String, String>? get variables => {
        'import_path':
            "import 'package:${PubspecUtils.projectName}/$_controllerDir';",
        'name': _fileName.pascalCase,
      };
}
