import 'dart:async';
import 'dart:io';

import 'package:get_cli/core/internationalization.dart';
import 'package:http/http.dart';
import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/locales.g.dart';
import '../../exception_handler/exceptions/cli_exception.dart';
import '../is_url/is_url.dart';

String replaceVars(String content, String name, {String? dir}) {
  final pascal = name.pascalCase;
  final project = PubspecUtils.projectName;
  final variables = <String, String>{
    'view': '${pascal}View',
    'screen': '${pascal}Screen',
    'controller': '${pascal}Controller',
    'binding': '${pascal}Binding',
    'state': '${pascal}State',
    'import': PubspecUtils.getPackageImport,
    'package': project,
    'name_pascal': pascal,
    'name': name,
    'import_path': "import 'package:$project/$dir';",
  };

  final regex = RegExp(r'@{(\w+)}');

  return content.replaceAllMapped(regex, (match) {
    final key = match.group(1);
    return variables[key] ?? match.group(0)!;
  });
}

FutureOr<String> loadContent(String path, String name, {String? dir}) async {
  if (isURL(path)) {
    var res = await get(Uri.parse(path));
    if (res.statusCode == 200) {
      var content = res.body;
      return replaceVars(content, name, dir: dir);
    } else {
      throw CliException(LocaleKeys.error_failed_to_connect.trArgs([path]));
    }
  } else {
    var file = File(path);
    if (file.existsSync()) {
      var content = file.readAsStringSync();
      return replaceVars(content, name, dir: dir);
    } else {
      throw CliException(LocaleKeys.error_no_valid_file_or_url.trArgs([path]));
    }
  }
}
