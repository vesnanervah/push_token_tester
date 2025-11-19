import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/app_continer.dart';

import 'google_auth_test.dart';

void main() {
  testWidgets('end-to-end', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const App(appContainer: MockAppContainer()));

    await testGoogleAuthPage(tester);
  });
}
