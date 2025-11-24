import 'package:flutter/widgets.dart';
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/injection.dart';

void main() {
  configureDependencies('test');
  runApp(const App());
}
