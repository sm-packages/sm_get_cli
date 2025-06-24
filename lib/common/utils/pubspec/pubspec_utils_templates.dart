part of 'pubspec_utils.dart';

extension PubspecUtilsTemplates on PubspecUtils {
  static Map get _getCliMap => PubspecUtilsExt._getCliMap;

  static final _templates = _PubValue<Map>(
    () {
      try {
        if (_getCliMap.containsKey('templates')) {
          var template = Map.from(_getCliMap['templates'] as Map? ?? {});
          final path = template['path'] as String?;

          if (path != null && Directory(path).existsSync()) {
            final files = Directory(path)
                .listSync(recursive: false)
                .where((entry) => entry.path.endsWith('.template'))
                .toList();

            for (var file in files) {
              final name =
                  basenameWithoutExtension(file.path).removeAll('.dart');
              template.putIfAbsent(name, () => file.path);
            }
          }

          return template;
        }
      } on Exception catch (_) {}
      return {};
    },
  );

  /// 配置的模板
  static Map get templates => _templates.value ?? {};

  /// 配置的 controller 模板
  static String get controllerTemplate => templates['controller'] ?? '';

  /// 配置的 page 模板
  static String get pageTemplate =>
      templates['page'] ?? templates['view'] ?? '';

  /// 配置的 binding 模板
  static String get bindingTemplate => templates['binding'] ?? '';

  /// 配置的 state 模板
  static String get stateTemplate => templates['state'] ?? '';

  /// 配置的插入 state 模板
  static String get insertStateTemplate => templates['insert_state'] ?? '';

  /// 配置的插入 controller 模板
  static String get insertControllerTemplate =>
      templates['insert_controller'] ?? '';
}
