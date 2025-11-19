part of 'app_test.dart';

Future<void> _testGoogleAuthPage(WidgetTester tester, Finder pageFinder) async {
  final authJsonTextfieldFinder = find.descendant(
    of: pageFinder,
    matching: find.byType(TextFormField),
  );
  expect(
    authJsonTextfieldFinder,
    findsOneWidget,
    reason: 'Google auth json textfield should always exist',
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

  var continueButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('continue_form_btn')),
  );
  expect(
    continueButtonFinder,
    findsNothing,
    reason: 'Continue button should not exist in Initial state',
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

  /// Trying to submit without input. State (and layout as well) should not be changed
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('continue_form_btn')),
  );
  expect(
    continueButtonFinder,
    findsNothing,
    reason:
        'Form meant to be still in Initial state. Continue button doesnt have to appear in this state.',
  );
  resetButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('reset_form_btn')),
  );
  expect(
    resetButtonFinder,
    findsNothing,
    reason:
        'Form meant to be still in Initial state. Reset button doesnt have to appear in this state.',
  );

  /// Trying to submit with invalid input. Form should take Error state
  await tester.enterText(authJsonTextfieldFinder, 'abcde');
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  submitButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('submit_form_btn')),
  );
  expect(
    submitButtonFinder,
    findsOne,
    reason:
        'Form meant to be in Error state. Submit button has to appear in order to give the user opportunity to resubmit.',
  );
  resetButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('reset_form_btn')),
  );
  expect(
    resetButtonFinder,
    findsOne,
    reason:
        'Form meant to be in Error state. Reset button has to appear in order to give the user opportunity to reset values.',
  );

  /// Trying to submit without required field. Form keep Error state
  await tester.enterText(authJsonTextfieldFinder, '{"test": "test"}');
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('continue_form_btn')),
  );
  expect(
    continueButtonFinder,
    findsNothing,
    reason:
        'The form is still meant to be in Error state. Continue button should to appear.',
  );

  /// Trying to submit with valid input. State should take Successful state
  await tester.enterText(authJsonTextfieldFinder, '{"project_id": "test"}');
  // Bumps into 200 ms debouncer.
  // In real life there is no way user can click on submit that fast after pasting the credentials
  await tester.pumpAndSettle(const Duration(milliseconds: 300));
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = find.descendant(
    of: pageFinder,
    matching: find.byKey(const ValueKey('continue_form_btn')),
  );
  expect(
    continueButtonFinder,
    findsOne,
    reason:
        'The form should take Successful state and give an opportunity for the user to move to the next step.',
  );
}
