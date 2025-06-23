import '../../../common/utils/logger/log_utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../commands_list.dart';
import '../../interface/command.dart';

class HelpCommand extends Command {
  HelpCommand({List<Command>? commands, Command? command})
      : _commands = commands,
        _command = command;

  final List<Command>? _commands;
  final Command? _command;

  @override
  String get commandName => 'help';

  @override
  String? get hint => Translation(LocaleKeys.hint_help).tr;

  @override
  Future<void> execute() async {
    final commandsHelp = _getCommandsHelp(
        _commands ?? (_command != null ? [_command!] : commands), 0);
    LogService.info('''
List available commands:
$commandsHelp
''');
  }

  String _getCommandsHelp(List<Command> commands, int index) {
    commands.sort((a, b) {
      if (a.commandName.startsWith('-') || b.commandName.startsWith('-')) {
        return b.commandName.compareTo(a.commandName);
      }
      return a.commandName.compareTo(b.commandName);
    });
    var result = '';
    for (var command in commands) {
      result += _getCommandHelp(command, index);
      result += _getCommandsHelp(command.childrens, index + 1);
    }
    return result;
  }

  String _getCommandHelp(Command command, int index) {
    var result = '\n ${'  ' * index} ${command.commandName}';
    if (command.alias.isNotEmpty) {
      result += ', ${command.alias.join(', ')}';
    }
    result += ':  ${command.hint}';
    return result;
  }

  @override
  String get codeSample => '';

  @override
  int get maxParameters => 0;

  @override
  List<String> get alias => ['-h'];

  @override
  bool validate() {
    return _commands != null || _command != null || super.validate();
  }
}
