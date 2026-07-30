import 'package:dart_style/dart_style.dart';
import 'package:sm_get_cli/common/utils/pubspec/pubspec_utils.dart';

/// Format a dart file
String formatterDartFile(String content) {
  var formatter = DartFormatter(
    languageVersion: PubspecUtils.tallStyle
        ? DartFormatter.latestLanguageVersion
        : DartFormatter.latestShortStyleLanguageVersion,
  );
  return formatter.format(content);
}
