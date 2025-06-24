import 'package:recase/recase.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/replace_vars/replace_vars.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

class CreateViewCommand extends Command {
  @override
  String get commandName => 'view';
  @override
  String? get hint => Translation(LocaleKeys.hint_create_view).tr;

  @override
  bool validate() {
    return true;
  }

  @override
  Future<void> execute() async {
    return createView(
      name,
      withArgument: withArgument.isEmpty
          ? PubspecUtilsTemplates.pageTemplate
          : withArgument,
      onCommand: onCommand,
    );
  }

  @override
  String get codeSample => 'get create view:delete_dialog';

  @override
  int get maxParameters => 0;
}

Future<void> createView(
  String name, {
  String withArgument = '',
  String onCommand = '',
}) async {
  var sample = GetViewSample(
    '',
    '${name.pascalCase}View',
    '',
    '',
    PubspecUtils.isServerProject,
  );
  if (withArgument.isNotEmpty) {
    sample.customContent = await loadContent(withArgument, name);
  }

  final extraFolder = PubspecUtils.extraFolder ?? true;
  handleFileCreate(
    name,
    'view',
    onCommand,
    onCommand.isNotEmpty ? extraFolder : true,
    sample,
    'views',
  );
}
