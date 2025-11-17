import 'package:flutter/widgets.dart';
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/app_continer.dart';

void main() {
  runApp(const App(appContainer: MockAppContainer()));
}
