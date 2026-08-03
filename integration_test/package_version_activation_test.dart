import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

const _activationTimeout = Timeout(Duration(minutes: 5));

void main() {
  test(
    'path and Git activation expose both version commands',
    () async {
      final workspace = await Directory.systemTemp.createTemp(
        'sm_get_cli_activation_test_',
      );
      addTearDown(() => workspace.delete(recursive: true));

      final packageCopy = Directory(p.join(workspace.path, 'package'));
      await _copyPackage(Directory.current, packageCopy);
      final expectedVersion = await _readVersion(packageCopy);
      await _initializeGitRepository(packageCopy);

      await _activateAndVerify(
        source: 'path',
        package: packageCopy.path,
        expectedVersion: expectedVersion,
        pubCache: Directory(p.join(workspace.path, 'path-cache')),
        workingDirectory: workspace,
      );
      await _activateAndVerify(
        source: 'git',
        package: packageCopy.uri.toString(),
        expectedVersion: expectedVersion,
        pubCache: Directory(p.join(workspace.path, 'git-cache')),
        workingDirectory: workspace,
      );
    },
    timeout: _activationTimeout,
  );

  final hostedVersion = Platform.environment['SM_GET_CLI_HOSTED_VERSION'];
  test(
    'hosted activation exposes both version commands',
    () async {
      final workspace = await Directory.systemTemp.createTemp(
        'sm_get_cli_hosted_activation_test_',
      );
      addTearDown(() => workspace.delete(recursive: true));

      await _activateAndVerify(
        source: 'hosted',
        package: 'sm_get_cli',
        versionConstraint: hostedVersion,
        expectedVersion: hostedVersion!,
        pubCache: Directory(p.join(workspace.path, 'hosted-cache')),
        workingDirectory: workspace,
      );
    },
    skip: hostedVersion == null
        ? 'Set SM_GET_CLI_HOSTED_VERSION after publishing a release.'
        : false,
    timeout: _activationTimeout,
  );
}

Future<void> _copyPackage(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await File(
    p.join(source.path, 'pubspec.yaml'),
  ).copy(p.join(destination.path, 'pubspec.yaml'));

  for (final directoryName in ['bin', 'lib']) {
    await _copyDirectory(
      Directory(p.join(source.path, directoryName)),
      Directory(p.join(destination.path, directoryName)),
    );
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: true, followLinks: false)) {
    final relativePath = p.relative(entity.path, from: source.path);
    final targetPath = p.join(destination.path, relativePath);

    if (entity is Directory) {
      await Directory(targetPath).create(recursive: true);
    } else if (entity is File) {
      await File(targetPath).parent.create(recursive: true);
      await entity.copy(targetPath);
    }
  }
}

Future<String> _readVersion(Directory packageDirectory) async {
  final pubspec = loadYaml(
    await File(p.join(packageDirectory.path, 'pubspec.yaml')).readAsString(),
  );
  return pubspec['version'].toString();
}

Future<void> _initializeGitRepository(Directory packageDirectory) async {
  await _runChecked('git', ['init', '-q'], packageDirectory);
  await _runChecked('git', ['add', '--all'], packageDirectory);
  await _runChecked(
    'git',
    [
      '-c',
      'user.name=sm_get_cli tests',
      '-c',
      'user.email=sm_get_cli-tests@example.invalid',
      'commit',
      '-q',
      '-m',
      'activation fixture',
    ],
    packageDirectory,
  );
}

Future<void> _activateAndVerify({
  required String source,
  required String package,
  required String expectedVersion,
  required Directory pubCache,
  required Directory workingDirectory,
  String? versionConstraint,
}) async {
  await pubCache.create(recursive: true);
  final activationArguments = [
    'pub',
    'global',
    'activate',
    '--source',
    source,
    package,
    if (versionConstraint != null) versionConstraint,
  ];
  await _runChecked(
    Platform.resolvedExecutable,
    activationArguments,
    workingDirectory,
    environment: {'PUB_CACHE': pubCache.path},
  );

  for (final command in ['get', 'getx']) {
    final executable = p.join(
      pubCache.path,
      'bin',
      Platform.isWindows ? '$command.bat' : command,
    );
    final result = await Process.run(
      executable,
      ['--version'],
      workingDirectory: workingDirectory.path,
      environment: {'PUB_CACHE': pubCache.path},
      runInShell: Platform.isWindows,
    );

    expect(
      result.exitCode,
      0,
      reason: _processFailure('$executable --version', result),
    );
    expect(
      result.stdout.toString(),
      contains('Version: $expectedVersion'),
      reason: '$command did not report the activated package version.',
    );
  }
}

Future<void> _runChecked(
  String executable,
  List<String> arguments,
  Directory workingDirectory, {
  Map<String, String>? environment,
}) async {
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory.path,
    environment: environment,
  );
  expect(
    result.exitCode,
    0,
    reason: _processFailure(
      '$executable ${arguments.join(' ')}',
      result,
    ),
  );
}

String _processFailure(String command, ProcessResult result) => '''
$command failed with exit code ${result.exitCode}.
stdout:
${result.stdout}
stderr:
${result.stderr}
''';
