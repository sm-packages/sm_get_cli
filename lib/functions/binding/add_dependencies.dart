import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../create/create_single_file.dart';
import '../replace_vars/replace_vars.dart';

///
/// Add a new dependency to bindings
///
///Example your bindings look like this:
/// ```
///import 'package:get/get.dart';
///import 'home_controller.dart';
///class HomeBinding extends Bindings {
///   @override
///   void dependencies() {
///     Get.lazyPut<HomeController>(
///       () => HomeController()
///     );
///   }
///}
///
///addDependencyToBinding('PATH_YOUR_BINDING',
/// 'DEPENDENCY_NAME', 'DEPENDENCY_DIR' );
///
/// //the exit will be:
///
///import 'package:get/get.dart';
///import 'home_controller.dart';
///import 'package:example/DEPENDENCY_DIR';
///class HomeBinding extends Bindings {
///    @override
///    void dependencies() {
///      Get.lazyPut<DEPENDENCY_NAME>(
///        () => DEPENDENCY_NAME()
///       );
///      Get.lazyPut<HomeController>(
///        () => HomeController()
///       );
///    }
///}
///```
Future<void> addDependencyToBinding(
  String path,
  String controllerName,
  String import,
  bool isVersion5,
) async {
  import = '''import 'package:${PubspecUtils.projectName}/$import';''';
  final insertController = '${controllerName.pascalCase}Controller';

  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    final contains = lines.any((element) => element.contains(insertController));
    if (!contains) {
      lines.insert(2, import);
      var index = lines.indexWhere((element) {
        element = element.trim();
        return element.startsWith(
          isVersion5 ? 'return [' : 'void dependencies() {',
        );
      });
      index++;

      String insertContent;
      if (PubspecUtilsTemplates.insertControllerTemplate.isNotEmpty) {
        insertContent = await loadContent(
          PubspecUtilsTemplates.insertControllerTemplate,
          controllerName,
        );
      } else {
        insertContent =
            '''${isVersion5 ? "Bind" : "Get"}.lazyPut<$insertController>(() => $insertController(),)${isVersion5 ? "," : ";"}''';
      }

      lines.insert(
        index,
        insertContent,
      );

      writeFile(
        file.path,
        lines.join('\n'),
        overwrite: true,
        logger: false,
        useRelativeImport: true,
      );
      LogService.success(
        LocaleKeys.sucess_add_controller_in_bindings.trArgs(
          [
            '${controllerName.pascalCase}Controller',
            path,
          ],
        ),
      );
    }
  }
}
