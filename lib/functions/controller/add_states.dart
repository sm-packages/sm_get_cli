import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../create/create_single_file.dart';
import '../replace_vars/replace_vars.dart';

Future<void> addStatesToController(
  String path,
  String controllerName,
  String import,
  String name,
) async {
  import = '''import 'package:${PubspecUtils.projectName}/$import';''';
  final insertState = '${name.pascalCase}State';
  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    final contains = lines.any((element) => element.contains(insertState));
    if (!contains) {
      lines.insert(2, import);
      var index = lines.indexWhere((element) {
        element = element.trim();
        return element.startsWith(
          'class ${controllerName.pascalCase}Controller extends GetxController {',
        );
      });
      index++;

      String insertContent;
      if (PubspecUtilsTemplates.insertStateTemplate.isNotEmpty) {
        insertContent = await loadContent(
          PubspecUtilsTemplates.insertStateTemplate,
          controllerName,
        );
      } else {
        insertContent = 'final $insertState ${name}State = $insertState();';
      }

      lines.insert(
        index,
        insertContent,
      );

      writeFile(
        file.path,
        lines.join('\n'),
        overwrite: true,
        logger: false,
        useRelativeImport: true,
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
}
