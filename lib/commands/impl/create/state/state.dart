import 'dart:io';

import 'package:get_cli/functions/controller/add_states.dart';
import 'package:get_cli/functions/controller/find_controllers.dart';
import 'package:get_cli/samples/impl/get_state.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/is_url/is_url.dart';
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
      templatePath: PubspecUtilsTemplates.stateTemplate,
    );
    if (withArgument.isNotEmpty) {
      if (isURL(withArgument)) {
        var res = await get(Uri.parse(withArgument));
        if (res.statusCode == 200) {
          var content = res.body;
          sample.customContent = replaceVars(content, name);
        } else {
          throw CliException(
              LocaleKeys.error_failed_to_connect.trArgs([withArgument]));
        }
      } else {
        var file = File(withArgument);
        if (file.existsSync()) {
          var content = file.readAsStringSync();
          sample.customContent = replaceVars(content, name);
        } else {
          throw CliException(
              LocaleKeys.error_no_valid_file_or_url.trArgs([withArgument]));
        }
      }
    }
    var stateFile = handleFileCreate(
      name,
      'state',
      onCommand,
      extraFolder,
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
      addStatesToController(
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
      withArgument: withArgument,
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
