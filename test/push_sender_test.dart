part of 'app_test.dart';

Future<void> _testPushSenderPage(WidgetTester tester, Finder pageFinder) async {
  final headerTextfieldFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('push_header_textfield')),
  );
  expect(
    headerTextfieldFinder,
    findsOneWidget,
    reason: 'Push header textfield should always exist',
  );
  final textTextfieldFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('push_text_textfield')),
  );
  expect(
    textTextfieldFinder,
    findsOneWidget,
    reason: 'Push text textfield should always exist',
  );
  final bodyTextfieldFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('push_body_textfield')),
  );
  expect(
    bodyTextfieldFinder,
    findsOneWidget,
    reason: 'Push body textfield should always exist',
  );
  var submitButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('submit_form_btn')),
  );
  expect(
    submitButtonFinder,
    findsOneWidget,
    reason: 'Submit button should exist in Initial state',
  );

  var resetButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('reset_form_btn')),
  );
  expect(
    resetButtonFinder,
    findsNothing,
    reason: 'Reset button should not exist in Initial state',
  );

  /// Form validation should prevent submission on bodyTextField invalid input.
  await tester.enterText(bodyTextfieldFinder, 'abcde');
  await tester.pumpAndSettle(const Duration(milliseconds: 300));
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  resetButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('reset_form_btn')),
  );
  expect(
    resetButtonFinder,
    findsNothing,
    reason:
        'Form is meant to be in Initial state, since the submission havent been performed. There is nothing to reset according to Initial state.',
  );

  /// Trying to submit with valid input. State should take Successful state
  await tester.enterText(headerTextfieldFinder, 'Header');
  await tester.enterText(textTextfieldFinder, 'Text');
  await tester.enterText(bodyTextfieldFinder, '{"kkey":"vvalue"}');
  // Bumps into 200 ms debouncer.
  // In real life there is no way user can click on submit that fast after pasting the credentials
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  expect(
    find.descendant(of: pageFinder, matching: find.text('успешно')),
    findsAny,
    reason:
        'The push was successful. There should be some information about that.',
  );
}
