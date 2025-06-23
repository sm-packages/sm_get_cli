part of 'pubspec_utils.dart';

/// 工具拓展
extension PubspecUtilsExt on PubspecUtils {
  static final _pageName = _PubValue<String?>(
    () {
      try {
        if (_getCliMap.containsKey('page_name')) {
          return (_getCliMap['page_name'] as String);
        }
      } on Exception catch (_) {}
      return null;
    },
  );

  static final _localesClassName = _PubValue<String?>(
    () {
      try {
        if (_getLocales.containsKey('class_name')) {
          return (_getLocales['class_name'] as String);
        }
      } on Exception catch (_) {}
      return null;
    },
  );
  static final _localesFileName = _PubValue<String?>(
    () {
      try {
        if (_getLocales.containsKey('file_name')) {
          return (_getLocales['file_name'] as String);
        }
      } on Exception catch (_) {}
      return null;
    },
  );

  static final _localesOutput = _PubValue<String?>(
    () {
      try {
        if (_getLocales.containsKey('output')) {
          return (_getLocales['output'] as String);
        }
      } on Exception catch (_) {}
      return null;
    },
  );
  static final _localesInput = _PubValue<String?>(
    () {
      try {
        if (_getLocales.containsKey('input')) {
          return (_getLocales['input'] as String);
        }
      } on Exception catch (_) {}
      return null;
    },
  );

  static final _getxVersion = _PubValue<int?>(
    () {
      try {
        if (_getCliMap.containsKey('version')) {
          return (_getCliMap['version'] as int);
        }
      } on Exception catch (_) {}
      return null;
    },
  );

  /// 配置的 Getx Version
  static int get getxVersion => _getxVersion.value ?? 4;

  /// 配置的本地化类名 localesClassName
  static String? get localesClassName => _localesClassName.value;

  /// 配置的本地化文件 localesFileName
  static String? get localesFileName => _localesFileName.value;

  /// 配置的本地化输入路径
  static String? get localesInput => _localesInput.value;

  /// 配置的本地化输出路径
  static String? get localesOutput => _localesOutput.value;

  /// 配置的 pageName
  static String get pageName => _pageName.value ?? 'page';

  /// 获取 pubspec 配置
  static dynamic get pubspecJson => PubspecUtils.pubspecJson;

  /// 获取 get_cli 配置
  static dynamic get getCliJson => PubspecUtils.getCliJson;

  static Map get _getCliMap {
    try {
      if (pubspecJson != null && pubspecJson.containsKey('get_cli')) {
        return (pubspecJson['get_cli'] as Map);
      }
      if (getCliJson != null) {
        return getCliJson as Map;
      }
    } on Exception catch (_) {}
    return {};
  }

  static Map get _getLocales => _getCliMap.containsKey('locales')
      ? _getCliMap['locales'] as Map? ?? {}
      : {};

  static bool updateGetCliYaml(
    String key,
    dynamic value, {
    bool logger = true,
  }) {
    try {
      YamlMap? yaml;
      bool isGetCli = false;
      try {
        yaml = getCliJson as YamlMap?;
        isGetCli = true;
      } catch (e) {
        yaml = pubspecJson['get_cli'] as YamlMap?;
        isGetCli = false;
      }
      final entries = yaml?.entries;
      final yamlEditor = YamlEditor(
        isGetCli ? PubspecUtils.getCliString : PubspecUtils.pubspecString,
      );
      final List<Object?> path = isGetCli ? [] : ['get_cli'];
      final file =
          isGetCli ? PubspecUtils._getCliFile : PubspecUtils._pubspecFile;
      var newVaule = Map.fromEntries(entries ?? {})..[key] = value;
      // 创建一个 YamlEditor 来编辑 YAML 文件
      yamlEditor.update(path, newVaule);

      file.writeAsStringSync(yamlEditor.toString());
    } on Exception catch (_) {
      return false;
    }
    if (logger) {
      LogService.success(
          LocaleKeys.sucess_update_yaml.trArgs(['$key: $value']));
    }
    return true;
  }
}
