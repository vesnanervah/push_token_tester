part of 'app_test.dart';

Future<void> _testDeviceTokenPage(
  WidgetTester tester,
  Finder pageFinder,
) async {
  final deviceTokenTextfieldFinder = find.descendant(
    of: pageFinder,
    matching: find.byType(TextFormField),
  );
  expect(
    deviceTokenTextfieldFinder,
    findsOneWidget,
    reason: 'Device token textfield should always exist',
  );
  var submitButtonFinder = _getSubmitButtonFromPage(pageFinder);
  expect(
    submitButtonFinder,
    findsOneWidget,
    reason: 'Submit button should exist in Initial state',
  );

  var continueButtonFinder = _getContinueButtonFromPage(pageFinder);
  expect(
    continueButtonFinder,
    findsNothing,
    reason: 'Continue button should not exist in Initial state',
  );

  /// Trying to submit without input. State (and layout as well) should not be changed
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = _getContinueButtonFromPage(pageFinder);
  expect(
    continueButtonFinder,
    findsNothing,
    reason:
        'Form meant to be still in Initial state. Continue button doesnt have to appear in this state.',
  );

  /// Trying to submit with valid input. State should take Successful state
  await tester.enterText(deviceTokenTextfieldFinder, 'abcde');
  // Bumps into 200 ms debouncer.
  // In real life there is no way user can click on submit that fast after pasting the credentials
  await tester.pumpAndSettle(const Duration(milliseconds: 300));
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = _getContinueButtonFromPage(pageFinder);
  expect(
    continueButtonFinder,
    findsOne,
    reason:
        'The form should take Successful state and give an opportunity for the user to move to the next step.',
  );
}
