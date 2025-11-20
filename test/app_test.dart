import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/app_continer.dart';
import 'package:push_by_token_tester/core/nav/nav_item.dart';

part 'google_auth_test.dart';
part 'device_token_test.dart';

void main() {
  testWidgets('end-to-end', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const App(appContainer: MockAppContainer()));

    /// Basic layout
    expect(
      find.byKey(const ValueKey('app_header')),
      findsOneWidget,
      reason: 'App should have header',
    );
    expect(
      find.byKey(const ValueKey('app_body')),
      findsOneWidget,
      reason: 'App should have body',
    );
    expect(
      find.byKey(const ValueKey('app_footer')),
      findsOneWidget,
      reason: 'App should have body',
    );
    for (final navItem in NavItem.values) {
      expect(
        find.byKey(ValueKey('app_nav_btn_${navItem.index}')),
        findsOneWidget,
        reason: 'Every NavItem should have its presentation',
      );
    }

    /// First step
    final authPageFinder = find.byKey(const ValueKey('google_auth_page'));
    expect(
      find.text(NavItem.values.first.title),
      findsOne,
      reason:
          'Should display title of the first NavItem during the first step.',
    );
    expect(
      authPageFinder,
      findsOneWidget,
      reason: 'Should display GoogleAuthPage during the first step.',
    );
    await _testGoogleAuthPage(tester, authPageFinder);

    /// Transition to second step
    await tester.tap(find.byKey(const ValueKey('continue_form_btn')));
    await tester.pumpAndSettle();

    /// Second step
    expect(
      find.text(NavItem.values[1].title),
      findsOne,
      reason:
          'Should display title of the second NavItem during the second step.',
    );
    final deviceTokenPageFinder = find.byKey(
      const ValueKey('device_token_page'),
    );
    expect(
      deviceTokenPageFinder,
      findsOneWidget,
      reason: 'Should display DeviceTokenPage during the second step.',
    );
    _testDeviceTokenPage(tester, deviceTokenPageFinder);
  });
}
