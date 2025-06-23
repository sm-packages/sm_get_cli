import 'package:get_cli/commands/impl/create/controller/controller.dart';
import 'package:get_cli/commands/impl/create/page/page.dart';
import 'package:get_cli/commands/impl/create/project/project.dart';
import 'package:get_cli/commands/impl/create/provider/provider.dart';
import 'package:get_cli/commands/impl/create/screen/screen.dart';
import 'package:get_cli/commands/impl/create/view/view.dart';
import 'package:get_cli/commands/interface/command.dart';

class CreateCommand extends Command {
  CreateCommand();

  @override
  List<String> get alias => ['-c'];
  @override
  List<Command> get childrens => [
        CreateControllerCommand(),
        CreatePageCommand(),
        CreateProjectCommand(),
        CreateProviderCommand(),
        CreateScreenCommand(),
        CreateViewCommand(),
      ];

  @override
  String get codeSample => '';

  @override
  String get commandName => 'create';

  @override
  String get hint => '';

  @override
  int get maxParameters => 0;

  @override
  Future<void> execute() async {}

  @override
  bool validate() => true;
}
