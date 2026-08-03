import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

class ArcMainSample extends Sample {
  ArcMainSample() : super('lib/main.dart', overwrite: true);

  @override
  String get content => '''import 'package:flutter/material.dart';
${PubspecUtils.getPackageImport}

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
    
  }
}''';
}
