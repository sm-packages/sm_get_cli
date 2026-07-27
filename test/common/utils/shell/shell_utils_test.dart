import 'dart:io';

import 'package:get_cli/common/utils/shell/shel.utils.dart';
import 'package:test/test.dart';

void main() {
  // Flutter app creation must keep Android selection and stop on CLI failures.
  test('flutterCreate passes supported arguments and propagates failures',
      () async {
    late String executable;
    late List<String> arguments;

    final create = ShellUtils.flutterCreate(
      '/tmp/example app',
      'com.example',
      'java',
      processRunner: (command, commandArguments) async {
        executable = command;
        arguments = commandArguments;
        return ProcessResult(1, 64, '', 'invalid option');
      },
    );

    await expectLater(
      create,
      throwsA(
        isA<ProcessException>()
            .having((error) => error.errorCode, 'errorCode', 64)
            .having((error) => error.message, 'message', 'invalid option'),
      ),
    );
    expect(executable, 'flutter');
    expect(arguments, [
      'create',
      '--no-pub',
      '--android-language',
      'java',
      '--org',
      'com.example',
      '/tmp/example app',
    ]);
  });
}
