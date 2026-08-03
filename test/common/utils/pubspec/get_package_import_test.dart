import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _getImport = "import 'package:get/get.dart';";
const _smGetxImport = "import 'package:sm_getx/get.dart';";
const _importTestTimeout = Timeout(Duration(minutes: 2));

void main() {
  test(
    'use_sm_getx selects imports for every generated Flutter sample',
    () async {
      await _expectImports(
        pubspec: _pubspec(useSmGetx: true, server: true),
        expected: "import 'package:get_server/get_server.dart';",
        unexpected: [_getImport, _smGetxImport],
      );
      await _expectImports(
        pubspec: _pubspec(),
        expected: _getImport,
        unexpected: [_smGetxImport],
      );
      await _expectImports(
        pubspec: _pubspec(useSmGetx: true),
        expected: _smGetxImport,
        unexpected: [_getImport],
      );
      await _expectImports(
        pubspec: _pubspec(),
        getCli: 'use_sm_getx: true\n',
        expected: _smGetxImport,
        unexpected: [_getImport],
      );
    },
    timeout: _importTestTimeout,
  );
}

String _pubspec({bool useSmGetx = false, bool server = false}) => '''
name: import_fixture
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:${server ? '\n  get_server: any' : ' {}'}
${useSmGetx ? 'get_cli:\n  use_sm_getx: true' : ''}
''';

Future<void> _expectImports({
  required String pubspec,
  required String expected,
  required List<String> unexpected,
  String? getCli,
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
    final result = await Process.run(
      Platform.resolvedExecutable,
      [fixture],
      workingDirectory: workspace.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());
    final samples =
        (jsonDecode(result.stdout.toString()) as Map).cast<String, String>();
    for (final MapEntry(:key, :value) in samples.entries) {
      expect(value, contains(expected), reason: key);
      for (final import in unexpected) {
        expect(value, isNot(contains(import)), reason: key);
      }
    }
  } finally {
    await workspace.delete(recursive: true);
  }
}
