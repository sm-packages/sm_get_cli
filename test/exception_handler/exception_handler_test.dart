import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  // Handled CLI failures must remain visible to scripts and CI.
  test('ExceptionHandler leaves a nonzero process exit code', () async {
    final result = await Process.run(
      Platform.resolvedExecutable,
      [p.join('test', 'fixtures', 'exception_handler_main.dart')],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 1);
  });
}
