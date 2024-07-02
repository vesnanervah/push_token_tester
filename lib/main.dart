import 'package:flutter/material.dart';
import 'package:push_by_token_tester/google_auth_form/view/gooogle_auth_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Scaffold(
          body: GoogleAuthForm(),
        ),
      );
}
