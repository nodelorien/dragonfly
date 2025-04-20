// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dragonfly/dragonfly.dart' as _i983;

import '../data/repositories/character_repository.dart' as _i388;
import '../domain/use_cases/get_user_list_use_case.dart' as _i768;

extension DragonflyContainerInjectableX on _i983.DragonflyContainer {
// initializes the registration of main-scope dependencies inside of GetIt
  _i983.DragonflyContainer init({
    String? environment,
    _i983.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i983.DragonflyContainerHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i388.CharacterRepository>(() => _i388.CharacterRepository());
    gh.factory<_i768.GetUserListUseCase>(() => _i768.GetUserListUseCase(
        userRepository: gh<_i388.CharacterRepository>()));
    return this;
  }
}
