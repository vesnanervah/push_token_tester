import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/injection.dart';

void main() {
  configureDependencies(Environment.dev);
  runApp(const App());
}
