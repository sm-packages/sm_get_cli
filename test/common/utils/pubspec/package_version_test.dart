import 'dart:io';

import 'package:sm_get_cli/common/utils/pubspec/package_version.dart';
import 'package:sm_get_cli/common/utils/pubspec/pubspec_lock.dart' as legacy;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('version helpers return the package version', () async {
    final pubspec = loadYaml(await File('pubspec.yaml').readAsString());
    final expectedVersion = pubspec['version'].toString();

    expect(
      await PackageVersion.getVersionCli(disableLog: true),
      expectedVersion,
    );

    expect(
      // ignore: deprecated_member_use_from_same_package
      await legacy.PubspecLock.getVersionCli(disableLog: true),
      expectedVersion,
    );
  });
}
