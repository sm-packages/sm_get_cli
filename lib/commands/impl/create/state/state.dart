import 'package:sm_get_cli/functions/controller/add_states.dart';
import 'package:sm_get_cli/functions/controller/find_controllers.dart';
import 'package:sm_get_cli/samples/impl/get_state.dart';
import 'package:path/path.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/replace_vars/replace_vars.dart';
import '../../../interface/command.dart';

/// This command is a state with the template:
///```
///class NameState {
///
///}
///```
class CreateStateCommand extends Command {
  @override
  List<String> get alias => ['-st'];

  @override
  String get codeSample => 'get create state:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  String get commandName => 'state';

  @override
  String? get hint => LocaleKeys.hint_create_state.tr;

  @override
  int get maxParameters => 0;

  Future<void> createState(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final isServer = PubspecUtils.isServerProject;
    final extraFolder = PubspecUtils.extraFolder ?? true;
    var sample = StateSample(
      '',
      name,
      isServer,
    );
    if (withArgument.isNotEmpty) {
      sample.customContent = await loadContent(withArgument, name);
    }
    var stateFile = handleFileCreate(
      name,
      'state',
      onCommand,
      onCommand.isNotEmpty ? extraFolder : true,
      sample,
      'states',
    );

    var controllerName = name;
    var controllerPath = findControllerFromName(stateFile.path, controllerName);
    if (controllerPath.isEmpty) {
      controllerName = onCommand;
      controllerPath =
          findControllerFromName(stateFile.path, basename(controllerName));
    }
    var pathSplit = Structure.safeSplitPath(stateFile.path);
    pathSplit.remove('.');
    pathSplit.remove('lib');
    if (controllerPath.isNotEmpty) {
      await addStatesToController(
        controllerPath,
        controllerName,
        pathSplit.join('/'),
        name,
      );
    }
  }

  @override
  Future<void> execute() async {
    return createState(
      name,
      withArgument: withArgument.isEmpty
          ? PubspecUtilsTemplates.stateTemplate
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
