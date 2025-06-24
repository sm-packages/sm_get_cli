import 'package:path/path.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/binding/add_dependencies.dart';
import '../../../../functions/binding/find_bindings.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/replace_vars/replace_vars.dart';
import '../../../../samples/impl/get_controller.dart';
import '../../../../samples/impl/get_state.dart';
import '../../../interface/command.dart';

/// This command is a controller with the template:
///```
///import 'package:get/get.dart';,
///
///class NameController extends GetxController {
///
///}
///```
class CreateControllerCommand extends Command {
  @override
  List<String> get alias => ['-ctrl'];

  @override
  String get codeSample => 'get create controller:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  String get commandName => 'controller';

  @override
  String? get hint => LocaleKeys.hint_create_controller.tr;

  @override
  int get maxParameters => 0;

  Future<void> createController(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final isServer = PubspecUtils.isServerProject;
    final extraFolder = PubspecUtils.extraFolder ?? true;
    final useState = PubspecUtilsExt.useState;
    String? stateDir;
    if (useState) {
      var stateSample = StateSample(
        '',
        name,
        isServer,
      );
      if (PubspecUtilsTemplates.stateTemplate.isNotEmpty) {
        stateSample.customContent =
            await loadContent(PubspecUtilsTemplates.stateTemplate, name);
      }
      final stateFile = handleFileCreate(
        name,
        'state',
        onCommand,
        onCommand.isNotEmpty ? extraFolder : true,
        stateSample,
        'states',
      );
      stateDir = Structure.pathToDirImport(stateFile.path);
    }
    var sample = ControllerSample(
      '',
      name,
      stateDir,
      isServer,
    );
    if (withArgument.isNotEmpty) {
      sample.customContent =
          await loadContent(withArgument, name, dir: stateDir);
    }
    var controllerFile = handleFileCreate(
      name,
      'controller',
      onCommand,
      onCommand.isNotEmpty ? extraFolder : true,
      sample,
      'controllers',
    );

    final isVersion5 = PubspecUtilsExt.getxVersion == 5;
    var binindingPath =
        findBindingFromName(controllerFile.path, basename(onCommand));
    var pathSplit = Structure.safeSplitPath(controllerFile.path);
    pathSplit.remove('.');
    pathSplit.remove('lib');
    if (binindingPath.isNotEmpty) {
      await addDependencyToBinding(
        binindingPath,
        name,
        pathSplit.join('/'),
        isVersion5,
      );
    }
  }

  @override
  Future<void> execute() async {
    return createController(
      name,
      withArgument: withArgument.isEmpty
          ? PubspecUtilsTemplates.controllerTemplate
          : withArgument,
      onCommand: onCommand,
    );
  }

  @override
  bool validate() {
    super.validate();
    if (args.length > 2) {
      var unnecessaryParameter = args.skip(2).toList();
      throw CliException(
        LocaleKeys.error_unnecessary_parameter.trArgsPlural(
          LocaleKeys.error_unnecessary_parameter_plural,
          unnecessaryParameter.length,
          [unnecessaryParameter.toString()],
        ),
        codeSample: codeSample,
      );
    }
    return true;
  }
}
