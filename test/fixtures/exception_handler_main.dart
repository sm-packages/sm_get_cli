import 'package:get_cli/exception_handler/exception_handler.dart';

void main() {
  ExceptionHandler().handle(Exception('fixture failure'));
}
