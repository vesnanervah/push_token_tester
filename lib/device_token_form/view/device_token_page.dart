import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_form.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/device_token_form/bloc/device_token_bloc.dart';

part 'device_token_form.dart';

class DeviceTokenPage extends StatelessWidget {
  const DeviceTokenPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => DeviceTokenBloc(context.read<AppModel>()),
    child: const _DeviceTokenForm(),
  );
}
