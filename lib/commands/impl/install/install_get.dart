import '../../../common/utils/pubspec/pubspec_utils.dart';

Future<void> installGet([bool runPubGet = false]) async {
  if (PubspecUtilsExt.getPackagePrefix != 'get') return;

  PubspecUtils.removeDependencies('get', logger: false);
  // TODO: 当 get 5 正式发布之后修改
  final isVersion5 = PubspecUtilsExt.getxVersion == 5;
  final version = isVersion5 ? '5.0.0-release-candidate-9.3.2' : null;
  await PubspecUtils.addDependencies(
    'get',
    runPubGet: runPubGet,
    version: version,
  );
}
