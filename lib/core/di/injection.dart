import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

GetIt get getIt => GetIt.instance;

const devEnv = Environment('dev');
const testEnv = Environment('test');

@InjectableInit()
void configureDependencies(String environment) =>
    getIt.init(environment: environment);
