import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _getImport = "import 'package:get/get.dart';";
const _customGetImport = "import 'package:custom_get/get.dart';";
const _importTestTimeout = Timeout(Duration(minutes: 2));

void main() {
  test(
    'get_package_prefix selects imports for every generated Flutter sample',
    () async {
      await _expectImports(
        pubspec: _pubspec(getPackagePrefix: 'custom_get', server: true),
        expected: "import 'package:get_server/get_server.dart';",
        unexpected: [_getImport, _customGetImport],
      );
      await _expectImports(
        pubspec: _pubspec(),
        expected: _getImport,
        unexpected: [_customGetImport],
      );
      await _expectImports(
        pubspec: _pubspec(getPackagePrefix: 'custom_get'),
        expected: _customGetImport,
        unexpected: [_getImport],
      );
      await _expectImports(
        pubspec: _pubspec(),
        getCli: 'get_package_prefix: custom_get\n',
        expected: _customGetImport,
        unexpected: [_getImport],
      );
    },
    timeout: _importTestTimeout,
  );

  for (final invalidValue in ['""', 'invalid-name', '123']) {
    test(
      'get_package_prefix rejects $invalidValue',
      () async {
        final result = await _runFixture(
          pubspec: _pubspec(getPackagePrefix: invalidValue),
        );

        expect(result.exitCode, isNot(0));
        expect(
          '${result.stdout}${result.stderr}',
          contains('get_package_prefix must be a valid Dart package name'),
        );
      },
      timeout: _importTestTimeout,
    );
  }

  for (final command in ['controller', 'state']) {
    test(
      'Get Server $command rejects an invalid get_package_prefix',
      () async {
        final result = await _runFixture(
          pubspec: _pubspec(getPackagePrefix: 'invalid-name', server: true),
          arguments: ['create-$command'],
        );

        expect(result.exitCode, isNot(0));
        expect(
          '${result.stdout}${result.stderr}',
          contains('get_package_prefix must be a valid Dart package name'),
        );
      },
      timeout: _importTestTimeout,
    );
  }
}

String _pubspec({String? getPackagePrefix, bool server = false}) => '''
name: import_fixture
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:${server ? '\n  get_server: any' : ' {}'}
${getPackagePrefix == null ? '' : 'get_cli:\n  get_package_prefix: $getPackagePrefix'}
''';

Future<void> _expectImports({
  required String pubspec,
  required String expected,
  required List<String> unexpected,
  String? getCli,
}) async {
  final result = await _runFixture(pubspec: pubspec, getCli: getCli);
  expect(result.exitCode, 0, reason: result.stderr.toString());
  final samples =
      (jsonDecode(result.stdout.toString()) as Map).cast<String, String>();
  for (final MapEntry(:key, :value) in samples.entries) {
    expect(value, contains(expected), reason: key);
    for (final import in unexpected) {
      expect(value, isNot(contains(import)), reason: key);
    }
  }
}

Future<ProcessResult> _runFixture({
  required String pubspec,
  String? getCli,
  List<String> arguments = const [],
}) async {
  final workspace = await Directory.systemTemp.createTemp(
    'sm_get_cli_import_test_',
  );
  try {
    await File(p.join(workspace.path, 'pubspec.yaml')).writeAsString(pubspec);
    if (getCli != null) {
      await File(p.join(workspace.path, '.get_cli.yaml')).writeAsString(getCli);
    }

    final fixture = p.join(
      Directory.current.path,
      'test',
      'fixtures',
      'get_package_import_main.dart',
    );
    return await Process.run(
      Platform.resolvedExecutable,
      [fixture, ...arguments],
      workingDirectory: workspace.path,
    );
  } finally {
    await workspace.delete(recursive: true);
  }
}
