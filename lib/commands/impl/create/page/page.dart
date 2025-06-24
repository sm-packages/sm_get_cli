import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:get_cli/functions/replace_vars/replace_vars.dart';
import 'package:get_cli/samples/impl/get_state.dart';
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/routes/get_add_route.dart';
import '../../../../samples/impl/get_binding.dart';
import '../../../../samples/impl/get_controller.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

/// The command create a Binding and Controller page and view
class CreatePageCommand extends Command {
  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['module', '-p', '-m'];

  @override
  Future<void> execute() async {
    var isProject = false;
    if (GetCli.arguments[0] == 'create' || GetCli.arguments[0] == '-c') {
      isProject = GetCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  @override
  String? get hint => LocaleKeys.hint_create_page.tr;

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'page', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title:
            Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        // final dialog = CLI_Dialog();
        // dialog.addQuestion(LocaleKeys.ask_new_page_name.tr, 'name');
        // name = dialog.ask()['name'] as String?;
        var name = ask(LocaleKeys.ask_new_page_name.tr);
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  Future<void> _writeFiles(
    String path,
    String name, {
    bool overwrite = false,
  }) async {
    final isServer = PubspecUtils.isServerProject;
    final extraFolder = PubspecUtils.extraFolder ?? true;
    final pageName = PubspecUtilsExt.pageName;
    final isVersion5 = PubspecUtilsExt.getxVersion == 5;
    final useState = PubspecUtilsExt.useState;
    String? stateDir;
    if (useState) {
      var stateSample = StateSample(
        '',
        name,
        isServer,
        overwrite: overwrite,
      );
      if (PubspecUtilsTemplates.stateTemplate.isNotEmpty) {
        stateSample.customContent =
            await loadContent(PubspecUtilsTemplates.stateTemplate, name);
      }
      final stateFile = handleFileCreate(
        name,
        'state',
        path,
        extraFolder,
        stateSample,
        'states',
      );
      stateDir = Structure.pathToDirImport(stateFile.path);
    }

    var controllerSample = ControllerSample(
      '',
      name,
      stateDir,
      isServer,
      overwrite: overwrite,
    );
    if (PubspecUtilsTemplates.controllerTemplate.isNotEmpty) {
      controllerSample.customContent = await loadContent(
        PubspecUtilsTemplates.controllerTemplate,
        name,
        dir: stateDir,
      );
    }
    var controllerFile = handleFileCreate(
      name,
      'controller',
      path,
      extraFolder,
      controllerSample,
      'controllers',
    );
    var controllerDir = Structure.pathToDirImport(controllerFile.path);
    var getViewSample = GetViewSample(
      '',
      '${name.pascalCase}${pageName.pascalCase}',
      '${name.pascalCase}Controller',
      controllerDir,
      isServer,
      overwrite: overwrite,
    );
    if (PubspecUtilsTemplates.pageTemplate.isNotEmpty) {
      getViewSample.customContent = await loadContent(
        PubspecUtilsTemplates.pageTemplate,
        name,
        dir: controllerDir,
      );
    }
    var viewFile = handleFileCreate(
      name,
      pageName.toLowerCase(),
      path,
      extraFolder,
      getViewSample,
      'views',
    );

    var bindingSample = BindingSample(
      '',
      name,
      '${name.pascalCase}Binding',
      controllerDir,
      isServer,
      overwrite: overwrite,
      isVersion5: isVersion5,
    );
    if (PubspecUtilsTemplates.bindingTemplate.isNotEmpty) {
      bindingSample.customContent = await loadContent(
        PubspecUtilsTemplates.bindingTemplate,
        name,
        dir: controllerDir,
      );
    }
    var bindingFile = handleFileCreate(
      name,
      'binding',
      path,
      extraFolder,
      bindingSample,
      'bindings',
    );

    addRoute(
      name,
      Structure.pathToDirImport(bindingFile.path),
      Structure.pathToDirImport(viewFile.path),
    );
    LogService.success(
      LocaleKeys.sucess_page_create.trArgs(
        [name.pascalCase],
      ),
    );
  }

  @override
  String get codeSample => 'get create page:product';

  @override
  int get maxParameters => 0;
}
