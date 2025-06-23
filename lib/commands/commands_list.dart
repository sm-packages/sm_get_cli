import 'package:get_cli/commands/impl/create/create.dart';
import 'package:get_cli/commands/impl/generate/generate.dart';

import 'impl/commads_export.dart';
import 'interface/command.dart';

final List<Command> commands = [
  CreateCommand(),
  GenerateCommand(),
  HelpCommand(),
  VersionCommand(),
  InitCommand(),
  InstallCommand(),
  RemoveCommand(),
  SortCommand(),
  UpdateCommand(),
];

class CommandParent extends Command {
  final String _name;
  final List<String> _alias;
  final List<Command> _childrens;
  CommandParent(this._name, this._childrens, [this._alias = const []]);

  @override
  List<String> get alias => _alias;
  @override
  List<Command> get childrens => _childrens;

  @override
  String get codeSample => '';

  @override
  String get commandName => _name;

  @override
  String get hint => '';

  @override
  int get maxParameters => 0;

  @override
  Future<void> execute() async {}

  @override
  bool validate() => true;
}
