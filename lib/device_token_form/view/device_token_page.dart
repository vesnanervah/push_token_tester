import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/base_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';
import 'package:push_by_token_tester/device_token_form/device_token_form.dart';

part 'device_token_form.dart';

class DeviceTokenPage extends StatefulWidget {
  const DeviceTokenPage({super.key});

  @override
  State<DeviceTokenPage> createState() => _DeviceTokenPageState();
}

class _DeviceTokenPageState extends State<DeviceTokenPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => context.read<AppBloc>().state.hasAuthData;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => DeviceTokenBloc(),
      child: const _DeviceTokenForm(),
    );
  }
}
