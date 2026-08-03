import 'dart:io';
import 'dart:isolate';

import 'package:yaml/yaml.dart';

import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../logger/log_utils.dart';

class PackageVersion {
  static final _packageLibraryUri = Uri.parse(
    'package:sm_get_cli/sm_get_cli.dart',
  );

  static Future<String?> getVersionCli({bool disableLog = false}) async {
    try {
      final libraryUri = await Isolate.resolvePackageUri(_packageLibraryUri);
      if (libraryUri == null || libraryUri.scheme != 'file') {
        return _versionNotFound(disableLog);
      }

      final pubspecUri = libraryUri.resolve('../pubspec.yaml');
      final pubspec = loadYaml(await File.fromUri(pubspecUri).readAsString());
      final version = pubspec['version']?.toString();
      if (version == null || version.isEmpty) {
        return _versionNotFound(disableLog);
      }

      return version;
    } on Exception catch (_) {
      return _versionNotFound(disableLog);
    }
  }

  static String? _versionNotFound(bool disableLog) {
    if (!disableLog) {
      LogService.error(
        Translation(LocaleKeys.error_cli_version_not_found).tr,
      );
    }
    return null;
  }
}
