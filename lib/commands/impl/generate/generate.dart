import 'package:get_cli/commands/impl/generate/locales/locales.dart';
import 'package:get_cli/commands/impl/generate/model/model.dart';
import 'package:get_cli/commands/interface/command.dart';

class GenerateCommand extends Command {
  GenerateCommand();

  @override
  List<String> get alias => ['-g'];
  @override
  List<Command> get childrens => [
        GenerateLocalesCommand(),
        GenerateModelCommand(),
      ];

  @override
  String get codeSample => '';

  @override
  String get commandName => 'generate';

  @override
  String get hint => '';

  @override
  int get maxParameters => 0;

  @override
  Future<void> execute() async {}

  @override
  bool validate() => true;

  @override
  bool get showHelp => true;
}
