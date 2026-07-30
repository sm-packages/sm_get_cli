import '../interface/sample_interface.dart';

class GenerateLocalesSample extends Sample {
  GenerateLocalesSample(
    this._keys,
    this._locales,
    this._translationsKeys, {
    String? className,
    String path = 'lib/generated/locales.g.dart',
  })  : _className = className,
        super(
          path,
          overwrite: true,
        );
  final String? _className;
  final String _keys;
  final String _locales;
  final String _translationsKeys;

  @override
  String get content => '''
// DO NOT EDIT. This is code generated via package:sm_get_cli/sm_get_cli.dart

// ignore_for_file: lines_longer_than_80_chars, constant_identifier_names
// ignore: avoid_classes_with_only_static_members
class ${_className ?? 'AppTranslation'} {

\tstatic Map<String, Map<String, String>> translations = {
$_translationsKeys
\t};

}

class LocaleKeys {
LocaleKeys._();
$_keys
}

class Locales {
\t$_locales
}
''';
}
