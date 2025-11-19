import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testGoogleAuthPage(WidgetTester tester) async {
  /// Should have
  /// [authJsonTextfieldFinder] - google auth json textfield(always exists)
  /// [submitButtonFinder] - submit button (exists only in initial or error state)
  final authJsonTextfieldFinder = find.byType(TextFormField);
  expect(authJsonTextfieldFinder, findsOneWidget);
  var submitButtonFinder = find.byKey(const ValueKey('submit_form_btn'));
  expect(submitButtonFinder, findsOneWidget);

  /// Should not have
  /// [continueButtonFinder] - button that allows to move to the next step after successful submit (only in error or successful states)
  /// [resetButtonFinder] - reset form state button (only in error or successful states)
  var continueButtonFinder = find.byKey(const ValueKey('continue_form_btn'));
  expect(continueButtonFinder, findsNothing);
  var resetButtonFinder = find.byKey(const ValueKey('reset_form_btn'));
  expect(resetButtonFinder, findsNothing);

  /// Trying to submit without input. State (and layout as well) should not be changed
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = find.byKey(const ValueKey('continue_form_btn'));
  expect(continueButtonFinder, findsNothing);
  resetButtonFinder = find.byKey(const ValueKey('reset_form_btn'));
  expect(resetButtonFinder, findsNothing);

  /// Trying to submit with invalid input. Form should take Error state
  await tester.enterText(authJsonTextfieldFinder, 'abcde');
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  submitButtonFinder = find.byKey(const ValueKey('submit_form_btn'));
  expect(submitButtonFinder, findsOne);
  resetButtonFinder = find.byKey(const ValueKey('reset_form_btn'));
  expect(resetButtonFinder, findsOne);
  await tester.enterText(authJsonTextfieldFinder, '');

  /// Trying to submit without required field. Form keep Error state
  await tester.enterText(authJsonTextfieldFinder, '{"test": "test"}');
  await tester.tap(submitButtonFinder);
  await tester.pumpAndSettle();
  continueButtonFinder = find.byKey(const ValueKey('continue_form_btn'));
  expect(continueButtonFinder, findsNothing);
  await tester.enterText(authJsonTextfieldFinder, '');

  /// Trying to submit with valid input. State should take Successful state
  await tester.enterText(find.byType(TextFormField), '{"project_id": "test"}');
  await tester.tap(authJsonTextfieldFinder);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  continueButtonFinder = find.byKey(const ValueKey('continue_form_btn'));
  expect(continueButtonFinder, findsOne);
}
