// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart'
    as _i437;
import 'package:push_by_token_tester/push_sender_form/repository/push_repository.dart'
    as _i640;

const String _test = 'test';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i640.PushRepository>(
      () => const _i640.MockPushRepository(),
      registerFor: {_test},
    );
    gh.factory<_i437.GoogleAuthClientRepository>(
      () => const _i437.NetworkGoogleAuthClientRepository(),
      registerFor: {_dev},
    );
    gh.factory<_i640.PushRepository>(
      () => const _i640.NetworkPushRepository(),
      registerFor: {_dev},
    );
    gh.factory<_i437.GoogleAuthClientRepository>(
      () => const _i437.MockGoogleAuthClientRepository(),
      registerFor: {_test},
    );
    return this;
  }
}
