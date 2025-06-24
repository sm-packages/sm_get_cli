import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../interface/command.dart';
import 'init_getxpattern.dart';
import 'init_katteko.dart';

class InitCommand extends Command {
  @override
  String get commandName => 'init';

  @override
  Future<void> execute() async {
    final getxVersionMenu = Menu(
      [
        'GetX 5',
        'GetX 4',
      ],
      title: LocaleKeys.ask_use_getx_version.tr,
    );
    final getxVersionResult = getxVersionMenu.choose();
    PubspecUtilsExt.updateGetCliYaml(
      'version',
      getxVersionResult.index == 0 ? 5 : 4,
    );

    final menu = Menu(
      [
        'GetX Pattern (by Kauê)',
        'CLEAN (by Arktekko)',
      ],
      title: LocaleKeys.ask_use_architecture.tr,
    );
    final result = menu.choose();

    final useStateMenu = Menu(
      [
        LocaleKeys.options_yes.tr,
        LocaleKeys.options_no.tr,
      ],
      title: LocaleKeys.ask_use_create_state.tr,
    );
    final useState = useStateMenu.choose();
    PubspecUtilsExt.updateGetCliYaml(
      'use_state',
      useState.index == 0 ? true : false,
    );

    result.index == 0
        ? await createInitGetxPattern()
        : await createInitKatekko();
    if (!PubspecUtils.isServerProject) {
      await ShellUtils.pubGet();
    }
    return;
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_init).tr;

  @override
  bool validate() {
    super.validate();
    return true;
  }

  @override
  String? get codeSample => LogService.code('get init');

  @override
  int get maxParameters => 0;

  @override
  List<String> get alias => ['-n'];
}
