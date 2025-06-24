import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/structure.dart';

String findControllerFromName(String path, String name) {
  path = Structure.replaceAsExpected(path: path);
  var splitPath = Structure.safeSplitPath(path);
  splitPath
    ..remove('.')
    ..removeLast();

  var controllerPath = '';
  while (splitPath.isNotEmpty && controllerPath == '') {
    Directory(splitPath.join(separator))
        .listSync(recursive: true, followLinks: false)
        .forEach((element) {
      if (element is File) {
        var fileName = basename(element.path);
        final separatorFileType = PubspecUtils.separatorFileType ?? '_';
        if (fileName ==
            '${name.snakeCase}${separatorFileType}controller.dart') {
          controllerPath = element.path;
        }
      }
    });
    splitPath.removeLast();
  }
  return controllerPath;
}
