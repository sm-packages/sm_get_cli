import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../create/create_single_file.dart';

void addStatesToController(
  String path,
  String controllerName,
  String import,
  String name,
) {
  import = '''import 'package:${PubspecUtils.projectName}/$import';''';
  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    lines.insert(2, import);
    var index = lines.indexWhere((element) {
      element = element.trim();
      return element.startsWith(
          'class ${controllerName.pascalCase}Controller extends GetxController {');
    });
    index++;
    lines.insert(index,
        'final ${name.pascalCase}State ${name}State = ${name.pascalCase}State();');
    writeFile(
      file.path,
      lines.join('\n'),
      overwrite: true,
      logger: false,
    );
    LogService.success(
      LocaleKeys.sucess_add_state_in_controller.trArgs(
        [
          '${name.pascalCase}State',
          path,
        ],
      ),
    );
  }
}
