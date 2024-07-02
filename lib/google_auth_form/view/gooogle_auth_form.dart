import 'package:flutter/material.dart';
import 'package:push_by_token_tester/google_auth_form/model/google_auth_form_model.dart';

class GoogleAuthForm extends StatefulWidget {
  const GoogleAuthForm({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleAuthFormState();
}

class _GoogleAuthFormState extends State<GoogleAuthForm> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final model = GoogleAuthFormModel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: model.isLoading
          ? const CircularProgressIndicator()
          : Form(
              child: Column(
                children: [
                  const Text('Вставьте содержимое json от firebase messaging.'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: textController,
                    validator: (value) =>
                        value!.isEmpty ? 'Не должно быть пустым' : null,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      if (model.isLoading || !context.mounted) return;
                      if (formKey.currentState!.validate()) {
                        final error = await model.auth(textController.text);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                          return;
                        }
                      }
                    },
                    child: const Text('Получить токен от FirebaseMessaging'),
                  ),
                ],
              ),
            ),
    );
  }
}
