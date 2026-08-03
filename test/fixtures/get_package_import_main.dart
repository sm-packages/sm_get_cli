import 'dart:convert';

import 'package:sm_get_cli/common/utils/pubspec/pubspec_utils.dart';
import 'package:sm_get_cli/commands/impl/install/install_get.dart';
import 'package:sm_get_cli/functions/replace_vars/replace_vars.dart';
import 'package:sm_get_cli/samples/impl/arctekko/arc_main.dart';
import 'package:sm_get_cli/samples/impl/arctekko/arc_navigation.dart';
import 'package:sm_get_cli/samples/impl/arctekko/arc_screen.dart';
import 'package:sm_get_cli/samples/impl/get_app_pages.dart';
import 'package:sm_get_cli/samples/impl/get_binding.dart';
import 'package:sm_get_cli/samples/impl/get_controller.dart';
import 'package:sm_get_cli/samples/impl/get_provider.dart';
import 'package:sm_get_cli/samples/impl/get_state.dart';
import 'package:sm_get_cli/samples/impl/get_view.dart';
import 'package:sm_get_cli/samples/impl/getx_pattern/get_main.dart';

Future<void> main() async {
  if (PubspecUtilsExt.useSmGetx) {
    final pubspecBefore = PubspecUtils.pubspecString;
    await installGet();
    if (PubspecUtils.pubspecString != pubspecBefore) {
      throw StateError('use_sm_getx must not change project dependencies');
    }
  }

  final samples = <String, String>{
    'configured import': PubspecUtils.getPackageImport,
    'custom template': replaceVars('@{import}', 'home'),
    'app pages': AppPagesSample().content,
    'binding': BindingSample(
      '',
      'home',
      'HomeBinding',
      'home_controller.dart',
      false,
    ).content,
    'controller': ControllerSample('', 'home', null, false).content,
    'provider': ProviderSample('home').content,
    'state': StateSample('', 'home', false).content,
    'view': GetViewSample('', 'HomeView', '', '', false).content,
    'GetX main': GetXMainSample(isServer: false).content,
    'Clean main': ArcMainSample().content,
    'Clean navigation': ArcNavigationSample().content,
    'Clean screen': (ArcScreenSample('', 'home')..fileName = 'home').content,
    'Clean example screen': (ArcScreenSample(
      '',
      'home',
      isExample: true,
    )..fileName = 'home')
        .content,
  };

  print(jsonEncode(samples));
}
