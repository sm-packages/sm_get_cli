import 'dart:io';

import 'package:get_cli/common/utils/logger/log_utils.dart';
import 'package:get_cli/core/internationalization.dart';
import 'package:get_cli/core/locales.g.dart';

import '../../functions/create/create_single_file.dart';

/// [Sample] is the Base class in which the files for each command
/// will be built.
abstract class Sample {
  String customContent = '';

  /// The path where the sample file will be added
  String path;

  /// If the file is found in the path, it can be ignored or
  /// overwritten. If overrite = false, the source file will not be changed.
  /// The default is [false].
  bool overwrite;

  /// The path of the file that will be used as a template
  String? templatePath;

  Sample(
    this.path, {
    this.overwrite = false,
    this.templatePath,
  });

  /// Store the content that will be written to the file in a String or
  /// Future `<String>` in that variable. It is used to fill the file created
  /// by path.
  String get content;

  /// Store the variables that will be used in the template
  Map<String, String>? get variables => null;

  /// This function will create the file in [path] with the
  /// content of [content].
  File create({bool skipFormatter = false}) {
    return writeFile(
      path,
      customContent.isNotEmpty ? customContent : content,
      overwrite: overwrite,
      skipFormatter: skipFormatter,
      useRelativeImport: true,
    );
  }

  String? renderTemplate() {
    try {
      if (templatePath == null) {
        return null;
      }
      final file = File(Directory(templatePath!).path);
      if (!file.existsSync()) {
        LogService.error(
            LocaleKeys.error_nonexistent_directory.trArgs([templatePath]));
        return null;
      }

      final template = file.readAsStringSync();
      return template.replaceAllMapped(
        RegExp(r'\{\{(\w+)\}\}'),
        (match) {
          final key = match.group(1)!;
          return variables?[key] ?? match.group(0)!;
        },
      );
    } catch (e) {
      LogService.error('${LocaleKeys.error_unexpected.tr} $e');
      return null;
    }
  }
}
