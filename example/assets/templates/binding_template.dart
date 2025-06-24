import 'package:get/get.dart';
{{import_path}}

/// {{name}}Binding
class {{name}}Binding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<{{name}}Controller>(
        {{name}}Controller.new,
      ),
    ];
  }
}